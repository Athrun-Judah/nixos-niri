{ pkgs, ... }:

{
  programs.brave = {
    enable = true;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--enable-wayland-ime" # 支持 Fcitx5 输入
      "--disable-features=BraveRewards,BraveWallet,BraveVPN"
    ];
  };

  programs.librewolf = {
    enable = true;
    # Librewolf 的设置
    settings = {
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false; # 有时候会影响深色模式检测
    };
  };
}
