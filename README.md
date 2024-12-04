# WordPress Deployment on Minikube with Terraform

This project demonstrates deploying a WordPress application locally on a Minikube cluster using **Terraform** for infrastructure as code. The setup includes a MariaDB database as the backend and WordPress as the frontend, both running as containers on Kubernetes.

## Prerequisites

Before you begin, ensure you have the following installed:

1. [Minikube](https://minikube.sigs.k8s.io/docs/start/)  
2. [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)  
3. [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)  
4. [Docker](https://docs.docker.com/get-docker/)  

## Project Structure

```
.
├── terraform/
│   ├── main.tf                 # Kubernetes provider and resources
│   ├── variables.tf            # Terraform variables
│   ├── outputs.tf              # Output configurations
├── kubernetes/
│   ├── MariaDB-deployment.yaml   # MariaDB Deployment and Service
│   ├── wordpress-deployment.yaml  # WordPress Deployment and Service
└── README.md                   # Project documentation
```

## Getting Started

### Step 1: Start Minikube

Start a Minikube cluster:

```bash
minikube start --driver=docker
```

Confirm the cluster is running:

```bash
kubectl cluster-info
```

### Step 2: Prepare Terraform Configuration

Navigate to the `terraform/` directory and initialize Terraform:

```bash
cd terraform
terraform init
```

### Step 3: Apply Terraform Configuration

Run Terraform to deploy resources:

```bash
terraform apply -auto-approve
```

Terraform will:
- Create the Kubernetes namespace.
- Deploy WordPress and MariaDB pods along with their services.

### Step 4: Access WordPress

#### Option 1: Port Forwarding
Expose the WordPress service locally:

```bash
kubectl port-forward service/wordpress 8080:80
```

Access WordPress in your browser at `http://localhost:8080`.

#### Option 2: NodePort Service
Find the Minikube IP and NodePort:

```bash
minikube ip
kubectl get svc -n wordpress
```

Visit `http://<minikube-ip>:<node-port>` in your browser.

### Step 5: (Optional) Debugging

Check pod statuses:

```bash
kubectl get pods -n wordpress
```

View logs for troubleshooting:

```bash
kubectl logs -n wordpress <pod-name>
```

## Cleanup

To delete all resources created by Terraform, run:

```bash
terraform destroy -auto-approve
```

Stop the Minikube cluster:

```bash
minikube stop
```

## Customization

- **Scaling WordPress Pods**: Edit the `replicas` value in `wordpress-deployment.yaml` to increase or decrease the number of WordPress instances.
- **Custom Database Credentials**: Modify the `values` in `MariaDB-deployment.yaml` to set your own database username, password, and root password.

## Future Enhancements

1. **Use Helm for Simplified Deployment**:
   - Replace individual YAML files with a Helm chart for better templating and management.
2. **Add Ingress Controller**:
   - Use an Ingress to manage external access instead of NodePort.
3. **Enable Persistent Storage**:
   - Add PersistentVolumeClaims (PVCs) for MariaDB and WordPress data.
4. **Integrate Monitoring**:
   - Use tools like Prometheus and Grafana to monitor the application.

## References

- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [WordPress Documentation](https://wordpress.org/support/)

---