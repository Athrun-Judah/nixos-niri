{ pkgs, config, ... }:

{
  # --- CachyOS Kernel ---
  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  # CachyOS 缓存 (极大加速编译)
  chaotic.nyx.cache.enable = true;

  # SCX 调度器 (游戏性能优化)
  services.scx = {
    enable = true;
    scheduler = "scx_rusty";
  };

  # --- Limine Bootloader ---
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = false;

  boot.loader.limine = {
    enable = true;
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

}
