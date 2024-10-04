# AKS Cluster Setup - Deployment Overview

This repository provides the configuration and infrastructure for an Azure Kubernetes Service (AKS) cluster with a set of enterprise-grade features aimed at ensuring high availability, security, and scalability. This setup integrates with Microsoft Entra ID for authentication and authorization and supports both internet and intranet workloads with isolated networking configurations.

## Key Features

### 1. **Private Cluster**
   - **Enabled**: The AKS cluster is deployed as a private cluster, which restricts the API server's access to authorized private endpoints only, enhancing security.

### 2. **Authentication and Authorization**
   - **Microsoft Entra ID (Azure AD) authentication**: AKS is integrated with Microsoft Entra ID for user authentication.
   - **Kubernetes RBAC**: Role-based access control (RBAC) is enforced within the cluster, providing fine-grained access control.

### 3. **Node Pools**
   - **Max Pods per Node**: Each node supports up to 250 pods to allow for high-density pod usage.
   - **Autoscaling**: Autoscaling is enabled to automatically adjust the number of nodes based on resource demands, ensuring cost-efficiency.
   - **System Node Pool**: This pool is reserved for system workloads.
   - **User Node Pools**:
     - **Internet Node Pool**: Dedicated to handling internet-facing workloads.
       - **Namespace**: `internet`
       - **Node Pool**: `poolappsinternet`
       - **Private IP Listener**: Configured in `UserNodePoolInternetSubnet` or `WebInternetSubnet`.
       - **Node Labels**: `agentnodepool=poolappsinternet`
     - **Intranet Node Pool**: Handles internal-only workloads.
       - **Namespace**: `intranet`
       - **Node Pool**: `poolappsintranet`
       - **Private IP Listener**: Configured in `UserNodePoolIntranetSubnet` or `WebIntranetSubnet`.
       - **Node Labels**: `agentnodepool=poolappsintranet`

### 4. **Service Mesh - Istio**
   - **Enabled**: The Istio service mesh is used for traffic management, observability, security, and policy enforcement within the cluster.

### 5. **Container Insights**
   - **Enabled**: Azure Monitor’s Container Insights is enabled to provide monitoring, logging, and alerting for cluster and container-level metrics.

### 6. **Network Configuration**
   - **Azure CNI Overlay**: The cluster is using Azure CNI Overlay networking mode for pod-to-pod and pod-to-service networking, allowing for better scalability and IP address management.

### 7. **Encryption**
   - **Encryption at-rest**: All data within the cluster is encrypted at rest using Azure's platform-managed encryption keys, ensuring data protection.

### 8. **Diagnostic Settings**
   - **Enabled**: Azure diagnostic settings are configured to capture logs and metrics for monitoring and troubleshooting.

### 9. **Defender for Cloud**
   - **Microsoft Defender for Containers**: The cluster is secured using Microsoft Defender for Containers, providing advanced security features such as vulnerability assessments, runtime protection, and threat detection.

