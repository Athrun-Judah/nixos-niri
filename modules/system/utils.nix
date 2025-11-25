{ pkgs, ... }:

{
  # 1. 蓝牙与连接
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket"; # 更好的音频支持
      };
    };
  };
  # 启用 Blueman (蓝牙图形管理界面)
  services.blueman.enable = true;

  # 2. 磁盘挂载与 USB 支持
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  # 支持 NTFS (Windows 盘)
  boot.supportedFilesystems = [ "ntfs" ];

  # 3. 电源管理 (笔记本必备)
  services.upower.enable = true; # 让 Waybar 显示电量

  # 只有在不使用 Gnome/KDE 这种完整桌面时，才需要 tlp 或 auto-cpufreq
  # 由于你玩游戏，我们使用 power-profiles-daemon (与 gamemode 兼容性更好)
  services.power-profiles-daemon.enable = true;

  # 4. 音频
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig = {
      "99-bluez-config.conf" = {
        "bluez5.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-ldac" = true; # 需要 bluez-alsa
          "bluez5.enable-aptx" = true; # 需要 bluez-alsa
          "bluez5.enable-aptx-hd" = true; # 需要 bluez-alsa
        };
      };
    };
  };

  pkgs.bluez-alsa;

  # 5. 安全与其他
  # 开启 Polkit 认证代理服务 (后面会在 home 里配置 GUI 代理)
  security.polkit.enable = true;

  # 打印机支持 (如果需要)
  # services.printing.enable = true;
}
