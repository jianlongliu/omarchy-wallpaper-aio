#!/usr/bin/env bash
# omarchy-wallpaper-aio — 把自己的自定义壁纸库软链成 Omarchy 各主题的背景目录
# 让 `omarchy theme bg next` / 背景选择器能从你的壁纸库遍历换图。
#
# 用法:
#   ./setup.sh                          # 用默认 ~/Pictures/wallpapers 作为壁纸库
#   ./setup.sh /path/to/your/wallpapers # 用自定义壁纸库路径
#   WALLPAPER_LIB=/x ./setup.sh         # 或用环境变量
set -euo pipefail

# 壁纸库根目录：默认 ~/Pictures/wallpapers，可传参或环境变量覆盖
LIB="${1:-${WALLPAPER_LIB:-$HOME/Pictures/wallpapers}}"
LIB="$(realpath "$LIB")"

if [[ ! -d "$LIB" ]]; then
  echo "错误：壁纸库目录不存在 -> $LIB" >&2
  echo "请先建目录并放图，或传对路径再跑。" >&2
  exit 1
fi

BG_ROOT="$HOME/.config/omarchy/backgrounds"
mkdir -p "$BG_ROOT"

# 遍历用户已安装主题目录（~/.config/omarchy/themes/<theme>）
# 对每个主题，把 ~/.config/omarchy/backgrounds/<theme> 软链到壁纸库。
linked=()
skipped=()
for theme_dir in "$HOME"/.config/omarchy/themes/*/; do
  [[ -d "$theme_dir" ]] || continue
  theme="$(basename "$theme_dir")"
  target="$BG_ROOT/$theme"

  if [[ -L "$target" ]]; then
    skipped+=("$theme (已是软链: $(readlink "$target"))")
    continue
  fi
  if [[ -e "$target" ]]; then
    # 已存在真实目录（非软链），不动它，避免覆盖用户现有配置
    skipped+=("$theme (已是真实目录，跳过)")
    continue
  fi
  ln -s "$LIB" "$target"
  linked+=("$theme")
done

echo "=== omarchy-wallpaper-aio ==="
echo "壁纸库: $LIB"
echo
echo "-- 已软链 --"
printf '  %s\n' "${linked[@]:-（无）}"
echo "-- 跳过 --"
printf '  %s\n' "${skipped[@]:-（无）}"
echo
if ((${#linked[@]} > 0)); then
  echo "完成。现在用 \`omarchy theme bg next\` 或背景选择器即可从你的壁纸库换图。"
else
  echo "没有新主题需要接线（都已是软链或真实目录）。"
fi
