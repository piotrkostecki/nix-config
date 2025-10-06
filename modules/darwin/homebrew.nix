# Homebrew configuration - GUI applications managed via Homebrew Cask
# macOS-only applications that aren't available in nixpkgs or work better via Homebrew

{ ... }:

{
  homebrew = {
    enable = true;

    # === GUI Applications (Casks) ===
    casks = [
      # === Media & Entertainment ===
      "spotify"              # Music streaming service
      "vlc"                  # Media player (alternative to IINA)

      # === Development & Tools ===
      "visual-studio-code"   # Microsoft's code editor
      "cursor"               # AI-powered code editor
      "iterm2"               # Advanced terminal emulator for macOS
      "docker-desktop"       # Docker Desktop for macOS

      # === Productivity ===
      "obsidian"             # Note-taking and knowledge management
      "drawio"               # Diagram and flowchart editor
      "freeplane"            # Mind mapping tool

      # === Communication ===
      "signal"               # Encrypted messaging app

      # === AI Tools ===
      "claude"               # Anthropic Claude desktop application

      # === Utilities ===
      "google-chrome"        # Google's web browser
      "zen-browser"          # Privacy-focused Firefox-based browser
      "google-drive"         # Cloud storage client
      "openvpn-connect"      # OpenVPN client for macOS
      "rar"                  # Archive utility for RAR files
      "balenaetcher"         # USB drive flasher
      "raspberry-pi-imager"  # Raspberry Pi SD card imager

      # === Gaming ===
      "steam"                # Game distribution platform
      "epic-games"           # Epic Games launcher

      # === Security ===
      "keeweb"               # Password manager

      # === 3D Printing ===
      "ultimaker-cura"       # 3D printing slicer software
    ];

    # === Homebrew Maintenance ===
    onActivation = {
      autoUpdate = true;     # Automatically update Homebrew itself
      cleanup = "zap";       # Remove all unlisted casks/formulas aggressively
    };
  };
}
