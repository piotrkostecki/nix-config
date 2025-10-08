# WSL/Linux Quick Setup Guide

This guide will help you set up the standalone `home.nix` configuration on a fresh WSL or Linux system.

## Prerequisites

- WSL2 or Linux distribution
- Internet connection
- Basic terminal knowledge

## Installation Steps

### 1. Install Nix

Run the Determinate Systems Nix installer (recommended):

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

**For WSL specifically**, you may need to enable systemd first. Create or edit `/etc/wsl.conf`:

```bash
sudo nano /etc/wsl.conf
```

Add:
```ini
[boot]
systemd=true
```

Then restart WSL from PowerShell/CMD:
```powershell
wsl --shutdown
```

After restarting WSL, run the Nix installer above.

### 2. Restart Your Shell

```bash
exec $SHELL
```

Or close and reopen your terminal.

### 3. Verify Nix Installation

```bash
nix --version
```

You should see output like: `nix (Nix) 2.x.x`

### 4. Set Up Home Manager Directory

```bash
mkdir -p ~/.config/home-manager
```

### 5. Copy the Configuration File

**Option A: Clone the entire repository**
```bash
git clone https://github.com/piotrkostecki/nix-config.git ~/nix-config
cp ~/nix-config/home.nix ~/.config/home-manager/home.nix
```

**Option B: Download just the home.nix file**
```bash
curl -o ~/.config/home-manager/home.nix https://raw.githubusercontent.com/piotrkostecki/nix-config/master/home.nix
```

### 6. Customize the Configuration

Edit the file and change these values to match your system:

```bash
nano ~/.config/home-manager/home.nix
```

**Required changes:**
- Line 14: `home.username = "YOUR_USERNAME";`
- Line 15: `home.homeDirectory = "/home/YOUR_USERNAME";`
- Line 130: `userName = "Your Name";`
- Line 131: `userEmail = "your.email@example.com";`

Find your username:
```bash
whoami
```

Find your home directory:
```bash
echo $HOME
```

### 7. Install Home Manager

```bash
nix run home-manager/master -- init --switch
```

This will:
- Install home-manager
- Apply your configuration
- Install all packages defined in `home.nix`

### 8. Apply Your Configuration

After the initial setup, any time you modify `home.nix`, apply changes with:

```bash
home-manager switch
```

Or use the alias defined in the config:
```bash
hms
```

### 9. Restart Your Shell

```bash
exec zsh
```

You should see the welcome message and be in the new zsh shell with all plugins loaded!

## What You Get

### Installed Programs
- **Shell**: zsh with oh-my-zsh, autosuggestions, and syntax highlighting
- **Editor**: neovim (with `vi` and `vim` aliases)
- **Version Control**: git, gh (GitHub CLI), lazygit
- **Utilities**: ripgrep, fd, bat, tree, jq, tldr, fzf
- **Development**: rustup (Rust toolchain)
- **Terminal**: tmux (multiplexer)
- **WSL Tools**: wslu (wslview, wslpath, etc.)

### Shell Features
- Modern zsh with autocompletion and suggestions
- Git-aware prompt
- Fuzzy file search with `fzf` (Ctrl+T)
- Directory auto-environment with `direnv`
- Syntax-highlighted `cat` with `bat`
- Better search with `ripgrep` and `fd`

### Useful Aliases
- `ll` - Detailed file listing
- `cat` - Syntax-highlighted cat (uses bat)
- `g`, `gs`, `ga`, `gc`, `gp`, `gl` - Git shortcuts
- `hms` - Rebuild home-manager configuration
- `hme` - Edit home-manager configuration

## Useful Commands

### Home Manager
```bash
home-manager switch           # Apply configuration
home-manager edit             # Edit configuration
home-manager generations      # List generations
home-manager remove-generations old  # Clean old generations
```

### Package Management
```bash
nix-env -q                    # List installed packages
nix search nixpkgs <package>  # Search for packages
nix run nixpkgs#<package>     # Run package without installing
```

### Shell
```bash
zsh                           # Start zsh shell
exec zsh                      # Restart zsh (reload config)
```

## Troubleshooting

### Home Manager command not found
```bash
# Add to PATH manually
export PATH="$HOME/.nix-profile/bin:$PATH"
# Then run again:
nix run home-manager/master -- switch
```

### Zsh not set as default shell
```bash
# Check available shells
cat /etc/shells

# If zsh is there, set it as default:
chsh -s $(which zsh)

# If not, add Nix's zsh:
command -v zsh | sudo tee -a /etc/shells
chsh -s $(which zsh)
```

### Git credential helper not working
Edit `~/.config/home-manager/home.nix` and uncomment line 140:
```nix
credential.helper = "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
```

Make sure Git for Windows is installed on your Windows host.

### WSL systemd not starting
Ensure you added the systemd configuration to `/etc/wsl.conf` and ran `wsl --shutdown` from PowerShell.

### Nix daemon not running
```bash
# Start manually
sudo systemctl start nix-daemon

# Enable on boot
sudo systemctl enable nix-daemon
```

## Next Steps

### Customize Your Configuration
Edit `~/.config/home-manager/home.nix` to:
- Add more packages to `home.packages`
- Customize shell aliases
- Configure additional programs
- Adjust zsh theme and plugins

After editing, run:
```bash
home-manager switch
```

### Upgrade to Flake Configuration
For a more advanced setup with multiple hosts, consider using the full flake configuration:

```bash
# Clone the full repository
git clone https://github.com/piotrkostecki/nix-config.git ~/.config/nix-darwin

# Edit the WSL host configuration
nano ~/.config/nix-darwin/hosts/wsl-ubuntu/default.nix
# Update: home.username, home.homeDirectory

# IMPORTANT: Update git user configuration
nano ~/.config/nix-darwin/modules/home/packages/development.nix
# Update: programs.git.userName and programs.git.userEmail

# Apply with flake
home-manager switch --flake ~/.config/nix-darwin#piotrkostecki@wsl-ubuntu
```

## Resources

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Package Search](https://search.nixos.org/packages)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.xhtml)
- [Nix Pills](https://nixos.org/guides/nix-pills/) - Learn Nix in depth

## Support

If you encounter issues:
1. Check the [troubleshooting section](#troubleshooting)
2. Review the [Home Manager manual](https://nix-community.github.io/home-manager/)
3. Ask in the [NixOS Discourse](https://discourse.nixos.org/)
4. Check [GitHub issues](https://github.com/nix-community/home-manager/issues)
