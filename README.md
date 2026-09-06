# omarchy-wallpaper-aio

把你的**自定义壁纸库**接到 Omarchy——让主题的背景选择器能从你自己的壁纸库换图，而不是只能翻各主题自带的几张。

不含壁纸图、不含取色/matugen。只做一件事：**把每个主题的背景目录软链到你自己的壁纸库**。

## 你的机器现在是怎么存的

Omarchy 换壁纸按**主题**走。背景选择器 / `omarchy theme bg next` 会遍历两个目录（见 `omarchy-theme-bg-switcher` / `omarchy-theme-bg-next`）：

1. `~/.local/state/omarchy/current/theme/backgrounds` — 当前主题自带的图
2. `~/.config/omarchy/backgrounds/<当前主题>` — 你的**用户覆盖目录**

Omarchy 官方会让每个主题各自带一小撮图。这套方案相反：**把 `~/.config/omarchy/backgrounds/<每个主题>` 设成软链，统一指向你自己的壁纸库**（默认 `~/Pictures/wallpapers`）。于是不管切到哪个主题，背景选择器翻到的都是你自己攒的那堆图。

```
~/Pictures/wallpapers                ← 你的壁纸库（唯一真身，76 张…随你加）
   └── 由 setup.sh 软链给每个主题 ↓
~/.config/omarchy/backgrounds/
   ├── tonal-spot  → ~/Pictures/wallpapers   （软链）
   ├── expressive → ~/Pictures/wallpapers   （软链）
   └── ...
```

选中的图由 Omarchy 自己写进状态软链 `~/.local/state/omarchy/current/background`，桌面 / 锁屏 / 登录界面随它同步——这套不归本仓库管，是 Omarchy 原生行为。

> 注：本仓库自己运行时用的是绝对路径写死的软链（本机无所谓）。**发布版 setup.sh 不写死**——用 `$HOME` 加可配置路径，谁都能装。

## 安装（被使用者）

```bash
git clone https://github.com/jianlongliu/omarchy-wallpaper-aio.git
cd omarchy-wallpaper-aio

# 默认把 ~/Pictures/wallpapers 当成壁纸库，软链给所有已装主题
./setup.sh

# 或指定你自己的壁纸库目录
./setup.sh /path/to/my/wallpapers
```

它只**新增软链**，不删不改你已有的真实目录（比如 `catppuccin` 那种自带一堆图的目录会被跳过），可反复运行。

装完：`omarchy theme bg next` 或背景选择器就能从你的壁纸库换图了。

## 你的壁纸库在哪？

仓库不含任何壁纸图。`setup.sh` 需要你本地已有壁纸库目录（默认 `~/Pictures/wallpapers`）。往里放图、或改传路径即可，`bg next` / 选择器会自动认到新增的图。

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
