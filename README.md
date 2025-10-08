# nix-darwin Configuration

A declarative macOS system configuration using Nix flakes, nix-darwin, and home-manager.

## 📚 Documentation

- **[CLAUDE.md](./CLAUDE.md)** - Detailed configuration guide and architecture documentation
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

#### Prerequisites
- WSL2 (Windows Subsystem for Linux) or Linux distribution
- `curl` and `git` installed

#### Installation Steps

1. **Install Nix**
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

   *For WSL, you may need to enable systemd in `/etc/wsl.conf`:*
   ```ini
   [boot]
   systemd=true
   ```

2. **Enable Nix flakes** (if using official installer)
   ```bash
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

3. **Install home-manager**
   ```bash
   nix run home-manager/master -- init --switch
   ```

4. **Clone and customize this repository**
   ```bash
   git clone <your-repo-url> ~/.config/home-manager
   cd ~/.config/home-manager
   ```

5. **Create a Linux-specific configuration**

   Extract the home-manager section from `flake.nix` and adapt it:
   ```bash
   # Edit flake.nix to create a homeConfigurations output
   # Remove macOS-specific packages (darwin-only tools)
   # Adjust system to "x86_64-linux" or "aarch64-linux"
   ```

6. **Apply configuration**
   ```bash
   home-manager switch --flake .#yourusername
   ```

7. **Restart your shell**
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
