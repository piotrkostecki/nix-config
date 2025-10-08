# nix-darwin Configuration

A declarative macOS system configuration using Nix flakes, nix-darwin, and home-manager.

## 📚 Documentation

- **[CLAUDE.md](./CLAUDE.md)** - Detailed configuration guide and architecture documentation
- **[WSL-QUICKSTART.md](./WSL-QUICKSTART.md)** - Standalone WSL/Linux setup guide with `home.nix`
- **[Quick Reference](#quick-reference)** - Common commands and operations

## 🚀 Quickstart

### macOS Setup

#### Prerequisites
- macOS (Apple Silicon or Intel)
- Xcode Command Line Tools: `xcode-select --install`

#### Installation Steps

1. **Install Nix with Determinate Systems Installer** (recommended)
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

   *Alternative: Official Nix installer*
   ```bash
   sh <(curl -L https://nixos.org/nix/install)
   ```

2. **Clone this repository**
   ```bash
   git clone <your-repo-url> ~/.config/nix-darwin
   cd ~/.config/nix-darwin
   ```

3. **Install nix-darwin** (first time only)
   ```bash
   nix run nix-darwin -- switch --flake .#MacBook-Air-Piotr
   ```

4. **Apply configuration** (subsequent updates)
   ```bash
   darwin-rebuild switch --flake .#MacBook-Air-Piotr
   ```

   *If using Claude Code with sudo password prompt:*
   ```bash
   sudo -A darwin-rebuild switch --flake .#MacBook-Air-Piotr
   ```

5. **Restart your shell**
   ```bash
   exec zsh
   ```

### Linux/WSL Setup

**For a complete step-by-step guide with troubleshooting, see [WSL-QUICKSTART.md](./WSL-QUICKSTART.md)**

#### Quick Installation (Standalone)

Use the standalone `home.nix` configuration for instant setup:

1. **Install Nix**
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **Copy the configuration**
   ```bash
   mkdir -p ~/.config/home-manager
   curl -o ~/.config/home-manager/home.nix https://raw.githubusercontent.com/piotrkostecki/nix-config/master/home.nix
   ```

3. **Edit and customize**
   ```bash
   nano ~/.config/home-manager/home.nix
   # Change username, homeDirectory, and git info
   ```

4. **Install and apply**
   ```bash
   nix run home-manager/master -- init --switch
   ```

#### Advanced Installation (Flake)

For multi-host management with the modular configuration:

1. **Follow steps 1-2 from Quick Installation above**

2. **Clone this repository**
   ```bash
   git clone <your-repo-url> ~/.config/nix-darwin
   cd ~/.config/nix-darwin
   ```

3. **Edit WSL host configuration**
   ```bash
   nano hosts/wsl-ubuntu/default.nix
   # Customize username, homeDirectory, and settings
   ```

4. **Apply with flake**
   ```bash
   home-manager switch --flake .#piotrkostecki@wsl-ubuntu
   ```

5. **Restart your shell**
   ```bash
   exec zsh
   ```

## 📋 Quick Reference

### Common Commands

| Command | Description |
|---------|-------------|
| `darwin-rebuild switch --flake .#MacBook-Air-Piotr` | Apply configuration changes |
| `nix flake update` | Update all dependencies |
| `nix flake check` | Validate configuration |
| `darwin-rebuild --list-generations` | List system generations |
| `darwin-rebuild --rollback` | Rollback to previous generation |
| `darwin-rebuild --flake .#MacBook-Air-Piotr --dry-run` | Preview changes |

### Configuration Files

- **`flake.nix`** - Main configuration file
- **`flake.lock`** - Dependency lock file (auto-generated)
- **`CLAUDE.md`** - AI assistant instructions and detailed docs

### System Information

- **Target System**: `aarch64-darwin` (Apple Silicon)
- **Hostname**: `MacBook-Air-Piotr`
- **User**: `piotrkostecki`
- **System Version**: 6 (nix-darwin)
- **Home Manager Version**: 25.05

## 🔧 Adding Packages

### User Packages (most common)

Edit `flake.nix` and add to `home.packages`:
```nix
home.packages = with pkgs; [
  ripgrep
  fd
  # Add your package here
];
```

### Programs with Configuration

Add to `programs.*` section:
```nix
programs.git = {
  enable = true;
  userName = "Your Name";
  userEmail = "your@email.com";
};
```

### Apply Changes
```bash
darwin-rebuild switch --flake .#MacBook-Air-Piotr
```

## 🛠️ Installed Tools

### Development
- **Languages**: rustup, NodeJS, Python3
- **Version Control**: git, gh (GitHub CLI), lazygit
- **Editors**: neovim (with vi/vim aliases)

### Shell Environment
- **Shell**: zsh (Antigen, Powerlevel10k theme)
- **Utilities**: fzf, direnv, tmux, tree, bat
- **Search**: ripgrep, fd

### Other Tools
- jq, tldr, tree-sitter, unzip

## 🐛 Troubleshooting

### Configuration fails to apply
```bash
# Check for syntax errors
nix flake check

# Try dry-run to see what would change
darwin-rebuild --flake .#MacBook-Air-Piotr --dry-run
```

### Rollback after breaking change
```bash
darwin-rebuild --rollback
```

### Permission issues
```bash
# Ensure you're a trusted user
sudo dscl . -append /Groups/nixbld GroupMembership piotrkostecki
```

### WSL-specific: Nix daemon not starting
```bash
# Enable systemd in /etc/wsl.conf and restart WSL
wsl.exe --shutdown
```

## 📖 Learn More

- [Nix Manual](https://nixos.org/manual/nix/stable/)
- [nix-darwin Manual](https://daiderd.com/nix-darwin/manual/)
- [home-manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Package Search](https://search.nixos.org/packages)

## 📝 License

This is a personal configuration repository. Feel free to use as reference for your own setup.
