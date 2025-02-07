
### **Version 0.0.13 (TBD)**
#### **Compatibility:**
- **AAF AVM SDE:** `gccstarterkit/gccstarterkit-avm-sde:0.2`
- **Azurerm:** Version 3.85
- **AAF:** Version 0.0.5

#### **New Features:**
- *No features added in this release.*

#### **Enhancements:**
- *No Enhancements added in this release.*

#### **Bug Fixes:**
- fixed issue with long window name
- set lower case for resource group for vm

---

### **Version 0.0.12 (TBD)**
#### **Compatibility:**
- **AAF AVM SDE:** `gccstarterkit/gccstarterkit-avm-sde:0.2`
- **Azurerm:** Version 3.85
- **AAF:** Version 0.0.5

#### **New Features:**
- *No features added in this release.*

#### **Enhancements:**
- *No Enhancements added in this release.*

#### **Bug Fixes:**
- *No Bug Fixes added in this release.*

---

### **Version 0.0.11 (06 Feb 2025)**
#### **Compatibility:**
- **AAF AVM SDE:** `gccstarterkit/gccstarterkit-avm-sde:0.2`
- **Azurerm:** Version 3.85
- **AAF:** Version 0.0.5

#### **New Features:**
- *No features added in this release.*

#### **Enhancements:**
- Updated Redis Cache creation using AVM
- Updated AGW creation using AVM
- Updated ACR creation using AVM 
- Updated Container Instance creation using AVM 

#### **Bug Fixes:**
- *No Bug Fixes added in this release.*

---

### **Version 0.0.10 (24 Oct 2024)**
#### **Compatibility:**
- **AAF AVM SDE:** `gccstarterkit/gccstarterkit-avm-sde:0.2`
- **Azurerm:** Version 3.85
- **AAF:** Version 0.0.5

#### **New Features:**
- Added Solution Accelerator IoT Hub.
- Added Solution Accelerator Event Hubs.
- Added Solution Accelerator Data Explorer.
- Added Solution Accelerator Stream Analytics.
- Added Solution Accelerator Azure Frontdoor.

#### **Enhancements:**
- *No Enhancements added in this release.*

#### **Bug Fixes:**
- *No Bug Fixes added in this release.*

---

### **Version 0.0.9 (09 Sep 2024)**
#### **Compatibility:**
- **AAF AVM SDE:** `gccstarterkit/gccstarterkit-avm-sde:0.2`
- **Azurerm:** Version 3.85
- **AAF:** Version 0.0.5

#### **New Features:**
- *No features added in this release.*

#### **Enhancements:**  
- *No Enhancements added in this release.*

#### **Bug Fixes:**
- Resolved an issue with diagnostic settings on storage accounts to prevent changes upon redeployment.
- Resolved an issue with subnets missing in ingress/egress infra landing zone
- Resolved an issue with key is NoneType when generating NSG config
- Resolved an issue with natgateway unable to find subnets.id in infra landing zone
- Resolved an issue with the diagnostic setting of internet ingress nsg
- Resolved an issue with the subnets not to assign nsg to azurefirewallsubnet

---

### **Version 0.0.8 (July 22, 2024)**
#### **Compatibility:**
- **AAF AVM SDE:** `gccstarterkit/gccstarterkit-avm-sde:0.1`
- **Azurerm:** Version 3.85
- **AAF:** Version 0.0.5

#### **New Features:**
- *No features added in this release.*

#### **Enhancements:**
- Standardized the configuration by moving the `config.yaml` file into the `scripts` folder.

#### **Bug Fixes:**
- Fixed deployment issues with Cosmos DB Mongo.
- Resolved private endpoint issues for App Service APIs.

---

### **Version 0.0.7 (July 19, 2024)**
#### **Compatibility:**
- **AAF AVM SDE:** `gccstarterkit/gccstarterkit-avm-sde:0.1`
- **Azurerm:** Version 3.85
- **AAF:** Version 0.0.5

#### **New Features:**
- *No features added in this release.*

#### **Enhancements:**
- Refactored the network security group (NSG) code for improved maintainability.

#### **Bug Fixes:**
- Addressed an issue where `sed` was unable to flush to disk fast enough during script execution.

---

### **Version 0.0.6 (July 17, 2024)**
#### **Compatibility:**
- **AAF AVM SDE:** `gccstarterkit/gccstarterkit-avm-sde:0.1`
- **Azurerm:** Version 3.85
- **AAF:** Version 0.0.5

#### **New Features:**
- Added logging and backup functionalities for Solution Accelerator App Service.

