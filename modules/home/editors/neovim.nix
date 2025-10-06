# Neovim configuration
# Cross-platform text editor setup

{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;        # Create 'vi' alias
    vimAlias = true;       # Create 'vim' alias
    withNodeJs = true;     # Enable Node.js support for plugins
    withPython3 = true;    # Enable Python 3 support for plugins

    # === Default Editor ===
    defaultEditor = true;  # Set as EDITOR environment variable
  };

  # Note: For full LazyVim or custom neovim configuration,
  # manage your ~/.config/nvim directory separately.
  # This module just ensures neovim is installed with necessary support.
}
