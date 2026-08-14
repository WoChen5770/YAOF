<p align="center">
<img width="768" src="https://raw.githubusercontent.com/QiuSimons/Others/master/YAOF.png" >
</p>
<p align="center">
<img src="https://github.com/Tired-Fox/cargors/raw/aabd34c/assets/badges/built_with_love.svg">
<p>
<p align="center">
<img alt="GitHub All Releases" src="https://img.shields.io/github/downloads/QiuSimons/YAOF/total?style=for-the-badge">
<img alt="GitHub" src="https://img.shields.io/github/license/QiuSimons/YAOF?style=for-the-badge">
<p>
<p align="center">
<img src="https://github.com/WoChen5770/YAOF/workflows/X86-OpenWrt/badge.svg">
<p>


<h1 align="center">请勿用于商业用途!!!</h1>

### 特性

- 基于原生 OpenWrt 25.12 编译，默认管理地址 192.168.1.1
- 支持 LuCI 手动升级（sysupgrade），物理 Reset 按键可用
- 预配置了部分插件
- 可无脑 apk 安装/卸载内核模块（kmod）
- 仅编译 x86_64 通用机型（Generic x86_64）固件
- O2 编译，CFLAG 优化
- 插件包含：PassWall、DAEDE（DAE/DAED 统一管理界面）、AdGuard Home、EasyTier、EINAT、Bandix（流量监控）、UPnP、AirConnect（AirPlay 音频投送）、ap-modem、Aurora 主题及配置、软件包管理器（apk）、定时任务、分区扩展、内存释放、微信推送、htop、coremark 等
- 集成并默认启用了 BBRv3、LRNG
- 内置 FullCone NAT 与 Shortcut-FE（防火墙页面可开关）；Shortcut-FE 与 nft flow offloading 请二选一启用，避免冲突
- 未集成 Docker；需要 Docker 请自行安装或选择其他固件
- 内置一键格式化剩余空间并挂载插件（luci-app-partexp）
- 如有任何问题，请先尝试 ssh 进入后台，输入 fuck 后回车，等待机器重启后确认问题是否已经解决

### 下载

- 下载 [X86-64 固件](https://github.com/WoChen5770/YAOF/releases)

### 鸣谢

|               [ImmortalWrt](https://github.com/immortalwrt)               |              [coolsnowwolf](https://github.com/coolsnowwolf)              |                    [Lienol](https://github.com/Lienol)                    |
| :-----------------------------------------------------------------------: | :-----------------------------------------------------------------------: | :-----------------------------------------------------------------------: |
| <img width="60" src="https://avatars.githubusercontent.com/u/53193414"/>  | <img width="60" src="https://avatars.githubusercontent.com/u/31687149" /> | <img width="60" src="https://avatars.githubusercontent.com/u/23146169" /> |
|            [NoTengoBattery](https://github.com/NoTengoBattery)            |                    [tty228](https://github.com/tty228)                    |                  [destan19](https://github.com/destan19)                  |
| <img width="60" src="https://avatars.githubusercontent.com/u/11285513" /> | <img width="60" src="https://avatars.githubusercontent.com/u/33397881" /> | <img width="60" src="https://avatars.githubusercontent.com/u/3950091" />  |
|                 [jerrykuku](https://github.com/jerrykuku)                 |                    [lisaac](https://github.com/lisaac)                    |             [rufengsuixing](https://github.com/rufengsuixing)             |
| <img width="60" src="https://avatars.githubusercontent.com/u/9485680" />  | <img width="60" src="https://avatars.githubusercontent.com/u/3320969" />  | <img width="60" src="https://avatars.githubusercontent.com/u/22387141" /> |
|                     [ElonH](https://github.com/ElonH)                     |                   [NateLol](https://github.com/NateLol)                   |                   [kiddin9](https://github.com/kiddin9)                   |
| <img width="60" src="https://avatars.githubusercontent.com/u/32666230" /> | <img width="60" src="https://avatars.githubusercontent.com/u/5166306" />  | <img width="60" src="https://avatars.githubusercontent.com/u/48883331" /> |
|              [AmadeusGhost](https://github.com/AmadeusGhost)              |                [1715173329](https://github.com/1715173329)                |                 [vernesong](https://github.com/vernesong)                 |
| <img width="60" src="https://avatars.githubusercontent.com/u/42570690" /> | <img width="60" src="https://avatars.githubusercontent.com/u/22235437" /> | <img width="60" src="https://avatars.githubusercontent.com/u/42875168" /> |
