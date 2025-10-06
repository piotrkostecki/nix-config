# macOS system-level configuration
# nix-darwin specific settings that don't apply to Linux/WSL

{ pkgs, ... }:

{
  # === System Version ===
  # Don't change this unless you know what you're doing
  system.stateVersion = 6;

  # === Primary User ===
  # Used by Homebrew and other system-level operations
  system.primaryUser = "piotrkostecki";

  # === User Configuration ===
  users.users.piotrkostecki = {
    home = "/Users/piotrkostecki";
  };

  # === Nix Configuration ===
  # Disable nix-darwin's Nix management (required for Determinate Nix installer)
  nix.enable = false;

  # Nix daemon settings
  # DO NOT set eval-cores or lazy-trees here; they cause warnings
  nix.settings = {
    # Allow these users to perform privileged Nix operations
    trusted-users = [ "root" "piotrkostecki" ];
  };

  # === System Packages ===
  # GUI applications installed at the system level (accessible to all users)
  environment.systemPackages = with pkgs; [
    iina      # Modern media player for macOS (mpv-based)
    waveterm  # Open-source, cross-platform terminal for seamless workflows
  ];
}
