{ pkgs, ... }:

{
  # Zed 目前在 Nixpkgs 中更新较快，但 Home Manager 原生模块支持可能有限。
  # 我们作为普通包安装，配置通常还在 ~/.config/zed 中手动管理，
  # 或者使用 xdg.configFile 来声明。
  home.packages = [ pkgs.zed-editor ];

  # 尝试通过 XDG 写入配置 (Zed 预览版支持 JSON 配置)
  xdg.configFile."zed/settings.json".text = builtins.toJSON {
    ui_font_size = 16;
    buffer_font_size = 16;
    theme = {
      mode = "system";
      light = "Gruvbox Light";
      dark = "Gruvbox Dark Soft";
    };
    ui_font_family = "Noto Serif";
    buffer_font_family = "JetBrainsMono Nerd Font";
    buffer_font_fallbacks = ["Noto Serif"];
    helix_mode = true;
    terminal = {
      font_family = "JetBrainsMono NF";
      font_fallbacks = "Noto Serif";
    };
  };
}
