# Tmux Cheat Sheet (Screen-Style Keybindings)

This tmux configuration uses **Ctrl-a** as the prefix key (instead of the default Ctrl-b) to match GNU Screen behavior.

## 🎨 Theme
- **Catppuccin Mocha** - A soothing pastel theme with excellent readability
- Alternative flavors available: `frappe`, `macchiato`, `latte` (edit in flake.nix)

## 🔑 Core Concepts

**Prefix Key**: `Ctrl-a` (hold Ctrl, press 'a')
All commands start with the prefix key, then release and press the command key.

---

## 📋 Quick Reference

### Session Management

| Command | Description |
|---------|-------------|
| `tmux` | Start new session |
| `tmux new -s <name>` | Start new session with name |
| `ts <name>` | Start new session (alias) |
| `tmux attach -t <name>` | Attach to named session |
| `ta <name>` | Attach to session (alias) |
| `tmux ls` | List all sessions |
| `tl` | List sessions (alias) |
| `Ctrl-a d` | Detach from current session |
| `Ctrl-a :kill-session` | Kill current session |
| `Ctrl-a s` | Show session list (interactive) |
| `Ctrl-a $` | Rename current session |

### Window Management (Tabs)

| Command | Description |
|---------|-------------|
| `Ctrl-a c` | Create new window |
| `Ctrl-a k` | Kill current window (with confirmation) |
| `Ctrl-a ,` | Rename current window |
| `Ctrl-a w` | List all windows (interactive) |
| `Ctrl-a 0-9` | Switch to window by number |
| `Ctrl-a Space` | Next window |
| `Ctrl-a BSpace` | Previous window |
| `Ctrl-a n` | Next window (alternative) |
| `Ctrl-a p` | Previous window (alternative) |
| `Ctrl-a Ctrl-a` | Toggle to last active window |
| `Ctrl-a l` | Toggle to last window (alternative) |
| `Ctrl-a f` | Find window by name |

### Pane Management (Splits)

| Command | Description |
|---------|-------------|
| `Ctrl-a \|` | Split pane vertically (side-by-side) |
| `Ctrl-a -` | Split pane horizontally (top-bottom) |
| `Ctrl-a x` | Kill current pane (with confirmation) |
| `Ctrl-a q` | Show pane numbers (type number to switch) |
| `Ctrl-a o` | Cycle through panes |
| `Ctrl-a ;` | Toggle to last active pane |
| `Ctrl-a {` | Move pane left |
| `Ctrl-a }` | Move pane right |
| `Ctrl-a z` | Toggle pane zoom (fullscreen) |
| `Ctrl-a !` | Convert pane to window |
| `Ctrl-a Space` | Cycle through pane layouts |

### Pane Navigation (Vim-Style)

| Command | Description |
|---------|-------------|
| `Ctrl-a h` | Move to left pane |
| `Ctrl-a j` | Move to pane below |
| `Ctrl-a k` | Move to pane above |
| `Ctrl-a l` | Move to right pane |

### Pane Resizing (Vim-Style)

| Command | Description |
|---------|-------------|
| `Ctrl-a H` | Resize pane left (5 cells) |
| `Ctrl-a J` | Resize pane down (5 cells) |
| `Ctrl-a K` | Resize pane up (5 cells) |
| `Ctrl-a L` | Resize pane right (5 cells) |

**Note**: Hold `Ctrl-a`, then repeatedly press H/J/K/L for continuous resizing.

### Copy Mode (Vim-Style)

| Command | Description |
|---------|-------------|
| `Ctrl-a [` | Enter copy mode |
| `q` | Quit copy mode |
| `v` | Begin selection (in copy mode) |
| `y` | Copy selection and exit (in copy mode) |
| `h/j/k/l` | Move cursor (in copy mode) |
| `Ctrl-u` | Scroll up half page |
| `Ctrl-d` | Scroll down half page |
| `g` | Go to top |
| `G` | Go to bottom |
| `/` | Search forward |
| `?` | Search backward |
| `n` | Next search match |
| `N` | Previous search match |
| `Ctrl-a ]` | Paste copied text |

### System Commands

| Command | Description |
|---------|-------------|
| `Ctrl-a r` | Reload tmux configuration |
| `Ctrl-a ?` | List all keybindings |
| `Ctrl-a :` | Enter command mode |
| `Ctrl-a t` | Show time |
| `Ctrl-a Ctrl-a` | Send `Ctrl-a` to nested tmux/screen |

