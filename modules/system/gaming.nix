{ pkgs, inputs, ... }:

{
  # 1. Steam (系统级)
  programs.steam = {
    enable = true;

    # 启用 Gamescope 会话支持 (允许在 Steam Big Picture 中直接使用 Gamescope)
    gamescopeSession.enable = true;

    # 开放防火墙端口 (用于 Steam Remote Play 和局域网联机)
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;

    # 修正一些 Wayland 下的兼容性问题
    extraCompatPackages = with pkgs; [
      proton-ge-bin # 预装 GE-Proton
    ];
  };

  # 2. Gamemode (性能模式)
  programs.gamemode = {
    enable = true;
    enableRenice = true; # 提高游戏进程优先级

    settings = {
      general = {
        renice = 10;
      };
      # 显卡优化脚本 (NVIDIA)
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };

  # 确保 32位 库支持 (Steam 很多老游戏需要)
  hardware.graphics.enable32Bit = true;
}
