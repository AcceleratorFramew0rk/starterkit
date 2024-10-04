# ensure has access to mcr
# ssh into rover runner
# deploy sample apps
# https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-cli


# Using azure cli to install kubelogin
# There is another option to install Kubectl and Kubectl login. Documentation on this is here: https://learn.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az-aks-install-cli
# install (May require using the command ‘sudo’)
sudo az aks install-cli

# copy and paste content of "/tf/caf/gcc_starter_kit/validation/azure-vote-internet.yaml" into azure-vote-internet.yaml

# login to tenant - must use this syntax to login
az login --tenant [your tenant id] # htx sandpit - xxxxxx-ffda-45c1-adc5-xxxxxxxxxxxx
az account set --subscription [your subscription id] 

# get aks credentials
# ** IMPORTANT - make sure --admin
# syntax: az aks get-credentials --resource-group <RESOURCE GROUP NAME> --name <AKS Cluster Name> --admin
az aks get-credentials --resource-group aoaiuat-rg-solution-accelerators-aks --name aks-private-cluster  --admin
az aks get-credentials --resource-group aoaiuat-rg-solution-accelerators-aks --name aks-aoaiuat-aks-ran  --admin

# set KUBECONFIG envirnoment variables and kubelogin
export KUBECONFIG=/home/vscode/.kube/config
echo KUBECONFIG
kubelogin convert-kubeconfig

# link aks private dns zone to devops virtual network manually through azure portal
# ** IMPORTANT
open azure portal, manually do a vnet link to the aks private dns zone



# create namespaces
kubectl create namespace internet
kubectl create namespace intranet

kubectl get namespaces

# To grant this user write access in only that namespace, grant Azure Kubernetes Service RBAC Writer permissions at the scope of only the namespace:

# USER_EMAIL="thiamsoontan@microsoft.com"
# the account must be inside Entra ID, and not B2B account
USER_EMAIL="avdthiamsoon@htxsandpit.onmicrosoft.com"
echo $USER_EMAIL
<!-- $ az role assignment create \
    --assignee "${USER_EMAIL}" \
    --role "Azure Kubernetes Service RBAC Writer" \
    --scope "$(az aks show \
        --resource-group aoaiuat-rg-solution-accelerators-aks \
        --name aks-private-cluster \
        --query id -o tsv)/namespaces/internet" -->

az role assignment create \
    --assignee "${USER_EMAIL}" \
    --role "Azure Kubernetes Service RBAC Writer" \
    --scope "$(az aks show \
        --resource-group aoaiuat-rg-solution-accelerators-aks \
        --name aks-aoaiuat-aks-ran \
        --query id -o tsv)/namespaces/internet"


<!-- $ az role assignment create \
    --assignee "${USER_EMAIL}" \
    --role "Azure Kubernetes Service RBAC Writer" \
    --scope "$(az aks show \
        --resource-group aoaiuat-rg-solution-accelerators-aks \
        --name aks-private-cluster \
        --query id -o tsv)/namespaces/intranet" -->

az role assignment create \
    --assignee "${USER_EMAIL}" \
    --role "Azure Kubernetes Service RBAC Writer" \
    --scope "$(az aks show \
        --resource-group aoaiuat-rg-solution-accelerators-aks \
        --name aks-aoaiuat-aks-ran \
        --query id -o tsv)/namespaces/intranet"


# edit azure-vote.yaml - paste content - ensure using port 80 only for testing
vi azure-vote-internet.yaml
vi azure-vote-intranet.yaml

# intranet app - to specific nodes - set nodeSelector "app = user" and service to specific subnet (frontend ip)
kubectl apply -f azure-vote-intranet.yaml  -n intranet
kubectl get pods -n intranet
kubectl get pods -n intranet -o wide
kubectl get services -n intranet
kubectl get events  -n intranet # check if any error creating the internal load balancer


# internet - to specific nodes  - set nodeSelector "app = user" and service to specific subnet (frontendip)
kubectl apply -f azure-vote-internet.yaml -n internet
kubectl get pods -n internet
kubectl get pods -n internet -o wide
kubectl get services -n internet
kubectl get events  -n internet

