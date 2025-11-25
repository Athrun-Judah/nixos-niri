{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- 编译工具链 ---
    gnumake
    gcc
    clang
    cmake
    pkg-config # 编译 Rust 依赖系统库时必须

    # --- Rust ---
    # 推荐使用 rustup 而不是 cargo，因为 rustup 可以管理 toolchain
    rustup

    # --- Python ---
    (python3.withPackages (ps: with ps; [
      pip
      requests
      # 可以在这里加常用的全局包，但建议用 venv 或 poetry
    ]))
    uv # 极速 Python 包管理器 (比 pip 快得多)

    # --- Node.js ---
    nodejs_24 # 安装最新的 LTS
    corepack  # 启用 yarn/pnpm
    # 既然你一定要类似 fnm 的功能，NixOS 下可以使用 'fnm' 包，
    # 但由于路径只读，它只能管理用户目录下的 node 版本。
    fnm

    # --- C++ ---
    # 已包含在 gcc/clang 中

    # --- Nix 开发 ---
    nil # Language Server
    nixpkgs-fmt
  ];

  # 神器：Direnv (必须配置)
  # 它能让你进入文件夹就自动设置好环境变量（比如特定的 Node 版本）
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration = true;
  };

  # 环境变量配置
  home.sessionVariables = {
    # 确保 Rust 能够找到库
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  };
}
