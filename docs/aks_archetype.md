# AKS Cluster Setup - Deployment Overview

This repository provides the configuration and infrastructure for an AKS archetype with enterprise-grade features, ensuring high availability, security, and scalability. The setup integrates with Microsoft Entra ID for authentication and authorization, supporting both internet and intranet workloads with isolated networking configurations.

---

## **Architecture Overview**

![Architecture Overview](./images/aks.png "This is an image")

### **Components**

1. **AKS Private Cluster**
   - A managed Kubernetes service for running containerized microservices.
   - Ensures private access through Azure virtual networks.

2. **Virtual Network**
   - Provides network isolation and secure communication between microservices.

3. **Ingress Controller**
   - Routes external traffic to the appropriate microservices within the cluster.

4. **Azure Load Balancer**
   - Distributes traffic evenly across AKS nodes for scalability and resilience.

5. **Azure Container Registry (ACR)**
   - A private Docker registry for securely storing and managing container images.

6. **Azure Key Vault**
   - Securely stores and manages cryptographic keys, secrets, and certificates, enhancing application security.

7. **Azure SQL Server**
   - A fully managed SQL database service with built-in high availability and disaster recovery.

8. **Azure Storage Account**
   - Provides scalable, secure, and durable cloud storage for blobs, files, queues, and tables.

9. **Azure Monitor**
   - Collects and visualizes metrics, logs, and traces for monitoring and troubleshooting.

10. **DevOps Integration**
    - Streamlines deployment with CI/CD pipelines using Azure DevOps or GitHub Actions.

---

## Key Features

### 1. **Private Cluster**
   - The AKS cluster is deployed as a private cluster, restricting API server access to authorized private endpoints only, enhancing security.

### 2. **Authentication and Authorization**
   - **Microsoft Entra ID Authentication**: Integrates with Microsoft Entra ID for user authentication.
   - **Kubernetes RBAC**: Enforces role-based access control (RBAC) for fine-grained access control.

### 3. **Node Pools**
   - **Max Pods per Node**: Supports up to 250 pods per node for high-density pod usage.
   - **Autoscaling**: Automatically adjusts the number of nodes based on resource demands for cost-efficiency.
   - **System Node Pool**: Reserved for system workloads.
   - **User Node Pools**:
     - **Internet Node Pool**:
       - Namespace: `internet`
       - Node Pool: `poolappsinternet`
       - Private IP Listener: Configured in `UserNodePoolInternetSubnet` or `WebInternetSubnet`.
       - Node Labels: `agentnodepool=poolappsinternet`
     - **Intranet Node Pool**:
       - Namespace: `intranet`
       - Node Pool: `poolappsintranet`
       - Private IP Listener: Configured in `UserNodePoolIntranetSubnet` or `WebIntranetSubnet`.
       - Node Labels: `agentnodepool=poolappsintranet`

### 4. **Service Mesh - Istio**
   - The Istio service mesh is used for traffic management, observability, security, and policy enforcement.

### 5. **Container Insights**
   - Azure Monitor’s Container Insights provides monitoring, logging, and alerting for cluster and container-level metrics.

### 6. **Network Configuration**
   - **Azure CNI Overlay**: Supports scalable pod-to-pod and pod-to-service networking with efficient IP address management.
   - **Network Policy**: Uses Calico for secure pod communication.
   - **Load Balancer**: Utilizes a Standard SKU load balancer.

### 7. **Encryption**
   - **At-rest Encryption**: All data is encrypted at rest using Azure's platform-managed encryption keys for robust data protection.

### 8. **Diagnostic Settings**
   - Configured to capture logs and metrics for comprehensive monitoring and troubleshooting.

### 9. **Defender for Cloud**
   - Secures the cluster with Microsoft Defender for Containers, offering advanced features such as vulnerability assessments, runtime protection, and threat detection.

### 10. **Secrets Management**
   - Integrates Azure Key Vault with AKS using the CSI driver for secure secrets management.

---

## **Requirements**

- **Terraform Version**: `>= 1.3.4`
- **AzureRM Provider**: `4.11.0` or later
- **AzAPI Provider**: `Azure/azapi`

This solution accelerator can be deployed standalone or integrated into an Azure Landing Zone strategy, offering a flexible and secure foundation for an AKS Cluster on Azure.

