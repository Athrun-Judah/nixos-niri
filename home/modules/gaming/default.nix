{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    # --- 游戏启动器 ---
    lutris        # 通用游戏启动器 (GOG, Origin, Battle.net 等)
    heroic        # Epic Games 和 GOG 的开源客户端 (推荐)

    # --- 工具 ---
    protonup-qt   # 图形化管理 Proton-GE 版本 (必装)
    winetricks    # Wine 依赖管理
    wineWow64Packages.stable # 系统级 Wine (备用)

    # --- CachyOS 特有优化包 ---
    # cachyos-settings # (如果在 chaotic 模块中已启用则不需要)
  ];

  # MangoHud (FPS 显示)
  programs.mangohud = {
    enable = true;
    # Stylix 会自动配置颜色，但我们可以微调布局
    settings = {
      cpu_temp = true;
      gpu_temp = true;
      ram = true;
      vram = true;
      fps = true;
      frametime = true;

      # 快捷键：右 Shift + F12 切换显示
      toggle_hud = "Shift_R+F12";

      # 外观
      round_corners = 10;
      background_alpha = 0.5;
    };
  };

  # Gamescope (微型合成器)
  # 通常作为命令运行: gamescope -W 2560 -H 1600 -r 165 -- %command%
  # 这里安装它
  home.packages = [ pkgs.gamescope ];
}
