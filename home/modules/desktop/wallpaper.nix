{ pkgs, lib, ... }:

let
  # 定义壁纸目录的路径 (引用当前文件同级目录下的 wallpapers 文件夹)
  # 这样这些图片会被自动复制到 Nix Store 中
  wallpaperDir = ./wallpapers;

  # 定义切换壁纸的脚本
  changeWallpaperScript = pkgs.writeShellScriptBin "change-wallpaper" ''
    # 查找目录下的所有文件，随机排序，取第一个
    WALLPAPER=$(${pkgs.findutils}/bin/find ${wallpaperDir} -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | ${pkgs.coreutils}/bin/shuf -n 1)

    # 使用 swww 切换壁纸
    # --transition-type random: 随机过渡动画
    # --transition-step 90: 动画速度 (越大越快)
    # --transition-fps 60: 帧率
    if [ -n "$WALLPAPER" ]; then
      ${pkgs.swww}/bin/swww img "$WALLPAPER" --transition-type random --transition-step 90 --transition-fps 60
    fi
  '';
in
{
  # 确保安装了 swww
  home.packages = [ pkgs.swww ];

  # ===========================
  # Systemd Service (执行者)
  # ===========================
  systemd.user.services.wallpaper-changer = {
    Unit = {
      Description = "Randomly change desktop wallpaper using swww";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      # 执行上面定义的脚本
      ExecStart = "${changeWallpaperScript}/bin/change-wallpaper";
      Type = "oneshot"; # 运行一次就结束
      IOSchedulingClass = "idle"; # 低优先级，不抢占前台性能
    };
  };

  # ===========================
  # Systemd Timer (定时器)
  # ===========================
  systemd.user.timers.wallpaper-changer = {
    Unit = {
      Description = "Timer to change wallpaper every 30 minutes";
    };

    Timer = {
      # 启动后多久开始第一次运行
      OnBootSec = "1m";
      # 之后每隔多久运行一次 (这里设为 30分钟，你可以改成 1h, 15m 等)
      OnUnitActiveSec = "10m";
      Persistent = true;
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
