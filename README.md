# Mintos_HomeTask
Home Task for Infrastructure Engineer vacancy

# Environment Setup for SonarQube and PostgreSQL Deployment

This repository provides a bash script to set up an environment with Docker, Minikube, Helm 3, and Terraform. It automates the provisioning of PostgreSQL and SonarQube using Helm charts on a Minikube cluster.
Using Helm3 version because of the best practices, as Tiller considered as insecure.

***Task is not fully finished. it spins up postgresql resource from bitnami chart, and set of sonarqube + postgresql from SonarSource.
Persistent volume claim and link to sonarqube is missing, there are some deprecations which prevented from fully completing and configuring in simple way.

Persistent volume is used for stateful apps, like Databases for example, where the state is important. 
This ensures that even if container is recreated it automatically connects to volume and data which has been created/stored before.
I do understand this concept and I could use kuberneted deployments to achieve that, but sticking to requirements (Helm).

## Prerequisites

Before you begin, ensure you have the following:

- A Linux-based system (Tested on LinuxLite)
- `sudo` privileges for installing packages
- An internet connection to download necessary tools and resources

## Setup Instructions

### 1. Clone the Repository

Start by cloning this repository to your local machine:

```bash
git clone https://github.com/EdgarsMielavs/Mintos_HomeTask.git
```
### 2. Run the `setup_env.sh` Script

Inside the cloned repository, there is a bash script called `setup_env.sh`. This script will automatically install the necessary tools and provision the environment.

Run the script with the following command:

```bash
bash setup_env.sh
```

### 3. Terraform Provisioning

The `setup_env.sh` script will automatically run the **Terraform** configuration defined in `main.tf`. The configuration will:

- Provision a **PostgreSQL** instance using a Helm chart
- Deploy **SonarQube** using a Helm chart on a **Minikube** Kubernetes cluster

The script will handle the installation and setup of the Kubernetes cluster using Minikube, as well as applying the Terraform configuration. This process may take several minutes, depending on your internet speed and system performance.

Once the provisioning is complete, both PostgreSQL and SonarQube will be deployed on the Minikube cluster.

---

### 4. Ingress configuration

After the script has finished running, it will configure Ingress.
Ingress being installed via Helm charts and configured in ingress-conf.yaml
It will expose sonarqube on local DNS http://sonarqube.mintos.com

### 5. Comments
There are definitely many potential improvements in this code, this repository just gives brief overview and shows that candidate has understanding of the flow and ability to automate things, get them working/communicating together. It does not handle the installations for different OS systems and exits of some services like 'minikube tunnel' which running in background to be able to assign external IP for load balancer.