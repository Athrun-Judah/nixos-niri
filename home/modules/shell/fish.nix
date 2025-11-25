{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # 去除欢迎语

      alias hx helix

      if status is-interactive
        set -x EDITOR hx
        set -x VISUAL hx
      end

      starship init fish | source

      export PATH="$HOME/.cargo/bin:$PATH"

    '';
    plugins = [
      # 可以在这里添加 fish 插件
    ];
  };
}
