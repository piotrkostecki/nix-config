# Home Manager configuration aggregator
# Cross-platform user environment - works on macOS, Linux, and WSL

{ pkgs, lib, ... }:

{
  # === Import All Submodules ===
  imports = [
    ./shell/zsh.nix         # Zsh with oh-my-zsh and plugins
    ./shell/tmux.nix        # Tmux terminal multiplexer
    ./editors/neovim.nix    # Neovim text editor
    ./packages              # All package categories
  ];

  # === Common Settings ===
  home.enableNixpkgsReleaseCheck = false;

  # Allow unfree packages (Spotify, VSCode, Claude Code, etc.)
  nixpkgs.config.allowUnfree = true;

  # === Additional Programs ===

  # Let Home Manager manage itself (provides the home-manager command)
  programs.home-manager.enable = true;

  # direnv - automatically load/unload environments
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;  # Auto-hook into zsh
    nix-direnv.enable = true;      # Better Nix integration
  };

  # === macOS-Specific Settings ===
  targets.darwin = lib.mkIf pkgs.stdenv.isDarwin {
    # Automatically create symlinks for Nix-installed GUI apps
    # Apps will be linked to ~/Applications/Home Manager Apps/
    linkApps.enable = true;
  };

  # macOS app registration with Launch Services
  home.activation = lib.mkIf pkgs.stdenv.isDarwin {
    registerApps = lib.hm.dag.entryAfter ["writeBoundary"] ''
      # Register all apps in Home Manager Apps with Launch Services
      appDir="$HOME/Applications/Home Manager Apps"
      if [ -d "$appDir" ]; then
        for app in "$appDir"/*.app; do
          if [ -d "$app" ]; then
            $DRY_RUN_CMD /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$app"
          fi
        done
        echo "Registered Nix apps with Launch Services"
      fi
    '';
  };
}
