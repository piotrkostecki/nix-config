# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a nix-darwin configuration repository for managing macOS system configuration using Nix flakes. It integrates:
- **nix-darwin**: macOS system configuration
- **home-manager**: User environment and package management
- **nixpkgs**: Package repository (release-25.05)

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
  - `nixpkgs`: release-25.05 branch
  - `darwin`: LnL7/nix-darwin (macOS system configuration)
  - `home-manager`: release-25.05 (user environment management)

- **Outputs**: Single darwinConfiguration for "MacBook-Air-Piotr"

### Configuration Layout
The `flake.nix` contains a monolithic configuration with two main sections:
1. **System-level**: nix-darwin settings (system.stateVersion, nix.settings, users)
2. **User-level**: home-manager module for user `piotrkostecki` (home.stateVersion: "25.05")

### Key Settings
- `system.stateVersion = 6`: nix-darwin state version
- `home.stateVersion = "25.05"`: home-manager state version
- `nix.settings.trusted-users`: Allows root and piotrkostecki to use Nix daemon
- **DO NOT** set `eval-cores` or `lazy-trees` in `nix.settings` (causes warnings)

### Managed Packages & Programs
Currently managed through home-manager:
- **Neovim**: Enabled with vi/vim aliases, NodeJS, and Python3 support
- **CLI tools**: ripgrep, fd, unzip, tree-sitter

## Modifying Configuration

When adding new packages or programs:
- Add system-level packages to the main module
- Add user-level packages to `home-manager.users.piotrkostecki.home.packages`
- Add user programs to `home-manager.users.piotrkostecki.programs.*`

After any changes, run `darwin-rebuild switch --flake .#MacBook-Air-Piotr` to apply.

## Backup
`flake.nix.bak` contains a previous configuration version. Keep it as a reference but don't modify it directly.
