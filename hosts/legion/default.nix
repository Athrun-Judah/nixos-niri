{ pkgs, ... }:

{
  imports = [
    ./hardware.nix # 记得安装时生成这个文件！

    ../../modules/system/boot.nix
    ../../modules/system/nvidia.nix
    ../../modules/system/core.nix

    ../../modules/system/desktop/niri.nix
    ../../modules/system/desktop/stylix.nix

    ../../modules/system/apps/brave.nix

    ../../modules/system/utils.nix
    ../../modules/system/gaming.nix
  ];

  system.stateVersion = "25.05";
}
