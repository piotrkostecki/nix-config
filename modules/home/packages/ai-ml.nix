# AI/ML tools - local LLM runtimes and AI development tools
# Tools for running and developing with AI models

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # === Local LLM Runtimes ===
    ollama           # Run large language models locally
    llama-cpp        # C++ implementation for LLM inference

    # === AI Development CLIs ===
    claude-code      # Claude Code CLI (AI pair programming)

    # === Python ML/AI Libraries ===
    # Note: For Python ML libraries like torch, tensorflow, etc.
    # it's better to use per-project virtual environments or direnv
    # rather than installing them globally
  ];

  # === Environment Variables ===
  home.sessionVariables = {
    # Add AI/ML specific environment variables here if needed
    # OLLAMA_HOST = "http://localhost:11434";
  };
}
