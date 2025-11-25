{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      manager = {
        show_hidden = false;
        sort_by = "alphabetical";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "none";
        show_symlink = true;
      };

      preview = {
        tab_size = 2;
        max_width = 600;
        max_height = 900;
        cache_dir = "~/.cache/yazi";
        image_filter = "lanczos3";
        image_quality = 90;
        sixel_fraction = 15;
      };
    };

    # 安装常用插件
    # 注意：Yazi 插件通常需要手动下载到 ~/.config/yazi/plugins
    # 或者使用 Nix 打包的插件 (目前 Nixpkgs 对 Yazi 插件支持还在完善中)
    # 这里我们只安装 yazi 本体，插件建议后续通过命令安装
  };

  # Yazi 依赖的工具 (用于预览)
  home.packages = with pkgs; [
    ffmpegthumbnailer # 视频预览
    unar              # 压缩包预览
    jq                # JSON 预览
    poppler_utils     # PDF 预览
    fd                # 文件查找
    ripgrep           # 内容查找
    fzf               # 模糊搜索
    zoxide            # 智能跳转
    imagemagick       # 图片处理
  ];
}
