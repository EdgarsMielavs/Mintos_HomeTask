# Function to install Helm if it's not installed
install_helm() {
    echo -e "
    --------------------------------------------
                HELM3 INSTALLATION
    --------------------------------------------
    "
    if ! command -v helm &>/dev/null; then
        
        echo "Helm not found. Installing..."
        # Install Helm 3
        curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    else
        echo "Helm is already installed."
    fi
}

install_helm
