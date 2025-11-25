{ pkgs, ... }:

{
  programs.rio = {
    enable = true;
    settings = {
      padding-x = 8;
      padding-y = [8, 8];
      cursor = {
        shape = "beam";
        blinking = true;
        blinking-interval = 800;
      };
      editor = {
        program = "helix";
      };
      window = {
        width = 1000;
        height = 600;
        opacity = 0.8;
        mode = "windowed";
        decorations = "Transparent";
      };
      renderer = {
        performance = "High";
        backend = "Vulkan"; # Rio 在 Linux 上推荐使用 Vulkan
      };
      # Stylix 会自动注入字体和颜色，不需要手动写 fonts 配置
    };
  };
}
