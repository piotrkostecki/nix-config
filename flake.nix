{
  description = "Multi-platform Nix configuration for macOS (nix-darwin) and Linux/WSL (home-manager)";

  # === Inputs: External Dependencies ===
  inputs = {
    # Main package repository - using unstable channel for latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # nix-darwin: System-level macOS configuration management
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";  # Use same nixpkgs
    };

    # home-manager: User-level environment and dotfiles management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";  # Use same nixpkgs
    };
  };

  # === Outputs: System Configurations ===
  outputs = { self, nixpkgs, darwin, home-manager, ... }:
  let
    # Helper function to create package set for a system
    mkPkgs = system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;  # Allow unfree packages (Spotify, VSCode, etc.)
    };
  in {
    # ===== macOS Configuration (nix-darwin) =====
    darwinConfigurations."MacBook-Air-Piotr" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";  # Apple Silicon (M1/M2/M3)

      modules = [
        # Import home-manager as a nix-darwin module
        home-manager.darwinModules.home-manager

        # Import Darwin-specific modules (system settings, Homebrew)
        ./modules/darwin

        # Import host-specific configuration
        ./hosts/MacBook-Air-Piotr

        # Home Manager configuration for this user
        {
          home-manager.useUserPackages = true;
          home-manager.users.piotrkostecki = {
            # Import cross-platform home configuration
            imports = [ ./modules/home ];

            # Home Manager state version
            home.stateVersion = "25.05";
          };
        }
      ];
    };

    # ===== Linux/WSL Configuration (standalone home-manager) =====
    homeConfigurations."piotrkostecki@wsl-ubuntu" = home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs "x86_64-linux";  # or aarch64-linux for ARM64

      modules = [
        # Import cross-platform home configuration
        ./modules/home

        # Import host-specific WSL configuration
        ./hosts/wsl-ubuntu

        # Allow unfree packages
        {
          nixpkgs.config.allowUnfree = true;
        }
      ];
    };
  };
}
