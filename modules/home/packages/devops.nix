# DevOps tools - containers, Kubernetes, infrastructure as code
# Essential tools for cloud-native development and operations

{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # === Container Management ===
    docker           # Container platform CLI
    lazydocker       # Terminal UI for managing Docker containers and images

    # === Kubernetes ===
    kubectl          # Kubernetes command-line tool
    k9s              # Kubernetes TUI for cluster management

    # === Infrastructure as Code ===
    terraform        # Provision and manage cloud infrastructure
    ansible          # Configuration management and automation platform

    # === Cloud Provider CLIs ===
    # Uncomment the ones you need:
    # awscli2            # Amazon Web Services CLI
    # google-cloud-sdk   # Google Cloud Platform CLI
    # azure-cli          # Microsoft Azure CLI

    # === Monitoring & Debugging ===
    # httpie           # Already in development.nix
    # curl             # Already in development.nix
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    # === Linux-only packages ===
    helm             # Kubernetes package manager (not available on macOS yet)
  ];

  # === Kubernetes Aliases ===
  programs.zsh.shellAliases = {
    k = "kubectl";
    kgp = "kubectl get pods";
    kgs = "kubectl get services";
    kgd = "kubectl get deployments";
    kgn = "kubectl get namespaces";
    kdp = "kubectl describe pod";
    kl = "kubectl logs";
    kx = "kubectl exec -it";
  };
}
