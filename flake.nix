{
  # Declare external dependencies that this flake relies on.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }:
  let
    # Target architecture for the host we are configuring.
    system = "aarch64-darwin";  # M1/M2/M3
    # Convenience handle for packages coming from nixpkgs.
    pkgs   = import nixpkgs { inherit system; };
  in {
    darwinConfigurations."MacBook-Air-Piotr" = darwin.lib.darwinSystem {
      inherit system;
      modules = [
        home-manager.darwinModules.home-manager
        {
          # Core nix-darwin configuration for the host.
          system.stateVersion = 6;
          # Disable nix-darwin's Nix management (required for Determinate Nix)
          nix.enable = false;
          # remove unsupported settings from your nix.settings if present:
          nix.settings = {
            trusted-users = [ "root" "piotrkostecki" ];
            # DO NOT set eval-cores or lazy-trees here; they cause your warnings
          };

          users.users.piotrkostecki.home = "/Users/piotrkostecki";

          home-manager.useUserPackages = true;
          home-manager.users.piotrkostecki = { pkgs, ... }: {
            home.stateVersion = "25.05";
            home.enableNixpkgsReleaseCheck = false;
            home.sessionVariables = {
              SUDO_ASKPASS = "/usr/local/bin/askpass.sh";
            };
            # Basic Neovim setup managed through Home Manager.
            programs.neovim = {
              enable = true;
              viAlias = true;
              vimAlias = true;
              withNodeJs = true;
              withPython3 = true;
            };
            # Extra CLI tools to install for the user.
            home.packages = with pkgs; [ ripgrep fd unzip tree-sitter rustup ];
          };
        }
      ];
    };
  };
}
