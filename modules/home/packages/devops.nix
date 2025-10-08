# DevOps tools - containers, Kubernetes, infrastructure as code
# Essential tools for cloud-native development and operations

{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # === Container Management ===
    docker           # Container platform CLI
    docker-compose   # Define and run multi-container Docker applications
    lazydocker       # Terminal UI for managing Docker containers and images
    dive             # Tool for exploring Docker image layers
    ctop             # Top-like interface for container metrics

    # === Kubernetes ===
    kubectl          # Kubernetes command-line tool
    k9s              # Kubernetes TUI for cluster management
    openshift        # OpenShift client (oc) - Red Hat's Kubernetes distribution

    # === Infrastructure as Code ===
    # terraform      # Provision and manage cloud infrastructure (DISABLED)
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

  # === Kubernetes & OpenShift Aliases ===
  programs.zsh.shellAliases = {
    # Kubernetes
    k = "kubectl";
    kgp = "kubectl get pods";
    kgs = "kubectl get services";
    kgd = "kubectl get deployments";
    kgn = "kubectl get namespaces";
    kdp = "kubectl describe pod";
    kl = "kubectl logs";
    kx = "kubectl exec -it";

    # OpenShift
    ocl = "oc login";
    ocp = "oc get pods";
    ocproject = "oc project";
    oclogs = "oc logs";

    # Docker debugging
    dps = "docker ps";
    dimg = "docker images";
    dlogs = "docker logs";
    dexec = "docker exec -it";
  };
}
