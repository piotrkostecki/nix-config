# macOS (Darwin) configuration aggregator
# Imports all Darwin-specific modules

{ ... }:

{
  imports = [
    ./system.nix      # System-level settings and Nix configuration
    ./homebrew.nix    # GUI applications via Homebrew Cask
  ];
}
