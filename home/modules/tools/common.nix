{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- 压缩/解压 ---
    zip
    unzip
    p7zip
    unrar

    # --- 多媒体 ---
    vlc          # 视频播放器 (最强)
    imv          # 图片查看器 (Wayland 原生，速度快)
    zathura      # PDF 阅读器 (Vim 键位)

    # --- 系统工具 ---
    btop         # 任务管理器
    eza          # ls 的现代化替代品
    fzf          # 模糊搜索
    fd           # find 的替代品
    ripgrep      # grep 的替代品

    # --- 硬件控制 ---
    brightnessctl # 屏幕亮度控制
    pamixer       # 音量控制 (命令行)
    playerctl     # 媒体控制 (暂停/播放)

    obsidian
    anki
    calibre
    foliate
    meld
    thunderbird

    kdePackages.dolphin
    kdePackages.kio-fuse
    kdePackages.kio-extras
  ];

  # OBS
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs             # Wayland 屏幕捕获支持 (虽然现在核心已支持，备用)
      obs-backgroundremoval # 背景移除
      obs-pipewire-audio-capture
    ];
  };

  # PDF
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      adjust-open = "best-fit";
      pages-per-row = "1";
      scroll-page-aware = "true";
      scroll-full-overlap = "0.01";
      scroll-step = "100";

      # 启用沙盒模式提高安全性
      sandbox = "none";

      # Stylix 会自动配置颜色，但我们可以强制开启一种“护眼模式”
      recolor = "true"; # 自动反色 pdf 内容以适应深色背景
      recolor-keephue = "true"; # 保持图片颜色不变
    };
  };

  # --- XDG 用户目录 ---
  # 自动创建 ~/Downloads, ~/Pictures, ~/Documents 等文件夹
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # 文件关联
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      "application/epub+zip" = [ "com.github.johnfactotum.Foliate.desktop" ];
      "x-scheme-handler/obsidian" = [ "obsidian.desktop" ];
    };
  };
}
