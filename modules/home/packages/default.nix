# Package modules aggregator
# Imports all package categories

{ ... }:

{
  imports = [
    ./core.nix         # Essential CLI tools (eza, bat, ripgrep, etc.)
    ./development.nix  # Development tools (git, nodejs, python, etc.)
    ./devops.nix       # DevOps tools (kubectl, terraform, docker, etc.)
    ./ai-ml.nix        # AI/ML tools (ollama, claude-code, etc.)
    ./utilities.nix    # General utilities (mcfly, fzf config, etc.)
  ];
}
