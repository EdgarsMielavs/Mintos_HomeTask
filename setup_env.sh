#!/bin/bash

# Refresh sudo credentials at the start of the script
echo "Requesting sudo permissions..."
sudo -v

# Keep sudo active throughout the script's execution
# This loop refreshes the sudo timestamp every 60 seconds in the background
(
    while true; do
        sleep 60
        sudo -v
    done
) &
SUDO_KEEP_ALIVE_PID=$!

# Function to clean up background sudo refresh on exit
cleanup() {
    kill $SUDO_KEEP_ALIVE_PID
}
trap cleanup EXIT

# set -e

run_docker_install() {
    echo "Starting Docker installation..."
    (
        ./install/install_docker.sh
    )
}

run_tool_setup() {
    echo "Starting Docker installation..."
    ( 
        sudo -v
        install_tools
        start_minikube
        set_kubectl_context
        apply_terraform
        setup_ingress

        echo "SonarQube has been successfully provisioned!"
        echo "Access SonarQube using http://sonarqube.mintos.com"
    )
}

# Function to start Minikube cluster
start_minikube() {
    echo "Starting Minikube..."
    minikube start --driver=docker --force-systemd
}

# Function to set kubectl context to Minikube
set_kubectl_context() {
    echo "Setting kubectl context to Minikube..."
    kubectl config use-context minikube
}

# Function to initialize and apply Terraform configuration
apply_terraform() {
    echo "Initializing Terraform..."
    cd terraform-project
    terraform init
    echo "Applying Terraform configuration..."

    # Add the SonarSource SonarQube repository ( Using this instead of Oteemo because it's depracated as stated in ReadMe)
    helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube

    # Add the Bitnami PostgreSQL repository
    helm repo add bitnami https://charts.bitnami.com/bitnami

    # Update the repositories
    helm repo update

    terraform apply -auto-approve
    cd -
}

# Function to check if necessary tools are installed
install_tools() {
    echo "Checking if other necessary tools are installed..."
    ./install/install_minikube.sh
    ./install/install_helm3.sh
    ./install/install_terraform.sh
}

setup_ingress() {
    echo "Setting up ingress..."

    helm upgrade --install ingress-nginx ingress-nginx \
    --repo https://kubernetes.github.io/ingress-nginx \
    --namespace ingress-nginx --create-namespace

    kubectl apply -f ingress-conf.yaml 

    minikube tunnel &
    sleep 5  # Wait a few seconds to allow tunnel to establish

    # Variables
    DOMAIN="sonarqube.mintos.com"
    NAMESPACE="ingress-nginx"  # Change to your Ingress controller's namespace if different
    INGRESS_CONTROLLER="ingress-nginx-controller"

    # Wait for the LoadBalancer external IP to be assigned
    echo "Waiting for external IP to be assigned to the LoadBalancer..."
    while true; do
        EXTERNAL_IP=$(kubectl get svc $INGRESS_CONTROLLER -n $NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)
        if [ -n "$EXTERNAL_IP" ]; then
            echo "External IP assigned: $EXTERNAL_IP"
            break
        fi
        echo "External IP not yet assigned. Retrying in 5 seconds..."
        sleep 5
    done

    # Update /etc/hosts
    HOSTS_ENTRY="$EXTERNAL_IP $DOMAIN"

    # Check if the entry already exists
    if grep -q "$DOMAIN" /etc/hosts; then
        echo "Entry for $DOMAIN already exists in /etc/hosts. Updating it."
        sudo sed -i "/$DOMAIN/d" /etc/hosts
    fi

    # Append the new entry
    echo "Adding $HOSTS_ENTRY to /etc/hosts"
    echo "$HOSTS_ENTRY" | sudo tee -a /etc/hosts > /dev/null

    echo "Done! You can now access the application at http://$DOMAIN"
}

# Execute the main function
run_docker_install &
run_tool_setup
