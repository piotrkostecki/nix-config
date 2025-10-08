# Zsh shell configuration
# Cross-platform shell setup with oh-my-zsh, powerlevel10k, and plugins

{ pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;

    # === Environment Variables ===
    envExtra = ''
      # Set ZSH path for oh-my-zsh (must be before oh-my-zsh init)
      export ZSH="${pkgs.oh-my-zsh}/share/oh-my-zsh"
    '';

    # === Oh-My-Zsh Framework ===
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"                  # Git aliases and functions
        "pip"                  # Python pip completion
        "command-not-found"    # Suggests package for missing commands
        "vagrant"              # Vagrant completion
        "mvn"                  # Maven completion
        "docker"               # Docker completion and aliases
        "docker-compose"       # Docker Compose completion
        "tmux"                 # Tmux aliases and functions
        "autojump"             # Quick directory jumping
        "vi-mode"              # Vi keybindings for command line
      ];
    };

    # === Zsh Plugins ===
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

    # === Shell Aliases ===
    shellAliases = {
      # Editor
      vim = "nvim";
      vi = "nvim";

      # List files (using eza from core.nix)
      ls = "eza --icons";
      ll = "eza --icons -l";
      la = "eza --icons -la";
      lt = "eza --icons --tree";

      # Colorize common commands
      grep = "grep --color=auto";

      # Tmux
      ta = "tmux attach -t";
      ts = "tmux new-session -s";
      tl = "tmux list-sessions";

      # Git (additional to oh-my-zsh git plugin)
      gst = "git status";
      gco = "git checkout";
      gcm = "git commit -m";

      # Kubernetes (from devops.nix)
      k = "kubectl";
      kgp = "kubectl get pods";
      kgs = "kubectl get services";
      kgd = "kubectl get deployments";
      kgn = "kubectl get namespaces";
      kdp = "kubectl describe pod";
      kl = "kubectl logs";
      kx = "kubectl exec -it";
    };

    # === Zsh Initialization ===
    initExtra = lib.mkMerge [
      # Powerlevel10k instant prompt - MUST run before oh-my-zsh
      (lib.mkBefore ''
        # Enable Powerlevel10k instant prompt
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')

      # Main configuration that runs AFTER oh-my-zsh
      ''
        # Source Powerlevel10k configuration
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        # FZF configuration
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

        # Syntax highlighting customization
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

        # Autosuggestions configuration
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

        # === Tmux Welcome Message ===
        # Display tmux keybinding hint when starting a shell inside tmux
        if [[ -n "$TMUX" ]]; then
          # Only show on new shells, not on every prompt
          if [[ -z "$TMUX_WELCOME_SHOWN" ]]; then
            export TMUX_WELCOME_SHOWN=1
            echo ""
            echo "╔════════════════════════════════════════════════╗"
            echo "║ 🚀 TMUX SESSION ACTIVE                         ║"
            echo "╠════════════════════════════════════════════════╣"
            echo "║ Prefix: Ctrl-b                                 ║"
            echo "║                                                 ║"
            echo "║ Quick Commands:                                 ║"
            echo "║   Ctrl-b ?  → Show full keybinding cheatsheet  ║"
            echo "║   Ctrl-b c  → Create new window                ║"
            echo "║   Ctrl-b |  → Split vertically                 ║"
            echo "║   Ctrl-b -  → Split horizontally               ║"
            echo "║   Ctrl-b d  → Detach from session              ║"
            echo "║   Ctrl-b h/j/k/l → Navigate panes (vim-style)  ║"
            echo "╚════════════════════════════════════════════════╝"
            echo ""
          fi
        fi

        # Source local customizations if they exist
        [ -f ~/.zshrc.local ] && source ~/.zshrc.local

        # Override oh-my-zsh aliases with eza (must be after all oh-my-zsh loading)
        alias ls='eza --icons'
        alias ll='eza --icons -l'
        alias la='eza --icons -la'
        alias lt='eza --icons --tree'
      ''

      # === Platform-Specific Configuration ===

      # macOS-specific
      (lib.mkIf pkgs.stdenv.isDarwin ''
        # Homebrew environment
        eval "$(/opt/homebrew/bin/brew shellenv)"

        # LM Studio CLI path
        export PATH="$PATH:/Users/piotrkostecki/.lmstudio/bin"
      '')

      # Linux-specific
      (lib.mkIf pkgs.stdenv.isLinux ''
        # Add Linux-specific configuration here
        # Example: export PATH="$PATH:/home/piotrkostecki/bin"
      '')
    ];
  };

  # === Environment Variables ===
  home.sessionVariables = lib.optionalAttrs pkgs.stdenv.isDarwin {
    # Custom askpass script for sudo operations (macOS only)
    SUDO_ASKPASS = "/usr/local/bin/askpass.sh";
  };
}