#### **Enhancements:**
- Updated subnet creation to utilize AVM’s `Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet`.

#### **Bug Fixes:**
- Fixed deployment errors for Cosmos DB Mongo and Cosmos DB SQL.

---

### **Version 0.0.5 (July 10, 2024)**
#### **Compatibility:**
- **AAF AVM SDE:** `gccstarterkit/gccstarterkit-avm-sde:0.1`
- **Azurerm:** Version 3.85
- **AAF:** Version 0.0.4

#### **New Features:**
- Added a launchpad for non-GCC environments, including virtual network creation.
- Introduced Logic App Solution Accelerators.

#### **Enhancements:**
- Removed modules from the starter kit; all non-AVM modules now exist within AAF.
- Enabled the ability to set the `source_image_resource_id` for VM Solution Accelerators.
- Updated the GCC Dev environment to accept variables via `-var` in Terraform plan/apply.
- Renamed `script_launchpad` to `script`.
- Upgraded AVM virtual networks to version 0.2.3.
- Upgraded AVM private DNS zones to version 0.1.2.

#### **Bug Fixes:**
- Fixed KeyVault `resource_id` error for Management VM.

---

### **Version 0.0.4 (June 20, 2024)**
#### **Compatibility:**
- **AAF AVM SDE:** `gccstarterkit/gccstarterkit-avm-sde:0.1`
- **Azurerm:** Version 3.85
- **AAF:** Version 0.0.3

#### **New Features:**
- Added support for intranet egress firewall, ingress AGW, and ingress firewall.

#### **Enhancements:**
- Added global setting tags to all Solution Accelerators and the `0-setup_gcc_dev_env`.
- Set custom module source to `AcceleratorFramew0rk/aaf/azurerm//modules/...`.
- Removed hardcoded virtual network names during the import of Terraform state in the launchpad.
- Removed unused template folders to avoid code duplication.

#### **Bug Fixes:**
- Verified APIM environment to ensure it is set to either Non-Production [Developer1] or Production [Premium] SKU.
- Corrected diagnostics settings for the hub intranet egress Public IP.
- Fixed duplicate `resource_group_name` variable in ingress firewall configurations.

---

### **Version 0.0.3 (June 13, 2024)**
#### **Compatibility:**
- **AAF AVM SDE:** `gccstarterkit/gccstarterkit-avm-sde:0.1`
- **Azurerm:** Version 3.85
- **AAF:** Version 0.0.1

#### **New Features:**
- Enabled standalone deployment for each Solution Accelerator, eliminating dependencies on the `import.sh` script and landing zones.

#### **Enhancements:**
- Updated AVM Bastion Host module to version 0.2.0.
- Added diagnostic settings for the Bastion Host and DevOps Container Instance.
- Introduced standalone deployment for the MSSQL Solution Accelerator.
- Added diagnostic settings for APIM, Search Service, Service Bus, and Storage Account.

#### **Bug Fixes:**
- Fixed NSG configurations for Application Gateway.

---

### **Version 0.0.2 (May 29, 2024)**
#### **Compatibility:**
- **AAF AVM SDE:** `gccstarterkit/gccstarterkit-avm-sde:0.1`
- **Azurerm:** Version 3.85
- **AAF:** Version 0.0.1

#### **New Features:**
- Added modules:
  - API Management
- Introduced Solution Accelerators for:
  - API Management (APIM)

#### **Enhancements:**
- Updated `framework.landingzone` source to `AcceleratorFramew0rk/aaf/azurerm` version 0.0.1.
- Upgraded AVM Virtual Network to version 0.1.4.
- Upgraded AVM Network Security Group to version 0.2.0.
- Converted the GCC Dev environment to use `config.yaml` for VNet name and CIDR settings.
- Added diagnostic settings for the Network Security Group for Application/Platform Landing Zone.

#### **Bug Fixes:**
- Fixed invalid attributes in the Network Security Group output for `resource` and `security_rules`.

---

### **Version 0.0.1 (May 23, 2024)**
#### **Compatibility:**
- **AAF AVM SDE:** `gccstarterkit/gccstarterkit-avm-sde:0.1`
- **Azurerm:** Version 3.85
- **AAF:** Version 0.0.1

#### **New Features:**
- Imported GCCI Terraform state.
- Added Platform Common Service and Application Landing Zones.
- Introduced Solution Accelerators for:
  - AKS
  - SQL Server
  - Container Registry
  - App Service
  - Key Vault
  - Bastion Host
  - VM
  - Container Instance

#### **Enhancements:**
- *No enhancements in this release.*

#### **Bug Fixes:**
- *No bug fixes in this release.*

