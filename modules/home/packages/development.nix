# Development tools - version control, build tools, and programming languages
# Cross-platform development environment

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # === Version Control ===
    git              # Distributed version control system
    gh               # GitHub CLI - manage PRs, issues, repos from terminal
    git-lfs          # Git Large File Storage
    git-filter-repo  # Tool for rewriting git history
    lazygit          # Terminal UI for git commands
    delta            # Syntax-highlighting pager for git/diff output

    # === HTTP/API Development ===
    httpie           # User-friendly HTTP client (better than curl for APIs)
    curl             # Transfer data with URLs

    # === Code Analysis & Documentation ===
    tokei            # Fast code statistics tool (lines of code, languages)
    tree-sitter      # Parser generator for building syntax highlighters
    glow             # Render markdown beautifully in the terminal

    # === Build Tools & Runtimes ===
    nodejs           # JavaScript runtime
    python313        # Python 3.13
    cmake            # Cross-platform build system generator
    rustup           # Rust toolchain installer

    # === Container Development ===
    docker           # Container platform (CLI and completions)

    # === Additional Development Utilities ===
    zsh-completions  # Additional completion definitions for zsh
    codex            # Haskell documentation tool
  ];

  # === Git Configuration with Delta ===
  programs.git = {
    enable = true;

    # User identity - IMPORTANT: Update these values!
    userName = "Piotr Kostecki";
    userEmail = "your.email@example.com";  # Change this to your email

    extraConfig = {
      # Use delta as the pager for better diffs
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";

      # Delta configuration
      delta = {
        navigate = true;        # Use n/N to move between diff sections
        light = false;          # Use dark theme
        line-numbers = true;    # Show line numbers
        side-by-side = false;   # Use unified diff view
      };

      # Better merge conflict output
      merge.conflictstyle = "diff3";

      # Enable rerere (reuse recorded resolution)
      rerere.enabled = true;
    };
  };
}
