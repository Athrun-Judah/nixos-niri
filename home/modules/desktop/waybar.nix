{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    # 启用 Systemd 自动启动
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        margin-top = 6;
        margin-left = 10;
        margin-right = 10;
        spacing = 4;

        # 左中右模块布局
        modules-left = [ "niri/workspaces" "niri/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" "tray" ];

        # --- 模块配置 ---
        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "";
            default = "";
          };
        };

        "clock" = {
          format = " {:%H:%M   %Y-%m-%d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = " Muted";
          format-icons = {
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };

        "network" = {
          format-wifi = "  {essid}";
          format-ethernet = "󰈀 Eth";
          format-disconnected = " Disconnected";
          tooltip-format = "{ifname} via {gwaddr}";
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-icons = ["" "" "" "" ""];
        };
      };
    };

    # ===========================
    # CSS 样式 (Stylix 注入颜色变量)
    # ===========================
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Sarasa Gothic SC";
        font-size: 14px;
        font-weight: bold;
      }

      window#waybar {
        background-color: transparent; /* 背景透明，由模块背景决定 */
      }

      /* 胶囊样式通用设置 */
      .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
      }

      .modules-right > widget:last-child > #workspaces {
        margin-right: 0;
      }

      /* 工作区 */
      #workspaces {
        background-color: #${config.lib.stylix.colors.base01};
        color: #${config.lib.stylix.colors.base05};
        border-radius: 15px;
        padding-left: 10px;
        padding-right: 10px;
        margin-right: 10px;
      }

      #workspaces button.active {
        color: #${config.lib.stylix.colors.base0B}; /* 激活为绿色 */
      }

      /* 中间时钟 */
      #clock {
        background-color: #${config.lib.stylix.colors.base01};
        color: #${config.lib.stylix.colors.base0D}; /* 蓝色 */
        border-radius: 15px;
        padding-left: 15px;
        padding-right: 15px;
      }

      /* 右侧模块通用 */
      #pulseaudio, #network, #cpu, #memory, #battery, #tray {
        background-color: #${config.lib.stylix.colors.base01};
        color: #${config.lib.stylix.colors.base05};
        padding: 5px 15px;
        border-radius: 15px;
        margin-left: 6px;
      }

      /* 特殊颜色强调 */
      #pulseaudio { color: #${config.lib.stylix.colors.base0C}; } /* 青色 */
      #network { color: #${config.lib.stylix.colors.base0E}; }    /* 紫色 */
      #battery.charging { color: #${config.lib.stylix.colors.base0B}; }
      #battery.warning { color: #${config.lib.stylix.colors.base0A}; }
      #battery.critical { color: #${config.lib.stylix.colors.base08}; }
    '';
  };
}