# remove the containers
kubectl delete -f azure-vote-intranet.yaml -n intranet
kubectl delete -f azure-vote-internet.yaml -n internet

# list pods and their nodes
kubectl get pods -o wide

# list nodes
kubectl get nodes

# curl http url to perform smoke testing from devops container instances or gsib machine if ingress/egress is setup 
➜  caf curl http://100.xx.xxx.xx/

# -----------------------------------------------------------------------------------------
# define in your yaml file the following:

<!-- 
    spec:
      nodeSelector:
        "kubernetes.io/os": linux
        "app": user   

metadata:
  name: azure-vote-front
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-internal: "true"
    service.beta.kubernetes.io/azure-load-balancer-internal-subnet: "UserNodePoolSubnet" -->
# -----------------------------------------------------------------------------------------


<!-- Azure Kubernetes Service Cluster Admin Role - List cluster admin credential action.
Azure Kubernetes Service Cluster Monitoring User - List cluster monitoring user credential action.
Azure Kubernetes Service Cluster User Role - List cluster user credential action.

Azure Kubernetes Service Contributor Role - Grants access to read and write Azure Kubernetes Service clusters

Azure Kubernetes Service RBAC Admin - Lets you manage all resources under cluster/namespace, except update or delete resource quotas and namespaces.

Azure Kubernetes Service RBAC Cluster Admin - Lets you manage all resources in the cluster.

Azure Kubernetes Service RBAC Reader - Allows read-only access to see most objects in a namespace. It does not allow viewing roles or role bindings. This role does not allow viewing Secrets, since reading the contents of Secrets enables access to ServiceAccount credentials in the namespace, which would allow API access as any ServiceAccount in the namespace (a form of privilege escalation). Applying this role at cluster scope will give access across all namespaces.

Azure Kubernetes Service RBAC Writer -->


<!-- # make sure has the following right to the aks cluster
Azure Kubernetes Service Contributor Role - Grants access to read and write Azure Kubernetes Service clusters -->

# -----------------------------------------------------------------------------------------


# sql commands

# apt (Debian/Ubuntu)
# Import the public repository GPG keys.

curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc

# Add the Microsoft repository, where the ubuntu/20.04 segment might be debian/11, ubuntu/20.04, or ubuntu/22.04.

sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/prod.list)"

# Install sqlcmd (Go) with apt.

sudo apt-get update
sudo apt-get install sqlcmd

echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bash_profile
source ~/.bash_profile

sqlcmd -S <server_name> -U <username> -P <password>

CREATE DATABASE <database_name>;

USE <database_name>;

Create Table: The general syntax for creating a table is:

CREATE TABLE table_name (column1 datatype, column2 datatype, ...);
For example, to create a table named Students, enter the following command:

CREATE TABLE Students (StudentId int, StudentName nvarchar(50), StudentAge int);

sqlcmd
USE AdventureWorks2022;
GO

USE AdventureWorks2022;
GO
SELECT TOP (3) BusinessEntityID, FirstName, LastName
FROM Person.Person;
GO

# **IMPORTANT 
# TODO: 
# 1. link the aks private DNS to devops vnet, else will not be able to find AKS private cluster.
# 2. Grant netwrok contributor and reader to gcci-vnet-internet vnet to allow creation of internal load balancer
# virtual network: /subscriptions/xxxxxxxx-4066-42f0-b0fa-xxxxxxxxxxxx/resourceGroups/gcci-platform/providers/Microsoft.Network/virtualNetworks/gcci-vnet-internet
# permission: Reader and Network Contributor
ERROR:
''' BASH
Error syncing load balancer: failed to ensure load balancer: Retriable: false, RetryAfter: 0s, HTTPStatusCode: 403, RawError: {"error":{"code":"AuthorizationFailed","message":"The client '3448bfd3-5774-4682-a10a-cab46df1e337' with object id '3448bfd3-5774-4682-a10a-cab46df1e337' does not have authorization to perform action 'Microsoft.Network/virtualNetworks/subnets/read' over scope '/subscriptions/xxxxxxxx-4066-42f0-b0fa-xxxxxxxxxxxx/resourceGroups/gcci-platform/providers/Microsoft.Network/virtualNetworks/gcci-vnet-internet/subnets/ignite-snet-app-internet' or the scope is invalid. If access was recently granted, please refresh your credentials."}}
'''
Resolution:
Grant "reader" and "network contributor" to managed identity "ignite-msi-aks-usermsi" (object id: 3448bfd3-5774-4682-a10a-cab46df1e337) to vnet "ignite-snet-app-internet"
Grant "reader" and "network contributor" to xxx-aks-cluster-re1 resources (object id: 3448bfd3-5774-4682-a10a-cab46df1e337) to vnet "ignite-snet-app-internet"

