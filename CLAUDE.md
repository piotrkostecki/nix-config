# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a nix-darwin configuration repository for managing macOS system configuration using Nix flakes. It integrates:
- **nix-darwin**: macOS system configuration
- **home-manager**: User environment and package management
- **nixpkgs**: Package repository (nixpkgs-unstable channel)

Target system: `aarch64-darwin` (Apple Silicon M1/M2/M3)
Hostname: `MacBook-Air-Piotr`
User: `piotrkostecki`

## Essential Commands

### Apply Configuration Changes
```bash
darwin-rebuild switch --flake .#MacBook-Air-Piotr
```
Rebuilds and activates the system configuration. Use this after modifying `flake.nix`.

### Update Dependencies
```bash
nix flake update
```
Updates `flake.lock` to fetch the latest versions of nixpkgs, nix-darwin, and home-manager.

### Check Configuration
```bash
nix flake check
```
Validates the flake configuration for syntax errors and other issues.

### Show Current Configuration
```bash
darwin-rebuild --flake .#MacBook-Air-Piotr --dry-run
```
Shows what would change without applying it.

### Rollback to Previous Generation
```bash
darwin-rebuild --rollback
```
Reverts to the previous system generation if something breaks.

### List Generations
```bash
darwin-rebuild --list-generations
```

## Architecture

### Flake Structure
- **Inputs**:
  - `nixpkgs`: nixpkgs-unstable branch (rolling release)
  - `darwin`: LnL7/nix-darwin (macOS system configuration, follows same nixpkgs)
  - `home-manager`: nix-community/home-manager (follows same nixpkgs)

- **Outputs**: Single darwinConfiguration for "MacBook-Air-Piotr"

### Configuration Layout
The `flake.nix` contains a monolithic configuration with two main sections:
1. **System-level**: nix-darwin settings (system.stateVersion, nix.settings, users)
2. **User-level**: home-manager module for user `piotrkostecki` (home.stateVersion: "25.05")

### Key Settings
- `system.stateVersion = 6`: nix-darwin state version
- `home.stateVersion = "25.05"`: home-manager state version
- `nix.enable = false`: **Critical** - Disables nix-darwin's Nix management (required for Determinate Nix installer)
- `nix.settings.trusted-users`: Allows root and piotrkostecki to use Nix daemon
- `home.enableNixpkgsReleaseCheck = false`: Disables version checking between nixpkgs and home-manager
- **DO NOT** set `eval-cores` or `lazy-trees` in `nix.settings` (causes warnings)

### Managed Packages & Programs
Currently managed through home-manager:

**Programs** (with declarative configuration):
- **zsh**: Shell with Antigen plugin manager, Powerlevel10k theme, and multiple plugins (git, pip, autojump, syntax-highlighting, autosuggestions, autoenv)
- **neovim**: Enabled with vi/vim aliases, NodeJS, and Python3 support
- **direnv**: Automatic environment loading with nix-direnv integration
- **fzf**: Fuzzy finder with zsh integration

**Packages** (command-line tools):
- Core tools: ripgrep (rg), fd, unzip, tree-sitter, rustup
- Development: git, gh (GitHub CLI), bat, lazygit, tree
- Utilities: tldr, tmux, jq

**Environment Variables**:
- `SUDO_ASKPASS = "/usr/local/bin/askpass.sh"`: Custom askpass script for sudo operations

## Modifying Configuration

When adding new packages or programs:
- Add system-level packages to the main module (rarely needed)
- Add user-level packages to `home-manager.users.piotrkostecki.home.packages`
- Add user programs to `home-manager.users.piotrkostecki.programs.*`

**Important notes**:
- Zsh configuration sources `~/antigen.zsh` and preserves existing Antigen plugins/Powerlevel10k theme
- Homebrew is still active (eval'd in zshrc) during migration to Nix - eventually this will be removed
- LM Studio CLI path is added to PATH in zsh configuration
- The `vim` alias points to `nvim` via zsh alias, not Nix

After any changes, run `darwin-rebuild switch --flake .#MacBook-Air-Piotr` to apply.

## Backup
`flake.nix.bak` contains a previous configuration version. Keep it as a reference but don't modify it directly.
- Apply command with sudo -A darwin-rebuild switch --flake .#MacBook-Air-Piotr when executed from claude code to allow user enter password