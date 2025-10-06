# Core CLI utilities - essential tools for daily terminal use
# These are cross-platform and work on macOS, Linux, and WSL

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # === Modern Replacements for Classic Unix Tools ===
    eza          # Modern 'ls' with icons, git integration, and tree view
    bat          # 'cat' clone with syntax highlighting and git integration
    ripgrep      # Ultra-fast 'grep' alternative written in Rust (rg)
    fd           # Simple, fast 'find' alternative
    dust         # Intuitive 'du' replacement with visualization
    duf          # User-friendly 'df' alternative with colorful output
    procs        # Modern 'ps' replacement with better formatting
    btop         # Beautiful resource monitor (better than htop/top)

    # === File and Text Processing ===
    jq           # JSON processor - query and manipulate JSON data
    yq-go        # YAML processor (Go implementation)
    fzf          # Fuzzy finder for command-line

    # === Basic Utilities ===
    unzip        # ZIP archive extraction
    tree         # Directory tree viewer
    tldr         # Simplified, community-driven man pages with examples
  ];

  # === Smart Directory Navigation ===
  programs.zoxide = {
    enable = true;                 # Smarter 'cd' that learns your habits
    enableZshIntegration = true;   # Integrate with zsh (use 'z' command)
  };

  # === Configure eza (better ls) ===
  programs.zsh.shellAliases = {
    ls = "eza --icons";
    ll = "eza --icons -l";
    la = "eza --icons -la";
    lt = "eza --icons --tree";
  };
}
