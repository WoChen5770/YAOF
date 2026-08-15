#!/bin/bash

# Resolve the OpenWrt release series from the build context instead of keeping
# it in sync manually across several scripts and workflow fields.
normalize_openwrt_release_series() {
  local value="${1:-}"

  value="${value#refs/heads/}"
  value="${value#refs/tags/}"
  value="${value#origin/}"
  value="${value#openwrt-}"
  value="${value#v}"

  if [[ "$value" =~ ^([0-9]+)\.([0-9]+)(\.[0-9]+)?$ ]]; then
    printf '%s.%s\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
    return 0
  fi

  return 1
}

detect_openwrt_release_series() {
  local candidate
  local detected
  local git_branch=""
  local git_tag=""
  local origin_head=""

  git_branch="$(git branch --show-current 2>/dev/null || true)"
  git_tag="$(git describe --tags --exact-match 2>/dev/null || true)"
  origin_head="$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || true)"

  for candidate in \
    "${OPENWRT_RELEASE_SERIES:-}" \
    "${OPENWRT_RELEASE:-}" \
    "${GITHUB_BASE_REF:-}" \
    "${GITHUB_REF_NAME:-}" \
    "${GITHUB_HEAD_REF:-}" \
    "$git_branch" \
    "$git_tag" \
    "$origin_head"; do
    if detected="$(normalize_openwrt_release_series "$candidate")"; then
      printf '%s\n' "$detected"
      return 0
    fi
  done

  echo "Error: unable to determine the OpenWrt release series from the build context." >&2
  echo "Set OPENWRT_RELEASE_SERIES (for example, the numeric release branch name) and retry." >&2
  return 1
}

openwrt_release_is_valid() {
  local release="${1:-}"
  local series="${2:-}"
  local escaped_series="${series//./\\.}"

  [[ -n "$series" && "$release" =~ ^${escaped_series}\.[0-9]+$ ]]
}

resolve_openwrt_release() {
  local series
  local release="${OPENWRT_RELEASE:-}"
  local pinned_release=""
  local releases_url="${OPENWRT_RELEASES_URL:-https://downloads.openwrt.org/releases/}"
  local escaped_series
  local releases_index
  local available_releases
  local resolved_release=""

  series="$(detect_openwrt_release_series)" || return 1

  release="${release#v}"
  pinned_release="$release"
  if ! releases_index="$(
    curl -fsSL \
      --retry 5 \
      --retry-delay 2 \
      --retry-all-errors \
      --connect-timeout 15 \
      --max-time 90 \
      "$releases_url"
  )"; then
    echo "Error: unable to download the OpenWrt release index: $releases_url" >&2
    return 1
  fi

  escaped_series="${series//./\\.}"
  resolved_release="$(
    printf '%s\n' "$releases_index" \
      | grep -oE "href=\"${escaped_series}\.[0-9]+/" \
      | sed -E 's/^href="//; s#/$##' \
      | LC_ALL=C sort -V \
      | tail -n 1
  )"
  available_releases="$(
    printf '%s\n' "$releases_index" \
      | grep -oE "href=\"${escaped_series}\.[0-9]+/" \
      | sed -E 's/^href="//; s#/$##'
  )"

  # An explicit pin must still exist on the official download index; otherwise
  # the build would only fail later while fetching release artifacts.
  if [ -n "$pinned_release" ]; then
    if ! grep -qxF "$pinned_release" <<<"$available_releases"; then
      echo "Error: OPENWRT_RELEASE '$pinned_release' was not found for series '$series' at $releases_url" >&2
      return 1
    fi
  fi

  release="$pinned_release"
  if [ -z "$release" ]; then
    release="$resolved_release"
  fi

  if ! openwrt_release_is_valid "$release" "$series"; then
    echo "Error: no stable OpenWrt release was found for series '$series' at $releases_url" >&2
    return 1
  fi

  printf '%s\n' "$release"
}
