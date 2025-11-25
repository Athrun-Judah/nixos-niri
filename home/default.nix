{ username, ... }:

{
  imports = [
    # 导入拆分后的模块
    ./modules/shell/fish.nix
    ./modules/shell/starship.nix
    ./modules/terminals/rio.nix
    ./modules/terminals/yazi.nix
    ./modules/editors/helix.nix
    ./modules/editors/zed.nix
    ./modules/browsers/default.nix
    ./modules/desktop/niri.nix
    ./modules/desktop/waybar.nix
    ./modules/desktop/clipboard.nix
    ./modules/desktop/wallpaper.nix
    ./modules/input/fcitx5.nix
    ./modules/tools/common.nix
    ./modules/dev/default.nix
    ./modules/gaming/default.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";
}
