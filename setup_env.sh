#!/bin/bash

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
        setup_local_dns

        echo "SonarQube has been successfully provisioned!"
        echo "Access SonarQube using http://sonarqube.mintos.com"

        echo "Deployment complete! Press any key to exit."
        read -n 1 -s -r -p "Press any key to continue..."
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

# Function to verify if everything is running correctly
verify_deployment() {
    echo "Verifying SonarQube deployment..."

    # Check if SonarQube is deployed
    kubectl get pods -n default -l app=sonarqube
    kubectl get svc -n default
}

setup_ingress() {
    echo "Setting up ingress..."

    helm upgrade --install ingress-nginx ingress-nginx \
    --repo https://kubernetes.github.io/ingress-nginx \
    --namespace ingress-nginx --create-namespace

    minikube tunnel &

    kubectl apply -f ingress-conf.yaml 

}

setup_local_dns() {
    ls -la 
    pwd
    chmod -x ./localdns_setup.sh
    sudo bash ./localdns_setup.sh
}

# Execute the main function
run_docker_install &
run_tool_setup
