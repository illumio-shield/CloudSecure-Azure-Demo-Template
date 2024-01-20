# Cloud Microsegmentation Demo Simulation

Welcome to the Microsegmentation Demo Simulation App! This project is designed to highlight the power of Illumio's Cloudsecure by demonstrating its ability to secure and microsegment a vulnerable application environment effectively.

## Overview

The primary goal of this project is to demonstrate how Illumio Cloudsecure can be leveraged to implement microsegmentation within a complex cloud environment.

Microsegmentation is a critical aspect of modern network security, and Illumio provides robust solutions for Microsegmentation. This demo simulation serves as a realistic, intentionally vulnerable application that users can use alongside Illumio Cloudsecure to witness firsthand how microsegmentation enhances security.

To run this Azure Bicep template:

1. Open an Azure Cloud Shell window in Azure portal, or your local system if you have it installed. Commands for both PowerShell and Bash (Azure CLI) are listed below.
2. Create a Resource Group you'd like to launch this template from ('trial' in this example), and assign it a region of your choice.

PowerShell:

		New-AzResourceGroup -Name trial -Location eastus2

Azure CLI:

		az group create --name trial --location eastus2

3. Use the "Upload" button to transfer the Bicep template to your CloudShell window. Launch the Bicep template using the command below. Give it a deployment name ('deploy1' in this example), reference the Resource Group just created, and the template.

PowerShell:

		New-AzResourceGroupDeployment -Name deploy1 -ResourceGroupName trial -TemplateFile CloudSecure.bicep

Azure CLI:

		az deployment group create --name deploy1 --resource-group trial --template-file CloudSecure.bicep

4. You will be prompted for a username and password for the virtual machines. (Azure will require a mix of upper/lower/numbers/chars)
5. Wait a few minutes. You can follow the progress of the deploymet from the Azure portal by going to 'Deployments' tab of the Resource Group. You will see it progress through creating NSG's, NIC's, virtual networks, virtual machines, and lastly the 'Run' commands for linux scripting on each host.
6. The Bicep template includes a "CustomData" field which is a base64 encoded string that includes a set of bash scripts that load cronjob entries to simulate some basic traffic flows. This can be edited to your needs.

7. In order for CloudSecure to capture traffic flow logs, you will need to enable NSG flow logs on these VM's and send logs to a storage account of your choice. Standard general purpose V2 storage is fine. In order to create NSG flow logs:
   - Click on any one of the Virtual Machines just created.
   - Click on Networking from the left panel
   - Click on the name of the Network Security Group (located somewhat in the center of the screen)
   - Click on NSG Flow Logs from the left panel
   - Click on the "+ Create" button
   - Click on the "+ Select Resource" button. You'll be able to enable flow logs for all your VMs at once by selecting each VM on this screen.
   - Once all selected, then click on "Create New Storage Account" if you want to create a new storage site for these flow. Otherwise, select existing.
   - Give the storage a name, and select the "Account kind" option of StorageV2. Click OK
   - Click Review + Create to complete this process.
9. When you are done using this environment, simply delete the Resource Group. All associated resources that were generated will be removed:

PowerShell:

		Remove-AzResourceGroup -Name trial

Azure CLI:

		az group delete --name trial --yes --no-wait


In our scenario, we have defined 3 environments (prod, dev, and staging) in a single virtual network using 3 subnets. Within each subnet we have created 3-tier applications using Virtual Machines. Some of the VM's have been loaded with a few cron job entries to generate simple traffic flows.

![image](https://github.com/stauffer-jeff/CloudSecure-Azure-Demo-Template/assets/155683658/49549934-9798-4d3d-9eff-1801449c39f2)

