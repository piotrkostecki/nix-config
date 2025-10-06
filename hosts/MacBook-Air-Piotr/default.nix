# MacBook Air (M-series) - Host-specific configuration
# Machine-specific overrides and customizations

{ pkgs, lib, ... }:

{
  # === Host Information ===
  # This configuration is specific to MacBook-Air-Piotr
  # System: aarch64-darwin (Apple Silicon)

  # === Host-Specific Overrides ===
  # Add any machine-specific settings here

  # Example: Host-specific environment variables
  # home-manager.users.piotrkostecki.home.sessionVariables = {
  #   CUSTOM_VAR = "value";
  # };

  # Example: Host-specific packages
  # home-manager.users.piotrkostecki.home.packages = with pkgs; [
  #   # Add packages specific to this machine
  # ];
}
