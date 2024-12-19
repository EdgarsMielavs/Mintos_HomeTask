#!/bin/bash

# Variables
DOMAIN="sonarqube.mintos.com"
NAMESPACE="ingress-nginx"  # Change to your Ingress controller's namespace if different
INGRESS_CONTROLLER="ingress-nginx-controller"

# Step 1: Retrieve External IP
EXTERNAL_IP=$(kubectl get svc $INGRESS_CONTROLLER -n $NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Step 2: Check if External IP was retrieved
if [ -z "$EXTERNAL_IP" ]; then
    echo "Error: Unable to retrieve external IP. Is the Ingress controller running and exposed?"
    exit 1
fi

echo "Retrieved External IP: $EXTERNAL_IP"

# Step 3: Update /etc/hosts
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
