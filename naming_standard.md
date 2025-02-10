### "Naming Standard"

https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming

Establishing a consistent naming convention for Azure resources is essential for efficient resource management, governance, and operational clarity. A well-structured naming convention enables teams to quickly identify the purpose, ownership, and scope of a resource while maintaining uniformity across an organization's Azure environment.

## **Key Elements of a Naming Convention**
A resource name should be **descriptive**, **consistent**, and **easily identifiable**. The following structure is a recommended approach for naming Azure resources:

```
[resource-type]-[workload, application, or project]-[environment]-[location]-[custom string]
```

Each component of the naming convention provides meaningful context:

1. **Resource Type** – A short identifier (often an abbreviation) representing the Azure resource type.
   - Example: `vm` for Virtual Machine, `pip` for Public IP, `sql` for SQL Database, `st` for Storage Account.
   
2. **Workload, Application, or Project** – Identifies the specific application, workload, or project to which the resource belongs.
   - Example: `crm`, `sap`, `erp`, `website`, `datahub`.

3. **Environment** – Specifies the lifecycle stage of the resource, ensuring clear separation between environments.
   - Common values:  
     - `dev` (Development)  
     - `test` (Testing)  
     - `stg` (Staging)  
     - `prod` (Production)  

4. **Location** – Represents the Azure region where the resource is deployed.
   - Example: `southeastasia` 

5. **Custom String (Optional)** – An additional identifier, such as an incrementing number, department code, or unique business identifier.
   - Example: `001`, `finance`, `hr`, `xyz`.

## **Example Naming Conventions**
Following the structure above, here are examples for different Azure resources:

- **Virtual Machine (VM) for an ERP system in production (Southeast Asia)**  
  ```
  vm-erp-prod-southeastasia-001
  ```

- **Public IP (PIP) for a SharePoint workload in production (Southeast Asia)**  
  ```
  pip-sharepoint-prod-southeastasia-001
  ```

- **SQL Database for a finance application in development (Southeast Asia)**  
  ```
  sql-finance-dev-southeastasia
  ```

- **Storage Account for a data lake in staging (Southeast Asia)**  
  ```
  st-datalake-stg-southeastasia
  ```

## **Applying Naming Conventions in Azure Acceleration Framework (AAF)**
In the **Azure Acceleration Framework (AAF)**, naming conventions can be further standardized using **prefixes** or **suffixes**. These approaches help in identifying workloads and environments while maintaining flexibility.

- **Using a Suffix-Based Naming Convention:**
   - setup **config.yaml** file as follow:
     - prefix: "abc-prod-sea"
     - is_prefix: true
  ```
  [resource-type]-[workload, application, or project]-[environment]-[location]
  ```
  Example: set "[workload, application, or project]-[environment]" as suffix e.g. "abc-dev-sea"
  ```
  vm-abc-dev-sea-001
  ```
  
- **Using Prefix Based Naming Convention:**  
   - setup **config.yaml** file as follow:
     - prefix: "crm-prod-southeastasia"
     - is_prefix: false
  ```
  [workload, application, or project]-[environment]-[location]-[resource-type]-[custom string]
  ```
  Example: set "[workload, application, or project]-[environment]" as suffix e.g. "abc-prod-sea".
  ```
  abc-prod-sea-vm-001
  ```

### **Considerations for Naming Conventions**
1. **Character Limits:**  
   - Different Azure resources have specific naming restrictions (e.g., Storage Accounts allow only lowercase letters and numbers, while VMs can include hyphens).
   
2. **Uniqueness:**  
   - Some Azure resources, such as Storage Accounts and Public IPs, require globally unique names.

3. **Readability and Consistency:**  
   - Avoid overly complex or cryptic names.
   - Use standard abbreviations consistently across resources.

4. **Tagging for Additional Metadata:**  
   - Naming conventions help identify resources, but Azure **tags** can provide additional metadata such as cost center, owner, or compliance classification.

By following these best practices, organizations can ensure their Azure resources are easily identifiable, maintainable, and aligned with governance policies.
