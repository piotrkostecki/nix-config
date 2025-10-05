{
  # Nix flake for configuring macOS with nix-darwin and home-manager
  # Apply changes: darwin-rebuild switch --flake .#MacBook-Air-Piotr

  # Declare external dependencies that this flake relies on.
  inputs = {
    # Main package repository - using unstable channel for latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # nix-darwin: System-level macOS configuration management
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";  # Use same nixpkgs as main
    };

    # home-manager: User-level environment and dotfiles management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";  # Use same nixpkgs as main
    };
  };

  # Define the system configuration outputs
  outputs = { self, nixpkgs, darwin, home-manager, ... }:
  let
    # Target architecture for the host we are configuring.
    system = "aarch64-darwin";  # M1/M2/M3 Apple Silicon

    # Convenience handle for packages coming from nixpkgs.
    pkgs   = import nixpkgs {
      inherit system;
      config.allowUnfree = true;  # Allow unfree packages like Spotify, VSCode, etc.
    };
  in {
    # Main system configuration for this machine
    darwinConfigurations."MacBook-Air-Piotr" = darwin.lib.darwinSystem {
      inherit system;
      modules = [
        # Import home-manager as a nix-darwin module
        home-manager.darwinModules.home-manager

        {
          # Core nix-darwin configuration for the host.
          # Don't change this unless you know what you're doing
          system.stateVersion = 6;
          # Disable nix-darwin's Nix management (required for Determinate Nix)
          nix.enable = false;

          # Nix daemon settings
          # DO NOT set eval-cores or lazy-trees here; they cause warnings
          nix.settings = {
            # Allow these users to perform privileged Nix operations
            trusted-users = [ "root" "piotrkostecki" ];
          };

          # Define the main user's home directory
          users.users.piotrkostecki.home = "/Users/piotrkostecki";

          # === Home Manager Configuration ===
          # Manages user-level packages, dotfiles, and program configurations

          # Install packages to the user's profile instead of system profile
          home-manager.useUserPackages = true;

          # User-specific configuration
          home-manager.users.piotrkostecki = { pkgs, ... }: {
            # Home Manager state version - keep aligned with release
            home.stateVersion = "25.05";

            # Disable version checking between nixpkgs and home-manager
            home.enableNixpkgsReleaseCheck = false;

            # Allow unfree packages (Spotify, VSCode, etc.)
            nixpkgs.config.allowUnfree = true;

            # Environment variables for this user
            home.sessionVariables = {
              # Custom askpass script for sudo operations
              SUDO_ASKPASS = "/usr/local/bin/askpass.sh";
            };

            # === Program Configurations ===

            # Zsh shell - using oh-my-zsh framework via nix
            programs.zsh = {
              enable = true;

              # Enable oh-my-zsh through home-manager (no Antigen needed!)
              oh-my-zsh = {
                enable = true;
                plugins = [
                  "git"                  # Git aliases and functions
                  "pip"                  # Python pip completion
                  "command-not-found"    # Suggests package installation for missing commands
                  "vagrant"              # Vagrant completion
                  "mvn"                  # Maven completion
                  "docker"               # Docker completion and aliases
                  "docker-compose"       # Docker Compose completion
                  "tmux"                 # Tmux aliases and functions
                  "autojump"             # Quick directory jumping
                  "vi-mode"              # Vi keybindings for command line
                ];
                # Custom plugins will be loaded via plugins below
              };

              # Additional Zsh plugins managed by Nix
              plugins = [
                {
                  name = "powerlevel10k";
                  src = pkgs.zsh-powerlevel10k;
                  file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
                }
                {
                  name = "zsh-syntax-highlighting";
                  src = pkgs.zsh-syntax-highlighting;
                  file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
                }
                {
                  name = "zsh-autosuggestions";
                  src = pkgs.zsh-autosuggestions;
                  file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
                }
              ];

              # Shell aliases
              shellAliases = {
                vim = "nvim";
                vi = "nvim";
                ls = "ls --color=auto";
                ll = "ls -lah";
                grep = "grep --color=auto";
                # tmux aliases
                ta = "tmux attach -t";
                ts = "tmux new-session -s";
                tl = "tmux list-sessions";
                # Git aliases (in addition to oh-my-zsh git plugin)
                gst = "git status";
                gco = "git checkout";
                gcm = "git commit -m";
              };

              # Zsh initialization content with proper ordering
              initContent = pkgs.lib.mkMerge [
                # Powerlevel10k instant prompt - runs BEFORE oh-my-zsh
                (pkgs.lib.mkBefore ''
                  # Enable Powerlevel10k instant prompt (runs early)
                  if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
                    source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
                  fi
                '')

                # Main configuration that runs AFTER oh-my-zsh
                ''
                  # Source Powerlevel10k configuration
                  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

                  # Homebrew environment (will be phased out as you migrate to Nix)
                  eval "$(/opt/homebrew/bin/brew shellenv)"

                  # LM Studio CLI
                  export PATH="$PATH:/Users/piotrkostecki/.lmstudio/bin"

                  # Enhanced history search with fzf
                  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
                  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

                  # Syntax highlighting customization
                  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

                  # Autosuggestions configuration
                  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
                  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

                  # Source local customizations if they exist
                  [ -f ~/.zshrc.local ] && source ~/.zshrc.local
                ''
              ];
            };

            # Neovim text editor
            programs.neovim = {
              enable = true;
              viAlias = true;        # Create 'vi' alias
              vimAlias = true;       # Create 'vim' alias
              withNodeJs = true;     # Enable Node.js support for plugins
              withPython3 = true;    # Enable Python 3 support for plugins
            };

            # direnv - automatically load/unload environments
            programs.direnv = {
              enable = true;
              enableZshIntegration = true;  # Auto-hook into zsh
              nix-direnv.enable = true;      # Better Nix integration
            };

            # fzf - fuzzy finder with shell integration
            programs.fzf = {
              enable = true;
              enableZshIntegration = true;  # Auto-hook into zsh
            };

            # tmux - terminal multiplexer with screen-style keybindings
            programs.tmux = {
              enable = true;
              # Use Ctrl-a instead of Ctrl-b (screen-style)
              prefix = "C-a";
              # Enable mouse support
              mouse = true;
              # Use 256 color terminal
              terminal = "screen-256color";
              # Start window numbering at 1 instead of 0
              baseIndex = 1;
              # Renumber windows when one is closed
              escapeTime = 0;
              historyLimit = 50000;

              plugins = with pkgs.tmuxPlugins; [
                # Catppuccin theme - beautiful, soothing pastel theme
                {
                  plugin = catppuccin;
                  extraConfig = ''
                    set -g @catppuccin_flavour 'mocha' # or frappe, macchiato, latte
                    set -g @catppuccin_window_left_separator ""
                    set -g @catppuccin_window_right_separator " "
                    set -g @catppuccin_window_middle_separator " █"
                    set -g @catppuccin_window_number_position "right"
                    set -g @catppuccin_window_default_fill "number"
                    set -g @catppuccin_window_default_text "#W"
                    set -g @catppuccin_window_current_fill "number"
                    set -g @catppuccin_window_current_text "#W"
                    set -g @catppuccin_status_modules_right "directory session"
                    set -g @catppuccin_status_left_separator  " "
                    set -g @catppuccin_status_right_separator ""
                    set -g @catppuccin_status_fill "icon"
                    set -g @catppuccin_status_connect_separator "no"
                    set -g @catppuccin_directory_text "#{pane_current_path}"
                  '';
                }
                # Better tmux-vim navigation
                vim-tmux-navigator
                # Save and restore tmux sessions
                resurrect
                # Automatic session saving
                continuum
                # Sensible defaults
                sensible
              ];

              extraConfig = ''
                # === Shell Configuration ===
                # Force zsh as the default shell for tmux
                set-option -g default-shell ${pkgs.zsh}/bin/zsh
                # Start zsh as a login shell to properly load PATH
                set-option -g default-command "${pkgs.zsh}/bin/zsh -l"

                # === Screen-style Keybindings ===

                # Send prefix to nested tmux/screen (press Ctrl-a twice)
                bind C-a send-prefix

                # Screen-style window splitting
                bind | split-window -h -c "#{pane_current_path}"  # Vertical split
                bind - split-window -v -c "#{pane_current_path}"  # Horizontal split

                # Screen-style window creation
                bind c new-window -c "#{pane_current_path}"

                # Screen-style last window (Ctrl-a Ctrl-a)
                bind C-a last-window

                # Screen-style window navigation
                bind Space next-window
                bind BSpace previous-window

                # Screen-style detach
                bind d detach-client

                # Screen-style kill window
                bind k confirm-before -p "kill-window #W? (y/n)" kill-window

                # Pane navigation (vim-style)
                bind h select-pane -L
                bind j select-pane -D
                bind k select-pane -U
                bind l select-pane -R

                # Pane resizing
                bind -r H resize-pane -L 5
                bind -r J resize-pane -D 5
                bind -r K resize-pane -U 5
                bind -r L resize-pane -R 5

                # Reload config
                bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

                # Enable vi mode in copy mode
                setw -g mode-keys vi

                # Vi-style copy-paste
                bind -T copy-mode-vi v send-keys -X begin-selection
                bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel

                # Better status bar update interval
                set -g status-interval 5

                # Enable focus events for vim
                set -g focus-events on

                # Enable RGB color support
                set -ga terminal-overrides ",*256col*:Tc"

                # === Continuum & Resurrect Settings ===
                set -g @resurrect-strategy-nvim 'session'
                set -g @continuum-restore 'on'
                set -g @continuum-save-interval '15'
              '';
            };

            # === User Packages ===
            # Command-line tools and utilities installed for this user
            home.packages = with pkgs; [
              ripgrep      # Fast grep alternative (rg)
              fd           # Fast find alternative
              unzip        # ZIP archive extraction
              tree-sitter  # Parser generator for syntax highlighting
              rustup       # Rust toolchain installer

              # Batch 1 - Migrated from Homebrew
              bat          # Cat clone with syntax highlighting
              lazygit      # Git TUI client
              tldr         # Simplified man pages
              tree         # Directory tree viewer

              # Batch 2 - Essential dev tools
              git          # Version control system
              gh           # GitHub CLI
              jq           # JSON processor

              # Batch 3 - Development tools and utilities
              nodejs       # JavaScript runtime
              cmake        # Build system generator
              yq-go        # YAML processor (Go implementation)
              git-lfs      # Git Large File Storage
              docker       # Container platform (includes completions)

              # Batch 4 - AI/ML tools (migrated from Homebrew)
              ollama       # Local LLM runtime
              llama-cpp    # LLM inference in C++

              # Batch 5 - Python and dev utilities
              python313    # Python 3.13
              autojump     # Smart directory jumping
              git-filter-repo  # Git history rewriting tool
              zsh-completions  # Additional zsh completions
              codex        # Haskell documentation tool

              # Batch 6 - Desktop applications
              spotify      # Music streaming client
            ];
          };
        }
      ];
    };
  };
}
