{ pkgs, config, ... }:

{
  services.cliphist = {
    enable = true;
    allowImages = true; # 允许复制图片进历史
  };

  # 配合 Niri 的快捷键 (需要在 home/modules/desktop/niri.nix 中绑定)
  # 绑定逻辑：
  # cliphist list | fuzzel -d | cliphist decode | wl-copy
}
