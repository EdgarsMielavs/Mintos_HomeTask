provider "kubernetes" {
  config_path = "~/.kube/config"  # Ensure your kubectl is configured to Minikube
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"  # Ensure your kubectl is configured to Minikube
  }
}

resource "helm_release" "postgresql" {
  name       = "postgresql"
  namespace  = "default"  # Set this to the appropriate namespace
  repository = "bitnami"
  chart      = "postgresql"

  values = [
    file("./helm-values/postgresql.yaml")
  ]
  wait     = true
  timeout  = 300  # Timeout in seconds (e.g., 5 minutes)
}

resource "helm_release" "sonarqube" {
  name       = "sonarqube"
  namespace  = "default" 
  repository = "sonarqube"
  chart      = "sonarqube"
  version    = "~8"  # Ensure to use version ~8
  
  values = [
    file("./helm-values/sonarqube.yaml") # Reference your values file
  ]

  wait     = true
  timeout  = 600  # Timeout in seconds (e.g., 5 minutes)
}
