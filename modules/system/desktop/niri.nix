{ pkgs, inputs, ... }:

{
  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.system}.niri;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # 必要的门户服务
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome ];
    config.common.default = "gtk";
  };

  services.gnome.gnome-keyring.enable = true;

  # 允许 Swaylock 验证密码
  security.pam.services.swaylock = {};


}
