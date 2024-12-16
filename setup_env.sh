#!/bin/bash

# set -e

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
    terraform init
    echo "Applying Terraform configuration..."
    terraform apply -auto-approve
}

# Function to check if necessary tools are installed
check_tools() {
    echo "Checking if necessary tools are installed..."
    ./install/install_docker.sh
    ./install/install_minikube.sh
    ./install/install_helm3.sh
    ./install/install_terraform.sh
}

# Function to provision SonarQube and PostgreSQL using Helm
provision_sonarqube() {
    echo "Provisioning SonarQube and PostgreSQL using Helm..."

    # Install Nginx Ingress Controller
    echo "Installing Nginx Ingress Controller..."
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm install nginx-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace

    # Install PostgreSQL via Helm
    echo "Installing PostgreSQL via Helm..."
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm install postgresql bitnami/postgresql --set postgresqlPassword=sonarqube

    # Install SonarQube via Helm
    echo "Installing SonarQube via Helm..."
    helm repo add sonarsource https://charts.sonarsource.com
    helm install sonarqube sonarsource/sonarqube \
        --set sonarPostgresql.databaseUrl=jdbc:postgresql://postgresql.default.svc.cluster.local:5432/sonarqube \
        --set sonarPostgresql.username=postgres \
        --set sonarPostgresql.password=sonarqube \
        --set persistence.enabled=true
}

# Function to verify if everything is running correctly
verify_deployment() {
    echo "Verifying SonarQube deployment..."

    # Check if SonarQube is deployed
    kubectl get pods -n default -l app=sonarqube
    kubectl get svc -n default
}

# Main execution
main() {
    
    # Request sudo password to ensure we have the necessary permissions
    sudo -v

    check_tools
    start_minikube
    set_kubectl_context
    apply_terraform
    # provision_sonarqube
    # verify_deployment
    # echo "SonarQube has been successfully provisioned!"
    # echo "Access SonarQube using the Minikube URL."

    echo "Deployment complete! Press any key to exit."
    read -n 1 -s -r -p "Press any key to continue..."
}

# Execute the main function
main
