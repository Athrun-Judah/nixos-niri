{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    swww
    libnotify
    wl-clipboard
    swaylock-effects
    swayidle
    grim
    slurp
    wl-clipboard
    libnotify
    swappy
  ];

  # 锁屏配置
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      clock = true;
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;
      effect-blur = "7x5"; # 模糊背景
      effect-vignette = "0.5:0.5";
      # Stylix 会自动配置颜色，这里只需要配置特效
    };
  };

  # 空闲自动锁屏服务
  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock-effects}/bin/swaylock -f"; }
      { event = "lock"; command = "${pkgs.swaylock-effects}/bin/swaylock -f"; }
    ];
    timeouts = [
      # 5分钟不操作 -> 锁屏
      { timeout = 300; command = "${pkgs.swaylock-effects}/bin/swaylock -f"; }
      # 10分钟不操作 -> 关闭屏幕
      { timeout = 600; command = "niri msg action power-off-monitors"; resumeCommand = "niri msg action power-on-monitors"; }
    ];
  };

  programs.niri.settings = {
    # 引用 Stylix 颜色
    layout.border = {
      enable = true;
      active.color = "#${config.lib.stylix.colors.base0D}";
      inactive.color = "#${config.lib.stylix.colors.base02}";
    };

    spawn-at-startup = [
      { command = ["waybar"]; }
      { command = ["fcitx5" "-d"]; }
      { command = ["swww-daemon"]; }
      { command = ["${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"]; }
    ];

    window-rules = [
      # 让 Steam 的某些对话框浮动 (好友列表, 设置等)
      {
        geometry-corner-radius = let r = 12.0; in {
          top-left = r; top-right = r; bottom-left = r; bottom-right = r;
        };
        clip-to-geometry = true;
      }

      # Steam 主窗口 - 稍微变大一点
      {
        matches = [{ app-id = "^steam$"; }];
        open-maximized = true;
      }

      # 强制 Steam 的子窗口 (如下载进度、属性) 浮动
      {
        matches = [{ app-id = "^steam$"; title = "^(?!Steam).*$"; }];
        open-floating = true;
      }

      # 许多游戏默认不是最大化的，强制全屏
      {
        matches = [
          { app-id = "steam_app_.*"; } # 匹配所有 Steam 游戏 ID
          { app-id = "lutris"; }
          { app-id = "heroic"; }
        ];
        open-fullscreen = true;
        # 玩游戏时禁止自动锁屏/黑屏
        block-out-from = "screen-idle";
      }

      # 画中画浮动
      {
        matches = [{ title = "Picture-in-Picture"; }];
        open-floating = true;
        default-column-width = { proportion = 0.3; };
      }
    ];

    binds = with config.lib.niri.actions; {
      "Mod+Return".action = spawn "rio";
      "Mod+D".action = spawn "fuzzel";
      "Mod+Q".action = close-window;
      "Mod+Shift+E".action = quit;
      "Print".action = screenshot;

      # 剪贴板历史菜单 (Mod + V)
      "Mod+V".action = spawn "sh" "-c" "cliphist list | fuzzel -d | cliphist decode | wl-copy";

      # 窗口管理键位...
      # --- 硬件控制 ---
      # 音量 (需要安装 pamixer)
      "XF86AudioRaiseVolume".action = spawn "pamixer" "-i" "5";
      "XF86AudioLowerVolume".action = spawn "pamixer" "-d" "5";
      "XF86AudioMute".action = spawn "pamixer" "-t";

      # 亮度 (需要安装 brightnessctl)
      "XF86MonBrightnessUp".action = spawn "brightnessctl" "s" "10%+";
      "XF86MonBrightnessDown".action = spawn "brightnessctl" "s" "10%-";

      # 媒体控制 (需要安装 playerctl)
      "XF86AudioPlay".action = spawn "playerctl" "play-pause";
      "XF86AudioNext".action = spawn "playerctl" "next";
      "XF86AudioPrev".action = spawn "playerctl" "previous";

      # 截图
      # 1. [Shift + Print] 选定区域 -> 复制到剪贴板
      "Shift+Print".action = spawn "sh" "-c" ''
        grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot" "Area copied to clipboard"
      '';

      # 2. [Ctrl + Print] 选定区域 -> 保存到文件 (~/Pictures/Screenshots)
      "Ctrl+Print".action = spawn "sh" "-c" ''
        mkdir -p ~/Pictures/Screenshots && \
        grim -g "$(slurp)" ~/Pictures/Screenshots/Screenshot-$(date +%Y-%m-%d_%H-%M-%S).png && \
        notify-send "Screenshot" "Saved to ~/Pictures/Screenshots/"
      '';

      # 3. [Print] 全屏 -> 复制到剪贴板
      "Print".action = spawn "sh" "-c" ''
        grim - | wl-copy && notify-send "Screenshot" "Fullscreen copied to clipboard"
      '';

      # 4. [Alt + Print] 全屏 -> 保存到文件
      "Alt+Print".action = spawn "sh" "-c" ''
        mkdir -p ~/Pictures/Screenshots && \
        grim ~/Pictures/Screenshots/Screenshot-$(date +%Y-%m-%d_%H-%M-%S).png && \
        notify-send "Screenshot" "Fullscreen saved to file"
      '';

      # 5. [Super + Shift + S]选定区域 -> 打开编辑器 (Swappy), 按 Ctrl+C 复制编辑后的图，或按 Ctrl+S 保存
      "Mod+Shift+S".action = spawn "sh" "-c" ''
        grim -g "$(slurp)" - | swappy -f -
      '';
    };
  };

  programs.fuzzel.enable = true;
  programs.mako.enable = true;
}