Also grant <thiamsoontan@microsoft.com> network contributor / reader

ERROR:
```
ront-75cffbb898 to 1
5m53s       Normal    EnsuringLoadBalancer     service/azure-vote-front                 Ensuring load balancer
5m53s       Warning   SyncLoadBalancerFailed   service/azure-vote-front                 Error syncing load balancer: failed to ensure load balancer: Retriable: false, RetryAfter: 0s, HTTPStatusCode: 403, RawError: {"error":{"code":"AuthorizationFailed","message":"The client '17011431-4e12-491a-9994-334fcf6a005d' with object id '17011431-4e12-491a-9994-334fcf6a005d' does not have authorization to perform action 'Microsoft.Network/virtualNetworks/subnets/read' over scope '/subscriptions/0b5b13b8-0ad7-4552-936f-8fae87e0633f/resourceGroups/gcci-platform/providers/Microsoft.Network/virtualNetworks/gcci-vnet-project/subnets/SystemNodePoolSubnet' or the scope is invalid. If access was recently granted, please refresh your credentials."}}
```

Reference: https://learn.microsoft.com/en-us/answers/questions/720289/i-am-unable-to-spin-up-internal-load-balancers-in
# Note the load balancer will take about 2 minutes to create.


# deploy the container into aks
kubectl apply -f azure-vote.yaml

# remove the container into aks
kubectl delete -f azure-vote.yaml

Issue:
1. Ensure age port 80 is the listener (private) if http or 443 is using private listener if https

# other kubectl commands
kubectl get pods
kubectl get services
kubectl get events

# test the azure vote application

e.g.

# get pods
➜  caf kubectl get pods  
NAME                               READY   STATUS    RESTARTS   AGE
azure-vote-back-65c595548d-dz9cf   1/1     Running   0          3m56s
azure-vote-front-d99b7676c-phwk8   1/1     Running   0          3m56s

# get services to find the internal load balancer external-ip
➜  caf kubectl get services
NAME               TYPE           CLUSTER-IP   EXTERNAL-IP     PORT(S)        AGE
azure-vote-back    ClusterIP      8.0.179.57   <none>          6379/TCP       4m34s
azure-vote-front   LoadBalancer   8.0.43.64    100.73.133.10   80:31015/TCP   4m34s
kubernetes         ClusterIP      8.0.0.1      <none>          443/TCP        3h5m

# curl http url to perform smoke testing
➜  caf curl http://100.73.133.10/


# sql commands

sqlcmd -S <server_name> -U <username> -P <password>

CREATE DATABASE <database_name>;

USE <database_name>;

Create Table: The general syntax for creating a table is:

CREATE TABLE table_name (column1 datatype, column2 datatype, ...);
For example, to create a table named Students, enter the following command:

CREATE TABLE Students (StudentId int, StudentName nvarchar(50), StudentAge int);




openssl genrsa -out app01-uat.dso.gov.sg key 2048 

openssl pkcs12 -export -out certificate.pfx -inkey privateKey.key -in certificate.crt -certfile CACert.crt

openssl pkcs12 -export -out domain.pfx -inkey domain.key -in domain.crt


