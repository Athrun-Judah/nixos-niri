{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    # 1. 自动安装依赖工具 (LSP & Formatters)
    extraPackages = with pkgs; [
      # -- Rust --
      rust-analyzer
      cargo       # rust 基础
      rustfmt
      clippy

      # -- Python --
      ruff
      pyright

      # -- Web (HTML/CSS/JSON/JS/TS) --
      superhtml                 # HTML LSP
      biome                     # JS/TS Formatter & Linter
      vscode-langservers-extracted # 包含 vscode-html/css/json-language-server
      nodePackages.typescript-language-server
      nodePackages.prettier
      nodePackages.sql-formatter # sqlformat
      tailwindcss-language-server

      # -- Others --
      taplo                     # TOML
      nil                       # Nix LSP
      nixpkgs-fmt               # Nix Format
      yaml-language-server
      clang-tools               # C++ (clang-format)
      # fourmolu                # Haskell (如果需要 Haskell 支持，取消注释)
      # perlnavigator           # Perl (如果 pkgs 中没有，可能需要特定源)
    ];

    # 2. Editor Settings
    settings = {

      # -- Editor --
      editor = {
        line-number = "relative";
        mouse = true;
        auto-save = true;
        auto-format = true;
        auto-info = true;
        # 定义用于 :sh 命令的 shell
        shell = [ "fish" ];
        cursorline = true;
        gutters = [ "line-numbers" "spacer" "diagnostics" ];

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker = {
          hidden = false;
        };

        lsp = {
          display-inlay-hints = true;
        };

        soft-wrap = {
          enable = true;
          wrap-indicator = "↪";
        };

        indent-guides = {
          render = true;
          character = "│";
        };

        whitespace = {
          render = "all";
          characters = {
            space = "·";
            nbsp = "⍽";
            tab = "→";
            tabpad = "·";
          };
        };

        statusline = {
          left = [ "mode" "spinner" "file-name" "read-only-indicator" "file-modification-indicator" ];
          center = [ "diagnostics" ];
          right = [ "selections" "position" "file-encoding" "file-line-ending" "file-type" ];
          separator = "│";

          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };
      };

      # -- Keys --
      keys = {
        normal = {
          "esc" = [ "keep_primary_selection" "collapse_selection" ];

          # Space 快捷键层级
          space = {
            # 可以在这里解开你注释掉的常用功能
            # f = ":open";
            # s = ":w";

            # 窗口跳转 w -> h/j/k/l
            w = {
              h = "jump_view_left";
              j = "jump_view_down";
              k = "jump_view_up";
              l = "jump_view_right";
            };
          };
        };

        insert = {
          # j -> k 返回普通模式
          j = {
            k = "normal_mode";
          };
        };
      };
    };

    # 3. Languages configuration
    languages = {

          # --- Language Servers 定义 ---
          language-server = {
            taplo = { config = {}; };

            rust-analyzer = {
              config = {
                check = { command = "clippy"; };
              };
            };

            tailwindcss-ls = {
              config = {
                # 注意：在 Nix 中，包含特殊字符(*)的 Key 必须加引号
                userLanguages = {
                  rust = "html";
                  "*.rs" = "html";
                };
              };
            };

            ruff = {
              command = "ruff";
              args = [ "server" ];
              config = {
                settings = {
                  lineLength = 80;
                  lint = {
                    select = [ "E4" "E7" ];
                    preview = false;
                  };
                  format = { preview = true; };
                };
              };
            };

            superhtml-lsp = {
              command = "superhtml";
              args = [ "lsp" ];
            };

            biome = {
              command = "biome";
              args = [ "lsp-proxy" ];
            };

            perlnavigator = {
              command = "perlnavigator";
              args = [ "--stdio" ];
            };

            sql-language-server = {
              command = "sql-language-server";
              args = [ "up" "--method" "stdio" ];
            };

            yaml-language-server = {
              config = {
                yaml = {
                  format = { enable = true; };
                  validation = true;
                  schemas = {
                    "https://json.schemastore.org/github-workflow.json" = ".github/workflows/*.{yml,yaml}";
                    "https://raw.githubusercontent.com/ansible-community/schemas/main/f/ansible-tasks.json" = "roles/{tasks,handlers}/*.{yml,yaml}";
                  };
                };
              };
            };
          };

          # --- 具体的语言列表 ---
          language = [
            # TOML
            {
              name = "toml";
              formatter = { command = "taplo"; args = [ "fmt" "-" ]; };
              auto-format = true;
            }
            # Rust
            {
              name = "rust";
              language-servers = [ "rust-analyzer" "tailwindcss-ls" ];
            }
            # Python
            {
              name = "python";
              language-servers = [ "ruff" "pyright" ];
              formatter = {
                command = "ruff";
                args = [ "format" "--stdin-filename" "%s" "-" ];
              };
              auto-format = true;
              roots = [ "pyproject.toml" "ruff.toml" ".ruff.toml" "setup.py" ".git" "poetry.lock" "Pipfile" ".venv" "venv" ];
            }
            # HTML
            {
              name = "html";
              scope = "source.html";
              roots = [];
              file-types = [ "html" ];
              language-servers = [ "superhtml-lsp" "vscode-html-language-server" "tailwindcss-ls" ];
              formatter = { command = "prettier"; args = [ "--parser" "html" ]; };
            }
            # JavaScript
            {
              name = "javascript";
              language-servers = [ "biome" "typescript-language-server" ];
              auto-format = true;
            }
            # TypeScript
            {
              name = "typescript";
              language-servers = [ "biome" "typescript-language-server" ];
              auto-format = true;
            }
            # TSX
            {
              name = "tsx";
              auto-format = true;
              language-servers = [ "biome" "typescript-language-server" "tailwindcss-ls" ];
            }
            # JSX
            {
              name = "jsx";
              auto-format = true;
              language-servers = [ "biome" "typescript-language-server" "tailwindcss-ls" ];
            }
            # JSON
            {
              name = "json";
              language-servers = [ "biome" "vscode-json-language-server" ];
            }
            # Perl
            {
              name = "perl";
              file-types = [ "PL" "pl" "pm" "t" "pod" "canfile" ];
              language-servers = [ "perlnavigator" ];
            }
            # SQL
            {
              name = "sql";
              language-servers = [ "sql-language-server" ];
              formatter = {
                command = "sqlformat";
                args = [ "--reindent" "--indent_width" "2" "--keywords" "upper" "--identifiers" "lower" "-" ];
              };
            }
            # CSS
            {
              name = "css";
              language-servers = [ "vscode-css-language-server" "tailwindcss-ls" ];
              formatter = { command = "prettier"; args = [ "--parser" "css" ]; };
            }
            # Svelte
            {
              name = "svelte";
              language-servers = [ "svelteserver" "tailwindcss-ls" ];
            }
            # YAML
            {
              name = "yaml";
              formatter = { command = "prettier"; args = [ "--parser" "yaml" ]; };
              auto-format = true;
            }
            # Fish
            {
              name = "fish";
              formatter = { command = "fish_indent"; };
              auto-format = true;
            }
            # CPP
            {
              name = "cpp";
              formatter = { command = "clang-format"; };
              auto-format = true;
            }
            # Haskell
            {
              name = "haskell";
              auto-format = true;
              formatter = { command = "fourmolu"; args = [ "--stdin-input-file" "%s" ]; };
            }
            # Nix
            {
              name = "nix";
              formatter = { command = "nixpkgs-fmt"; };
              language-servers = [ "nil" ];
            }
          ];
    };
  };
}
