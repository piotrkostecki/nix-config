# General utilities - productivity tools and terminal enhancements
# Quality of life improvements for daily terminal use

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # === Navigation & Search ===
    autojump         # Jump to frequently used directories (j command)
    # Note: zoxide is configured in core.nix as an alternative

    # === File Operations ===
    tree             # Display directory tree structure

    # === Archive Tools ===
    unzip            # Already in core.nix, but keeping here for clarity
  ];

  # === Enhanced History Search with McFly ===
  programs.mcfly = {
    enable = true;                 # AI-powered shell history search
    enableZshIntegration = true;   # Integrate with zsh (Ctrl+R)
    keyScheme = "vim";             # Use vim keybindings (or "emacs")
    fuzzySearchFactor = 2;         # Balance between exact and fuzzy matching
  };

  # === FZF Configuration ===
  # Note: fzf is enabled in core.nix, but we can add advanced config here
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    # Custom key bindings
    # Ctrl+T: Paste selected files/directories
    # Ctrl+R: Paste selected command from history (override by mcfly)
    # Alt+C: cd into selected directory

    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--border"
      "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    ];

    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
  };
}