# step to create a self sign certificate - domain.pfx
---------------------------------------------------------------------------------------
➜  caf openssl genrsa -des3 -out domain.key 2048
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
➜  caf openssl req -key domain.key -new -out domain.csr
Enter pass phrase for domain.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:SG
State or Province Name (full name) [Some-State]:
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:
Email Address []:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:!qaz@wsx@1234567890
An optional company name []:GRA
➜  caf openssl req -key domain.key -new -x509 -days 365 -out domain.crt
Enter pass phrase for domain.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:SG
State or Province Name (full name) [Some-State]:SG
Locality Name (eg, city) []:SG
Organization Name (eg, company) [Internet Widgits Pty Ltd]:GRA
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:moris-uat.gra.gov.sg
Email Address []:kianpoh@gra.gov.sg
➜  caf openssl pkcs12 -export -out domain.pfx -inkey domain.key -in domain.crt
Enter pass phrase for domain.key:
Enter Export Password:
Verifying - Enter Export Password:
 
# --------------------------------------------------------------------------------

  "state": "Enabled",
  "tenantId": "ac20add1-ffda-45c1-adc5-16a0db15810f",
  "user": {
    "name": "thiamsoontan@microsoft.com",
    "type": "user"
  }
}
➜  avm az aks get-credentials --resource-group aoaiuat-rg-solution-accelerators-aks --name aks-aoaiuat-aks-ran

Merged "aks-aoaiuat-aks-ran" as current context in /home/vscode/.kube/config
➜  avm 
➜  avm export KUBECONFIG=/home/vscode/.kube/config
➜  avm echo KUBECONFIG
KUBECONFIG
➜  avm echo $KUBECONFIG
/home/vscode/.kube/config
➜  avm kubelogin convert-kubeconfig
➜  avm kubectl get pods
To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code NA4B648LY to authenticate.
E0908 04:09:02.906901    1393 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"https://aoaiuat-aks-ran-a5d7hpzl.ad51ac48-2800-4990-979d-ecc6483d37a7.privatelink.southeastasia.azmk8s.io:443/api?timeout=32s\": context deadline exceeded (Client.Timeout exceeded while awaiting headers)"
Error from server (Forbidden): pods is forbidden: User "92bc292e-07bb-4244-93b7-1be32277aaff" cannot list resource "pods" in API group "" in the namespace "default"
➜  avm kubectl get pods
Error from server (Forbidden): pods is forbidden: User "92bc292e-07bb-4244-93b7-1be32277aaff" cannot list resource "pods" in API group "" in the namespace "default"
➜  avm kubectl get pods            
Error from server (Forbidden): pods is forbidden: User "92bc292e-07bb-4244-93b7-1be32277aaff" cannot list resource "pods" in API group "" in the namespace "default"
➜  avm az aks get-credentials --resource-group aoaiuat-rg-solution-accelerators-aks --name aks-aoaiuat-aks-ran  --admin
Merged "aks-aoaiuat-aks-ran-admin" as current context in /home/vscode/.kube/config
➜  avm kubectl get pods
No resources found in default namespace.
➜  avm kubectl create namespace internet_app
The Namespace "internet_app" is invalid: metadata.name: Invalid value: "internet_app": a lowercase RFC 1123 label must consist of lower case alphanumeric characters or '-', and must start and end with an alphanumeric character (e.g. 'my-name',  or '123-abc', regex used for validation is '[a-z0-9]([-a-z0-9]*[a-z0-9])?')
➜  avm kubectl create namespace internet
namespace/internet created
➜  avm kubectl create namespace intranet
namespace/intranet created
➜  avm kubectl apply -f azure-vote.yaml
deployment.apps/azure-vote-back created
service/azure-vote-back created
deployment.apps/azure-vote-front created
service/azure-vote-front created
➜  avm kubectl get pods                     
NAME                                READY   STATUS    RESTARTS   AGE
azure-vote-back-596854597-qw7mx     1/1     Running   0          15s
azure-vote-front-75cffbb898-cvkjn   1/1     Running   0          15s
# --------------------------------------------------------------------------------