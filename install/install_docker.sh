# Function to install Docker if it's not installed
install_docker() {
    echo -e "
    --------------------------------------------
                DOCKER INSTALLATION
    --------------------------------------------
    "
    if ! command -v docker &>/dev/null; then
        echo "Docker not found. Installing..."
        # Update package list
        sudo apt-get update

        # Install required dependencies
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

        # Add Docker's official GPG key
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /usr/share/keyrings/docker-archive-keyring.gpg > /dev/null

        # Set up Docker repository
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        # Update package list again to include Docker packages
        sudo apt-get update

        # Install Docker
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io

        # Add user to docker group
        sudo usermod -aG docker $USER

        # Verify Docker installation
        sudo systemctl start docker
        sudo systemctl enable docker
        echo "Docker installation complete."
    else
        echo "Docker is already installed."
    fi
}

install_docker