### Mouse Support

Mouse support is **enabled** by default:
- Click panes to switch
- Click window names to switch windows
- Click and drag pane borders to resize
- Scroll to navigate history
- Click and drag to select text (auto-copies)

---

## 🚀 Advanced Features

### Tmux Resurrect & Continuum

Your sessions are automatically saved every 15 minutes and restored on tmux start.

**Manual controls:**
- `Ctrl-a Ctrl-s` - Save current session manually
- `Ctrl-a Ctrl-r` - Restore saved session manually

**What's saved:**
- Window layouts and positions
- Active panes
- Working directories
- Neovim sessions (if using)

### Vim-Tmux Navigator

Seamlessly navigate between vim splits and tmux panes using the same keys:
- `Ctrl-h` - Move left
- `Ctrl-j` - Move down
- `Ctrl-k` - Move up
- `Ctrl-l` - Move right

**Note**: These work both in Neovim and tmux panes without prefix!

---

## 💡 Common Workflows

### Create a Development Environment

```bash
# Start named session
tmux new -s dev

# Split into editor + terminal
Ctrl-a |                 # Vertical split
Ctrl-a h                 # Move to left pane
nvim                     # Start editor

Ctrl-a l                 # Move to right pane
Ctrl-a -                 # Horizontal split
Ctrl-a k                 # Move up
npm run dev              # Start dev server

Ctrl-a j                 # Move down
git status               # Check git status
```

### Managing Multiple Projects

```bash
# Create sessions for different projects
tmux new -s frontend
tmux new -s backend
tmux new -s database

# List and switch between them
Ctrl-a s                 # Show session list
# Use arrow keys and Enter to switch
```

### Quick Terminal Split

```bash
# Split and run a command
Ctrl-a -                 # Horizontal split
npm test                 # Run tests
Ctrl-a k                 # Return to main pane
```

---

## 🎯 Pro Tips

1. **Window Numbering**: Windows start at 1 (not 0) for easier keyboard access
2. **Current Directory**: New panes/windows open in the current directory
3. **Detach Safely**: Use `Ctrl-a d` instead of closing the terminal
4. **Session Recovery**: If you disconnect, your session is still running - just reattach!
5. **Nested Sessions**: Use `Ctrl-a Ctrl-a` to send commands to nested tmux/screen
6. **Quick Switching**: `Ctrl-a Ctrl-a` toggles between your last two windows
7. **Zoom Pane**: `Ctrl-a z` to focus on one pane, press again to unzoom
8. **Status Bar**: Shows current directory and session name (Catppuccin theme)

---

## 🔧 Customization

The configuration is managed through **nix-darwin** in `flake.nix`:

### Change Theme Flavor

Edit line 171 in `flake.nix`:
```nix
set -g @catppuccin_flavour 'mocha'  # Change to: frappe, macchiato, or latte
```

### Add Custom Keybindings

Add to the `extraConfig` section in `flake.nix` (line 198+):
```nix
bind-key <key> <command>
```

### Apply Changes

After editing `flake.nix`:
```bash
darwin-rebuild switch --flake .#MacBook-Air-Piotr
```

---

## 📚 Additional Resources

- [Official Tmux Documentation](https://github.com/tmux/tmux/wiki)
- [Catppuccin Theme](https://github.com/catppuccin/tmux)
- [Tmux Plugin Manager (TPM)](https://github.com/tmux-plugins/tpm)
- [Screen vs Tmux Command Comparison](https://gist.github.com/MohamedAlaa/2961058)

---

## 🆘 Troubleshooting

**Colors look wrong?**
- Make sure your terminal supports 256 colors
- Try: `export TERM=screen-256color`

**Plugins not loading?**
- Run: `darwin-rebuild switch --flake .#MacBook-Air-Piotr`
- Restart tmux: `tmux kill-server && tmux`

**Sessions not auto-restoring?**
- Check `~/.local/share/tmux/resurrect/` for saved states
- Manual restore: `Ctrl-a Ctrl-r`

**Mouse not working?**
- Verify `mouse = true;` in flake.nix (line 157)
- Check terminal mouse support settings

---

**Version**: Managed by nix-darwin
**Last Updated**: 2025-10-03
**Configuration**: `/Users/piotrkostecki/.config/nix-darwin/flake.nix`
