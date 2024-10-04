## User Guide for Deploying and Managing Kubernetes Apps on AKS

This guide walks through the steps required to deploy sample applications on Azure Kubernetes Service (AKS), manage role assignments, and configure environments using Azure CLI and Kubernetes tools.

Kubernetes supports logical and physical isolation for pods. This includes using namespaces, taints, nodeselectors, node affinity and antiaffinity, etc. Some customers requires strict physical isolation to meet security requirements or to isolate large applications. They require creating a dedicated nodepool for an application. The application should be deployed into that specific nodepool.

How to achieve that ?

They have two options:

using "NodeSelector" in each deployment targeting that nodepool.
using the "anotation" scheduler.alpha.kubernetes.io/node-selector in a namespace.

---

### Prerequisites

1. Ensure you have access to the **Microsoft Container Registry (MCR)** and can SSH into the runner.
2. You must have Azure CLI installed. If not, follow the instructions here: [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).

---

### 1. Install kubectl and kubelogin

Install **kubectl** and **kubelogin** to manage and authenticate Kubernetes clusters.

- Install **kubectl** and **kubelogin** using Azure CLI:

   ```bash
   sudo az aks install-cli
   ```

   (Use `sudo` if necessary.)

   For more information, refer to the documentation: [Install Azure CLI tools](https://learn.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az-aks-install-cli).

---

### 2. Deploy Sample Applications

You can follow the official tutorial to deploy sample applications to AKS: [Deploy AKS Sample Apps](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-cli).

1. Copy the content from the file (using vi editor in container instance console)

`/tf/caf/gcc_starter_kit/validation/azure-vote-internet.yaml` into a local file `azure-vote-internet.yaml`.

`/tf/caf/gcc_starter_kit/validation/azure-vote-intranet.yaml` into a local file `azure-vote-intranet.yaml`.

2. Edit the file for your configuration as needed.

---

### 3. Log in to Azure Tenant

You need to log in to the Azure tenant and set the correct subscription.

```bash
az login --tenant [your-tenant-id]   # Replace with your tenant ID
az account set --subscription [your-subscription-id]  # Replace with your subscription ID
```

---

### 4. Get AKS Cluster Credentials

To authenticate and manage your AKS cluster, you must retrieve the credentials.

- Use the following syntax to get credentials **with admin privileges**:

   ```bash
   az aks get-credentials --resource-group <RESOURCE-GROUP-NAME> --name <AKS-CLUSTER-NAME> --admin
   ```

   Example for private and public clusters:
   
   ```bash
   az aks get-credentials --resource-group glauat-rg-solution-accelerators-aks --name glauat-aks-private-cluster --admin
   az aks get-credentials --resource-group aoaiuat-rg-solution-accelerators-aks --name glauat-aks-private-cluster --admin
   az aks get-credentials --resource-group glauat-rg-solution-accelerators-aks --name glauat-aks-private-cluster --admin
   az aks get-credentials --resource-group aoaiuat-rg-solution-accelerators-aks --name aoaiuat-aks-private-cluster --admin
   ```

---

### 5. Set KUBECONFIG Environment Variables and Authenticate

1. Set the `KUBECONFIG` environment variable:

   ```bash
   export KUBECONFIG=/home/vscode/.kube/config
   echo $KUBECONFIG
   ```

2. Convert the kubeconfig for authentication:

   ```bash
   kubelogin convert-kubeconfig
   ```

---

### 6. Manually Link AKS Private DNS Zone to DevOps Virtual Network

1. Open the **Azure Portal**.
2. Navigate to **Private DNS Zones** under resource group "<PREFIX>-rg-solution-accelerators-aks-nodes" and manually link the AKS private DNS zone to the DevOps virtual network.

   OR run this script

   az network private-dns link vnet create --resource-group myResourceGroup --zone-name example.com --name myVNetLink --virtual-network myVnet --registration-enabled false


---

### 7. Create Kubernetes Namespaces

reference: https://github.com/HoussemDellai/aks-course/tree/main/53_namespace_per_nodepool

Create the required namespaces with annotations for your applications:

```bash
kubectl create namespace nsinternet
kubectl annotate namespace nsinternet "scheduler.alpha.kubernetes.io/node-selector=agentnodepool=poolappsinternet"

kubectl create namespace nsintranet
kubectl annotate namespace nsintranet "scheduler.alpha.kubernetes.io/node-selector=agentnodepool=poolappsintranet"
```

Verify the namespaces:

```bash
kubectl get namespaces
kubectl describe namespace nsintranet
kubectl describe namespace nsintranet
```

---

### 8. Assign RBAC Permissions

To grant a specific user write access to a Kubernetes namespace, assign the **Azure Kubernetes Service RBAC Writer** role.

- **Assignee (User Email)**: The user must be part of **Entra ID** (not a B2B account).

   ```bash
   USER_EMAIL="xxxxxx@xxxxxxxxxxxx.onmicrosoft.com"
   USER_EMAIL="xxxxxxxxxx@xxxxxxxxx.onmicrosoft.com"
   ```

- Create role assignments for both the `nsinternet` and `nsintranet` namespaces:

   ```bash
   az role assignment create \
       --assignee "${USER_EMAIL}" \
       --role "Azure Kubernetes Service RBAC Writer" \
       --scope "$(az aks show --resource-group aoaiuat-rg-solution-accelerators-aks --name aoaiuat-aks-private-cluster --query id -o tsv)/namespaces/nsinternet"
   
   az role assignment create \
       --assignee "${USER_EMAIL}" \
       --role "Azure Kubernetes Service RBAC Writer" \
       --scope "$(az aks show --resource-group aoaiuat-rg-solution-accelerators-aks --name aoaiuat-aks-private-cluster --query id -o tsv)/namespaces/nsintranet"
   ```

---

### 9. Deploy Applications to AKS

Deploy the applications to specific namespaces:


1. prepare and import sample hello world images to acr

   ```bash
   ACR_NAME=<your acr name> # e.g. aoaiuatacrran33n

   az acr login --name $ACR_NAME 

   az acr import \
   --name $ACR_NAME \
   --source docker.io/hashicorp/http-echo:0.2.3 \
   --image http-echo:0.2.3

   # # ** Optional
   # az acr import \
   # --name $ACR_NAME \
   # --source mcr.microsoft.com/azuredocs/aci-helloworld:latest \
   # --image aci-helloworld:latest

   ```
   
2. Edit the application YAML files to ensure they use **port 80** for testing:
   - `azure-vote-internet.yaml`
   - `azure-vote-intranet.yaml`

3. Apply the YAML files:

   ```bash
   kubectl apply -f azure-vote-internet.yaml -n nsinternet
   kubectl apply -f azure-vote-intranet.yaml -n nsintranet

   # hello world
   kubectl apply -f hello-world-internet.yaml -n nsinternet 
   kubectl apply -f hello-world-intranet.yaml -n nsintranet

   ```

3. Verify deployment:

   ```bash
   kubectl get pods -n nsinternet -o wide
   kubectl get services -n nsinternet
   kubectl get events -n nsinternet  # Check for errors

   kubectl get pods -n nsintranet -o wide
   kubectl get services -n nsintranet
   kubectl get events -n nsintranet  # Check for errors
   ```

---

### 10. Remove Applications

To remove the deployed applications, run:

```bash
kubectl delete -f azure-vote-internet.yaml -n nsinternet
kubectl delete -f azure-vote-intranet.yaml -n nsintranet

kubectl delete -f hello-world-internet.yaml -n nsinternet
kubectl delete -f hello-world-intranet.yaml -n nsintranet

```

---

### 11. Additional Kubernetes Commands

- List pods and their nodes:
  ```bash
  kubectl get pods -o wide -n nsinternet
  # ensure all pods are in ez nodes

  kubectl get pods -o wide -n nsintranet
  # ensure all pods are in iz nodes
  
  ```

- List nodes:
  ```bash
  kubectl get nodes 
    
  ```
- login to pod bash:

   # List all pods
   kubectl get pods -n nsinternet

   # Log in to the bash shell of the container in a specific pod
   kubectl exec -it hello-world-755cb65678-hrlqj -- /bin/sh -n nsinternet

   kubectl exec -it hello-world-755cb65678-cmjkx -- /bin/sh -n nsinternet

   kubectl -n nsintranet describe pod   xxxxx

   hello-world-755cb65678-hrlqj


   # If the pod has multiple containers, specify the container name
   kubectl exec -it my-pod -c my-container -- /bin/bash -n nsinternet



<!-- 

# ** IMPORTANT - Get the resource ID of the ACR

ACR_ID=$(az acr show --name aoaiuatacrran33n --query "id" --output tsv)

CLIENT_ID=$(az aks show --resource-group aoaiuat-rg-solution-accelerators-aks --name aoaiuat-aks-private-cluster --query "identityProfile.kubeletidentity.clientId" --output tsv)

az role assignment create --assignee $CLIENT_ID --role AcrPull --scope $ACR_ID

# ** IMPORTANT - VNET Link from ACR private DNS Zone to DevOps VNET
Goto Azure Portal to do a vnet link

kubectl create secret docker-registry acr-secret \
    --docker-server=<acr name>.azurecr.io \
    --docker-username=<acr name> \
    --docker-password=<acr password> \
    --docker-email=xxxxx@xxxxx.com 
    
-->


---

### 12. Smoke Testing with cURL

Once the application is deployed, perform smoke testing from DevOps container instances or other machines where ingress/egress is configured:

```bash
# ** IMPORTANT: Ensure no NSG is blocking devops container instance to the internal load balancer

curl http://100.xx.xxx.xx/
```

---

This concludes the user guide for deploying and managing AKS applications using Azure CLI and Kubernetes.