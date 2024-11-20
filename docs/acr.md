
# ACR Setup - Deployment Overview

This repository provides the configuration and infrastructure for an Azure Container Registry with a set of enterprise-grade features aimed at ensuring high availability, security, and scalability. This setup integrates with Microsoft Entra ID for authentication and authorization and supports both internet and intranet workloads with isolated networking configurations.

✅
☑️
---

## **Architecture Overview**

---

## ACR Key Features

1. **Enable Microsoft Defender for Cloud**: Ensure that Microsoft Defender for Cloud is enabled for your Azure subscription. This provides threat detection and security alerts for container registries, helping you to identify and mitigate potential security risks[1](https://microsoft.sharepoint.com/teams/AzureTenantBaseline2/SitePages/Enable%20all%20Azure%20Defender%20plans%20in%20Microsoft%20Defender%20for%20Cloud.aspx?web=1).

2. **Implement Role-Based Access Control (RBAC)**: Use RBAC to manage access to your container registry. Assign roles to users and groups based on the principle of least privilege, ensuring that users only have the permissions they need to perform their tasks[2](https://microsoft.sharepoint.com/teams/CAFServicesAlignment/_layouts/15/Doc.aspx?sourcedoc=%7B0AC22B9A-BEEB-4F02-B1CA-4DA7F9562E7E%7D&file=FY20%20Cloud%20Adoption%20Framework%20and%20Service%20Offers%20v2.0.pptx&action=edit&mobileredirect=true&DefaultItemOpen=1).

3. **Use Private Endpoints**: Configure private endpoints for your container registry to limit network exposure. This ensures that the registry is only accessible from within your virtual network, reducing the risk of unauthorized access[2](https://microsoft.sharepoint.com/teams/CAFServicesAlignment/_layouts/15/Doc.aspx?sourcedoc=%7B0AC22B9A-BEEB-4F02-B1CA-4DA7F9562E7E%7D&file=FY20%20Cloud%20Adoption%20Framework%20and%20Service%20Offers%20v2.0.pptx&action=edit&mobileredirect=true&DefaultItemOpen=1).

4. **Enable Content Trust**: Use content trust to ensure the integrity of your container images. This feature allows you to verify the publisher of an image and ensure that the image has not been tampered with[2](https://microsoft.sharepoint.com/teams/CAFServicesAlignment/_layouts/15/Doc.aspx?sourcedoc=%7B0AC22B9A-BEEB-4F02-B1CA-4DA7F9562E7E%7D&file=FY20%20Cloud%20Adoption%20Framework%20and%20Service%20Offers%20v2.0.pptx&action=edit&mobileredirect=true&DefaultItemOpen=1).

5. **Regularly Scan Images for Vulnerabilities**: Use tools like Microsoft Defender for Cloud to regularly scan your container images for vulnerabilities. This helps you to identify and remediate security issues before they can be exploited[1](https://microsoft.sharepoint.com/teams/AzureTenantBaseline2/SitePages/Enable%20all%20Azure%20Defender%20plans%20in%20Microsoft%20Defender%20for%20Cloud.aspx?web=1).

6. **Implement Network Security Groups (NSGs)**: Use NSGs to control inbound and outbound traffic to your container registry. Define rules to allow only the necessary traffic and block any unwanted access[2](https://microsoft.sharepoint.com/teams/CAFServicesAlignment/_layouts/15/Doc.aspx?sourcedoc=%7B0AC22B9A-BEEB-4F02-B1CA-4DA7F9562E7E%7D&file=FY20%20Cloud%20Adoption%20Framework%20and%20Service%20Offers%20v2.0.pptx&action=edit&mobileredirect=true&DefaultItemOpen=1).

7. **Monitor and Log Activity**: Enable logging and monitoring for your container registry to track access and usage. Use Azure Monitor and Azure Security Center to collect and analyze logs, and set up alerts for suspicious activities[2](https://microsoft.sharepoint.com/teams/CAFServicesAlignment/_layouts/15/Doc.aspx?sourcedoc=%7B0AC22B9A-BEEB-4F02-B1CA-4DA7F9562E7E%7D&file=FY20%20Cloud%20Adoption%20Framework%20and%20Service%20Offers%20v2.0.pptx&action=edit&mobileredirect=true&DefaultItemOpen=1).


### **Actionable Checklist for Azure Container Registry (ACR)**

| Area                         | Best Practice                                         | Status  |
|------------------------------|------------------------------------------------------|---------|
| **Governance**               | Naming conventions and centralized management applied | ✅       |
| **Cost Management**          | SKUs optimized and lifecycle policies implemented     | ✅       |
| **Identity and Access Control** | RBAC enforced and managed identities in use        | ✅       |
| **Operational Excellence**   | CI/CD pipelines and geo-replication enabled          | ✅       |
| **Secure Networking**        | Private endpoints and firewall rules configured      | ✅       |
| **Image Security**           | Vulnerability scanning and content trust enabled     | ✅       |
| **Logging and Monitoring**   | Diagnostic logs and alerts integrated                | ✅       |
| **Compliance**               | Encryption and industry-standard compliance ensured  | ✅       |