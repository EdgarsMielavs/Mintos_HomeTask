#!/bin/bash

# Function to uninstall Minikube
uninstall_minikube() {
    echo "Uninstalling Minikube..."

    # Stop and delete all Minikube clusters
    minikube stop 2>/dev/null || echo "Minikube is not running."
    minikube delete --all 2>/dev/null || echo "No Minikube clusters to delete."

    # Remove Minikube binary
    sudo rm -f /usr/local/bin/minikube

    # Remove Minikube data and configuration
    rm -rf ~/.minikube

    # Verify uninstallation
    if ! command -v minikube &>/dev/null; then
        echo "Minikube has been successfully uninstalled."
    else
        echo "Failed to uninstall Minikube."
    fi
}

# Function to uninstall Helm
uninstall_helm() {
    echo "Uninstalling Helm..."

    # Remove Helm binary
    sudo rm -f /usr/local/bin/helm

    # Remove Helm-related files
    rm -rf ~/.cache/helm ~/.config/helm ~/.local/share/helm

    # Verify uninstallation
    if ! command -v helm &>/dev/null; then
        echo "Helm has been successfully uninstalled."
    else
        echo "Failed to uninstall Helm."
    fi
}

# Function to uninstall Terraform
uninstall_terraform() {
    echo "Uninstalling Terraform..."

    # Remove Terraform binary
    sudo rm -f /usr/local/bin/terraform

    # Remove Terraform-related files
    rm -rf ~/.terraform.d
    find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null

    # Verify uninstallation
    if ! command -v terraform &>/dev/null; then
        echo "Terraform has been successfully uninstalled."
    else
        echo "Failed to uninstall Terraform."
    fi
}

# Function to uninstall Docker
uninstall_docker() {
    echo "Uninstalling Docker..."

    # Stop all Docker containers (if any are running)
    sudo docker stop $(sudo docker ps -aq) 2>/dev/null || echo "No Docker containers are running."

    # Remove all Docker containers
    sudo docker rm $(sudo docker ps -aq) 2>/dev/null || echo "No Docker containers to remove."

    # Remove Docker images
    sudo docker rmi $(sudo docker images -q) 2>/dev/null || echo "No Docker images to remove."

    # Remove Docker binary
    sudo rm -f /usr/local/bin/docker

    # Uninstall Docker (assuming system uses a package manager like apt)
    if command -v apt &>/dev/null; then
        sudo apt-get purge -y docker-ce docker-ce-cli containerd.io
        sudo apt-get autoremove -y
    elif command -v yum &>/dev/null; then
        sudo yum remove -y docker-ce docker-ce-cli containerd.io
    fi

    # Remove Docker-related files
    sudo rm -rf /var/lib/docker
    sudo rm -rf ~/.docker

    # Verify uninstallation
    if ! command -v docker &>/dev/null; then
        echo "Docker has been successfully uninstalled."
    else
        echo "Failed to uninstall Docker."
    fi
}

# Main function to uninstall all tools
main() {
    echo "Starting uninstallation of Minikube, Helm, and Terraform..."
    uninstall_minikube
    uninstall_helm
    uninstall_terraform
    uninstall_docker
    echo "Uninstallation process complete."
}

# Execute the main function
main
