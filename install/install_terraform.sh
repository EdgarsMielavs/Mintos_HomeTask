# Function to install Terraform if it's not installed
install_terraform() {

    echo -e "
    --------------------------------------------
                TERRAFORM INSTALLATION
    --------------------------------------------
    "
    if ! command -v terraform &>/dev/null; then
        # Define the version of Terraform you want to install
        TERRAFORM_VERSION="1.10.2"

        # Download Terraform binary
        echo "Downloading Terraform version $TERRAFORM_VERSION..."
        wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -O terraform.zip

        # Unzip the binary
        echo "Unzipping Terraform binary..."
        unzip -o terraform.zip

        # Move the binary to a directory in your PATH
        echo "Installing Terraform..."
        sudo mv terraform /usr/local/bin/

        # Clean up
        echo "Cleaning up..."
        rm -f terraform.zip

        echo "Terraform installation complete."
    else
        echo "Terraform is already installed."
    fi
}

install_terraform
