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
    pkgs   = import nixpkgs { inherit system; };
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

            # Environment variables for this user
            home.sessionVariables = {
              # Custom askpass script for sudo operations
              SUDO_ASKPASS = "/usr/local/bin/askpass.sh";
            };

            # === Program Configurations ===

            # Zsh shell - enables home-manager shell integration
            programs.zsh = {
              enable = true;
              # Source existing antigen configuration to preserve plugins and theme
              initExtra = ''
                # Enable Powerlevel10k instant prompt
                if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
                  source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
                fi

                source ~/antigen.zsh

                # Load the oh-my-zsh's library
                antigen use oh-my-zsh

                # Theme must come before plugins
                antigen theme romkatv/powerlevel10k

                # Bundles from the default repo
                antigen bundle git
                antigen bundle pip
                antigen bundle command-not-found
                antigen bundle vagrant
                antigen bundle mvn
                antigen bundle autojump

                # Syntax highlighting bundle
                antigen bundle zsh-users/zsh-syntax-highlighting
                antigen bundle zsh-users/zsh-autosuggestions
                antigen bundle Tarrasch/zsh-autoenv

                # Tell antigen that you're done
                antigen apply

                # Source local customizations if they exist
                [ -f ~/.zshrc.local ] && source ~/.zshrc.local

                # Homebrew environment (will be phased out as you migrate to Nix)
                eval "$(/opt/homebrew/bin/brew shellenv)"

                # LM Studio CLI
                export PATH="$PATH:/Users/piotrkostecki/.lmstudio/bin"

                # Aliases
                alias vim="nvim"

                # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
                [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
              '';
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
              tmux         # Terminal multiplexer
              jq           # JSON processor
            ];
          };
        }
      ];
    };
  };
}
