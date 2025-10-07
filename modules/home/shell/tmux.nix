# Tmux configuration - terminal multiplexer
# Cross-platform tmux setup with standard keybindings (Ctrl-b) and catppuccin theme

{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    # === Basic Settings ===
    prefix = "C-b";              # Default tmux prefix (Ctrl-b)
    mouse = true;                # Enable mouse support
    terminal = "screen-256color"; # Use 256 color terminal
    baseIndex = 1;               # Start window numbering at 1
    escapeTime = 0;              # No delay for escape key
    historyLimit = 50000;        # Increase history limit

    # === Plugins ===
    plugins = with pkgs.tmuxPlugins; [
      # Catppuccin theme - beautiful, soothing pastel theme
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha' # or frappe, macchiato, latte
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W"
          set -g @catppuccin_status_modules_right "directory session"
          set -g @catppuccin_status_left_separator  " "
          set -g @catppuccin_status_right_separator ""
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"
          set -g @catppuccin_directory_text "#{pane_current_path}"
        '';
      }
      # Better tmux-vim navigation
      vim-tmux-navigator
      # Save and restore tmux sessions
      resurrect
      # Automatic session saving
      continuum
      # Sensible defaults
      sensible
    ];

    # === Extra Configuration ===
    extraConfig = ''
      # === Shell Configuration ===
      # Force zsh as the default shell for tmux
      set-option -g default-shell ${pkgs.zsh}/bin/zsh
      # Start zsh as a login shell to properly load PATH
      set-option -g default-command "${pkgs.zsh}/bin/zsh -l"

      # === Standard Tmux Keybindings ===
      # Using default Ctrl-b prefix with some enhancements

      # Better window splitting (keep opening in current path)
      bind % split-window -h -c "#{pane_current_path}"  # Vertical split (default)
      bind '"' split-window -v -c "#{pane_current_path}"  # Horizontal split (default)

      # Alternative intuitive split bindings
      bind | split-window -h -c "#{pane_current_path}"  # Vertical split (|)
      bind - split-window -v -c "#{pane_current_path}"  # Horizontal split (-)

      # New window in current path
      bind c new-window -c "#{pane_current_path}"

      # Vim-style pane navigation (bonus, doesn't conflict with defaults)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Vim-style pane resizing
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Show keybinding cheatsheet
      bind ? display-message -d 0 '
      ╔════════════════════════════════════════════════╗
      ║         TMUX KEYBINDING CHEATSHEET             ║
      ╠════════════════════════════════════════════════╣
      ║ PREFIX: Ctrl-b (then press key below)         ║
      ╠════════════════════════════════════════════════╣
      ║ WINDOWS                                        ║
      ║  c      → Create new window                    ║
      ║  ,      → Rename window                        ║
      ║  &      → Kill window                          ║
      ║  n      → Next window                          ║
      ║  p      → Previous window                      ║
      ║  0-9    → Select window by number              ║
      ║  l      → Toggle last window                   ║
      ║  w      → List windows                         ║
      ╠════════════════════════════════════════════════╣
      ║ PANES                                          ║
      ║  %  or  | → Split vertically                   ║
      ║  "  or  - → Split horizontally                 ║
      ║  x        → Kill pane                          ║
      ║  o        → Cycle through panes                ║
      ║  ;        → Toggle last pane                   ║
      ║  q        → Show pane numbers                  ║
      ║  z        → Toggle pane zoom                   ║
      ║  {        → Move pane left                     ║
      ║  }        → Move pane right                    ║
      ║  Space    → Cycle pane layouts                 ║
      ╠════════════════════════════════════════════════╣
      ║ VIM-STYLE PANE NAVIGATION                      ║
      ║  h        → Select pane left                   ║
      ║  j        → Select pane down                   ║
      ║  k        → Select pane up                     ║
      ║  l        → Select pane right                  ║
      ║  H/J/K/L  → Resize pane (repeatable)           ║
      ╠════════════════════════════════════════════════╣
      ║ SESSIONS                                       ║
      ║  d        → Detach from session                ║
      ║  s        → List sessions                      ║
      ║  $        → Rename session                     ║
      ║  (        → Previous session                   ║
      ║  )        → Next session                       ║
      ╠════════════════════════════════════════════════╣
      ║ MISC                                           ║
      ║  ?        → Show this cheatsheet               ║
      ║  :        → Command prompt                     ║
      ║  t        → Show clock                         ║
      ║  r        → Reload config                      ║
      ║  [        → Enter copy mode (vi keys)          ║
      ╚════════════════════════════════════════════════╝
      Press ENTER or ESC to dismiss
      '

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      # Enable vi mode in copy mode
      setw -g mode-keys vi

      # Vi-style copy-paste
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Better status bar update interval
      set -g status-interval 5

      # Enable focus events for vim
      set -g focus-events on

      # Enable RGB color support
      set -ga terminal-overrides ",*256col*:Tc"

      # === Continuum & Resurrect Settings ===
      set -g @resurrect-strategy-nvim 'session'
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'
    '';
  };
}
