# Cloud Microsegmentation Demo Simulation

Welcome to the Microsegmentation Demo Simulation App! This project is designed to highlight the power of Illumio's Cloudsecure by demonstrating its ability to secure and microsegment a vulnerable application environment effectively.

## Overview

The primary goal of this project is to demonstrate how Illumio Cloudsecure can be leveraged to implement microsegmentation within a complex cloud environment.

Microsegmentation is a critical aspect of modern network security, and Illumio provides robust solutions for Microsegmentation. This demo simulation serves as a realistic, intentionally vulnerable application that users can use alongside Illumio Cloudsecure to witness firsthand how microsegmentation enhances security.

## Prerequisites (if you're new to Azure)

You will need to enable “Microsoft Insights” before NSG flow logs can be enabled. You can do this by: 

- Click on your Subscription Name 
- Scroll down on left panel to “Resource Providers” near the bottom 
- There will be an entry called “microsoft.insights”. Click on it then click on the Register button up top. 

If this is your first time using the Azure portal, there are some prerequisites that you’ll need to perform first to utilize Azure Cloud Shell: 

	https://learn.microsoft.com/en-us/azure/cloud-shell/get-started?tabs=azurecli 

NOTE: Part of setting up CLI prompt access is creating storage - make sure you select your own subscription. For some people it's defaulting to the parent level. (i.e. sales vs. se-46)

To run this Azure Bicep template:

1. Open an Azure Cloud Shell window in Azure portal, or your local system if you have it installed. Commands for both PowerShell and Bash (Azure CLI) are listed below.
2. Create a Resource Group you'd like to launch this template from ('trial' in this example), and assign it a region of your choice.

PowerShell:

		New-AzResourceGroup -Name trial -Location eastus2

Azure CLI:

		az group create --name trial --location eastus2

3. Use the "Upload" button to transfer the two Bicep files (main.bicep and flowlogs.bicep) to your CloudShell window. Launch the Bicep template using the command below. Give it a deployment name ('deploy1' in this example), reference the Resource Group just created, and the template.

PowerShell:

		New-AzResourceGroupDeployment -Name deploy1 -ResourceGroupName trial -TemplateFile main.bicep

Azure CLI:

		az deployment group create --name deploy1 --resource-group trial --template-file main.bicep

4. You will be prompted for a username and password for the virtual machines. (Azure will require a mix of upper/lower/numbers/chars. Don't choose something like 'admin' or 'root' or it will fail)
5. Wait a few minutes. You can follow the progress of the deploymet from the Azure portal by going to 'Deployments' tab of the Resource Group. You will see it progress through creating NSG's, NIC's, virtual networks, virtual machines, and lastly the 'Run' commands for linux scripting on each host.
6. The Bicep template includes a "CustomData" field which is a base64 encoded string that includes a set of bash scripts that load cronjob entries to simulate some basic traffic flows. This can be edited to your needs.
7. When you are done using this environment, simply delete the Resource Group. All associated resources that were generated will be removed:

PowerShell:

		Remove-AzResourceGroup -Name trial

Azure CLI:

		az group delete --name trial --yes --no-wait


In our scenario, we have defined 3 environments (prod, dev, and staging) in a single virtual network using 3 subnets. Within each subnet we have created 3-tier applications using Virtual Machines. Some of the VM's have been loaded with a few cron job entries to generate simple traffic flows.

![image](https://github.com/stauffer-jeff/CloudSecure-Azure-Demo-Template/assets/155683658/49549934-9798-4d3d-9eff-1801449c39f2)

