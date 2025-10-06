# WSL Ubuntu - Host-specific configuration
# Linux/WSL-specific settings and overrides

{ pkgs, lib, ... }:

{
  # === Basic Home Manager Settings ===
  home = {
    username = "piotrkostecki";
    homeDirectory = "/home/piotrkostecki";
    stateVersion = "25.05";
  };

  # === WSL-Specific Configuration ===

  # Enable systemd user services (useful for WSL2)
  systemd.user.startServices = "sd-switch";

  # === WSL-Specific Packages ===
  home.packages = with pkgs; [
    wslu          # WSL utilities (wslview, wslpath, etc.)
    # Add other Linux-specific tools here
  ];

  # === Environment Variables ===
  home.sessionVariables = {
    # Fix for WSL display (if running X11)
    DISPLAY = ":0";
    # WSL-specific paths or settings
  };

  # === Git Configuration for WSL ===
  programs.git.extraConfig = {
    # Use Windows credential manager from WSL (if Windows git is installed)
    # credential.helper = "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
  };

  # === WSL-Specific Aliases ===
  programs.zsh.shellAliases = {
    # Open files in Windows apps from WSL
    # explorer = "explorer.exe";
    # code = "code.exe";
  };
}
