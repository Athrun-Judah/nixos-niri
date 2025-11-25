{ pkgs, ... }:

{
  stylix.enable = true;
  # stylix.image = ../../../wallpaper.jpg;

  # 主题色调
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
  stylix.polarity = "dark";

  # --- 字体配置 ---
  stylix.fonts = {
    # 1. SansSerif (UI 默认字体):
    # 使用 Inter (公认最佳 UI 字体之一)，配合 Noto Sans SC 作为中文后备
    sansSerif = {
      package = pkgs.inter;
      name = "Inter";
    };

    # 2. Serif (文档/阅读):
    # 使用你指定的 Noto Serif SC (思源宋体)
    serif = {
      package = pkgs.noto-fonts-cjk-serif;
      name = "Noto Serif CJK SC";
    };

    # 3. Monospace (代码):
    # 使用 JetBrainsMono Nerd Font
    monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
    };

    # 4. Emoji
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };

  # 额外安装中文字体以确保 Fallback 正常工作
  # 虽然 Stylix 定义了主要字体，但安装这些包能防止某些应用缺字
  environment.systemPackages = with pkgs; [
    noto-fonts-cjk-serif
    noto-fonts-cjk-sans
  ];

  stylix.gt.enable = true;
}
