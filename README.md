# omarchy-wallpaper-aio

把你的**自定义壁纸库**接到 Omarchy——让主题的背景选择器能从你自己的壁纸库换图，而不是只能翻各主题自带的几张。

不含壁纸图、不含取色/matugen。只做一件事：**把 `~/.config/omarchy/backgrounds/<主题>` 建成软链，指向你自己的壁纸库**。

## 原理：Omarchy 怎么找背景图

Omarchy 换壁纸按**主题**走。背景选择器 / `omarchy theme bg next` 会遍历两个目录（见 `omarchy-theme-bg-switcher` / `omarchy-theme-bg-next`）：

1. `~/.local/state/omarchy/current/theme/backgrounds` — 当前主题自带的图
2. `~/.config/omarchy/backgrounds/<当前主题>` — 用户级背景目录

Omarchy 官方会让每个主题各自带一小撮图。这套方案相反：**在 `~/.config/omarchy/backgrounds/<主题>` 建一条软链，指出去、统一指向同一个壁纸库目录**（默认 `~/Pictures/wallpapers`）。软链只是"指出去看那个目录"，不复制任何图。于是不管切到哪个主题，背景选择器翻到的都是同一个壁纸库里的图。

```
~/.config/omarchy/backgrounds/           这里是软链的落点
   ├── tonal-spot   →  ~/Pictures/wallpapers    (软链)
   ├── expressive   →  ~/Pictures/wallpapers    (软链)
   └── …

~/Pictures/wallpapers                    壁纸库，所有软链都指向它
```

选中的图由 Omarchy 自己写进状态软链 `~/.local/state/omarchy/current/background`，桌面 / 锁屏 / 登录界面随它同步——这套是 Omarchy 原生行为，不归本仓库管。

## 安装（被使用者）

```bash
git clone https://github.com/jianlongliu/omarchy-wallpaper-aio.git
cd omarchy-wallpaper-aio

# 默认把 ~/Pictures/wallpapers 当成壁纸库，软链给所有已装主题
./setup.sh

# 或指定你自己的壁纸库目录
./setup.sh /path/to/my/wallpapers
```

它只**新增软链**：对每一个**用户已安装的主题**（`~/.config/omarchy/themes/*`）在 `backgrounds/<主题>` 建软链。不删、不改任何真实目录；该目录已经是软链或已是真实目录的主题会被跳过，所以**可反复运行、不产生副作用**。

> 注意：它只接"用户已装主题"。系统自带主题在 `/usr/share/omarchy/themes/`（如 `catppuccin`），除非你先 `omarchy theme install` 装一份到用户目录，否则 setup.sh 不会碰它们。

装完：`omarchy theme bg next` 或背景选择器就能从你的壁纸库换图了。

## 前提：先有壁纸库

本仓库**不含任何壁纸图**，只提供接线脚本。运行 `setup.sh` 前你本地要已有一个壁纸库目录（默认 `~/Pictures/wallpapers`，`./setup.sh` 没传路径时用它；也可 `./setup.sh /path/to/my/wallpapers` 换目录）。

建好后往里放图即可，`bg next` / 背景选择器会自动认到新增的图，不需要重跑 setup。

## 脚本结构

| 文件 | 作用 |
|---|---|
| `setup.sh` | 遍历 `~/.config/omarchy/themes/*`，把每个主题的 `backgrounds/<theme>` 软链到壁纸库 |
| `README.md` | 说明文档 |

## 还原

```bash
# 删掉 setup.sh 建的软链即可（仅软链，壁纸库原图不动）
find ~/.config/omarchy/backgrounds -maxdepth 1 -type l -delete
```

## License

MIT
