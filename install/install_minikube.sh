# Function to install Minikube if it's not installed
install_minikube() {
    echo -e "
    --------------------------------------------
                MINIKUBE INSTALLATION
    --------------------------------------------
    "
    if ! command -v minikube &>/dev/null; then

        echo "Minikube not found. Installing..."
        # Install Minikube
        curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
        sudo install minikube /usr/local/bin/

        #kubectl utility
        curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
        chmod +x kubectl
        sudo mv kubectl /usr/local/bin/
    else
        echo "Minikube is already installed."
    fi
}

install_minikube
