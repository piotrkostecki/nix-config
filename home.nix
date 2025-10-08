# Standalone Home Manager Configuration for Linux/WSL
# This file provides a ready-to-use home-manager configuration for WSL/Linux systems.
#
# Usage:
#   1. Install Nix: curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
#   2. Clone this repo and copy this file to ~/.config/home-manager/home.nix
#   3. Edit the username and homeDirectory below to match your system
#   4. Run: home-manager switch
#
# For the full modular configuration, use the flake.nix with: home-manager switch --flake .#piotrkostecki@wsl-ubuntu

{ config, pkgs, ... }:

{
  # === User Identity ===
  # IMPORTANT: Change these to match your system!
  home.username = "piotrkostecki";  # Change to your username
  home.homeDirectory = "/home/piotrkostecki";  # Change to your home directory

  # Home Manager version - should match your home-manager channel
  home.stateVersion = "25.05";

  # === Nixpkgs Configuration ===
  nixpkgs.config = {
    allowUnfree = true;  # Allow proprietary packages (VS Code, etc.)
  };

  # Disable version checking between nixpkgs and home-manager
  home.enableNixpkgsReleaseCheck = false;

  # === System Packages ===
  home.packages = with pkgs; [
    # === Core Utilities ===
    ripgrep           # Fast grep alternative (rg)
    fd                # Fast find alternative
    tree              # Directory tree viewer
    tree-sitter       # Parser for syntax highlighting
    unzip             # Archive extraction
    jq                # JSON processor
    tldr              # Simplified man pages

    # === Development Tools ===
    git               # Version control
    gh                # GitHub CLI
    lazygit           # Terminal UI for git
    bat               # Better cat with syntax highlighting
    rustup            # Rust toolchain manager

    # === WSL-Specific ===
    wslu              # WSL utilities (wslview, wslpath, etc.)
  ];

  # === Programs with Declarative Configuration ===

  # Zsh - Modern shell with plugins
  programs.zsh = {
    enable = true;

    # Enable oh-my-zsh framework
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";  # Simple, fast theme

      plugins = [
        "git"                   # Git aliases and completions
        "sudo"                  # Press ESC twice to prefix with sudo
        "command-not-found"     # Suggests packages for missing commands
        "history"               # History utilities
        "direnv"                # Direnv integration
      ];
    };

    # Additional shell configuration
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Shell aliases
    shellAliases = {
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";

      # Better defaults
      ls = "ls --color=auto";
      ll = "ls -lah";
      grep = "grep --color=auto";

      # Modern replacements
      cat = "bat";
      find = "fd";

      # Git shortcuts
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph";

      # Home Manager
      hm = "home-manager";
      hms = "home-manager switch";
      hme = "nvim ~/.config/home-manager/home.nix";
    };

    # Environment variables
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      DISPLAY = ":0";  # WSL X11 display
    };

    # Additional zsh configuration
    initExtra = ''
      # Better history
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_FIND_NO_DUPS
      setopt HIST_SAVE_NO_DUPS

      # Case-insensitive completion
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

      # Colorful completion
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"

      # WSL integration
      # Uncomment if you want to access Windows commands easily
      # export PATH="$PATH:/mnt/c/Windows/System32"

      # Display welcome message
      echo "🚀 Home Manager environment loaded!"
      echo "   Editor: nvim | Shell: zsh | Git UI: lazygit"
      echo "   Run 'hms' to rebuild, 'hme' to edit config"
    '';
  };

  # Neovim - Modern text editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Enable language server support
    withNodeJs = true;
    withPython3 = true;

    # Basic vim configuration
    extraConfig = ''
      " Basic settings
      set number          " Line numbers
      set relativenumber  " Relative line numbers
      set expandtab       " Use spaces instead of tabs
      set shiftwidth=2    " Indent with 2 spaces
      set tabstop=2       " Tab shows as 2 spaces
      set smartindent     " Auto-indent
      set mouse=a         " Enable mouse support
      set clipboard=unnamedplus  " System clipboard

      " Search settings
      set ignorecase      " Case-insensitive search
      set smartcase       " Case-sensitive if uppercase present
      set incsearch       " Incremental search
      set hlsearch        " Highlight search results

      " UI improvements
      set termguicolors   " True color support
      set signcolumn=yes  " Always show sign column
      set cursorline      " Highlight current line

      " Performance
      set updatetime=300  " Faster completion
      set timeoutlen=500  " Faster key sequences
    '';
  };

  # Git - Version control
  programs.git = {
    enable = true;

    # User configuration - CHANGE THESE!
    userName = "Piotr Kostecki";
    userEmail = "your.email@example.com";  # Change this!

    # Git behavior
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "nvim";

      # WSL: Use Windows Git Credential Manager (if installed)
      # Uncomment the line below if you have Git for Windows installed
      # credential.helper = "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
    };

    # Git aliases
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      lg = "log --oneline --graph --decorate --all";
      last = "log -1 HEAD";
      unstage = "reset HEAD --";
    };
  };

  # Tmux - Terminal multiplexer
  programs.tmux = {
    enable = true;

    # Basic configuration
    terminal = "screen-256color";
    historyLimit = 10000;
    keyMode = "vi";  # Vim-style key bindings
    mouse = true;    # Enable mouse support

    # Change prefix to Ctrl-a (more comfortable than Ctrl-b)
    prefix = "C-a";

    extraConfig = ''
      # Easier split commands
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # Vim-style pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      # Start windows/panes at 1 instead of 0
      set -g base-index 1
      setw -g pane-base-index 1

      # Status bar styling
      set -g status-style bg=black,fg=white
      set -g status-left "#[fg=green]#S "
      set -g status-right "#[fg=yellow]%H:%M %d-%b-%y"
    '';
  };

  # Direnv - Automatic environment loading
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;  # Better Nix support
  };

  # FZF - Fuzzy finder
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    # Default options
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--inline-info"
    ];

    # Ctrl+T to search files
    fileWidgetOptions = [
      "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    ];
  };

  # === Systemd User Services ===
  # Enable automatic service management (useful for WSL2)
  systemd.user.startServices = "sd-switch";

  # === Session Variables ===
  home.sessionVariables = {
    # Use Nix packages before system packages
    # PATH = "$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH";
  };

  # === XDG Base Directories ===
  xdg.enable = true;  # Manage XDG directories

  # === Let Home Manager manage itself ===
  programs.home-manager.enable = true;
}
