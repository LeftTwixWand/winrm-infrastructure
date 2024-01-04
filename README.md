# WinRm Infrastructure
Deploy whole infrastructure for IIS Web App Deployment Using WinRM extension in one click.
<img width="713" alt="image" src="https://github.com/LeftTwixWand/winrm-infrastructure/assets/50652041/58884e54-684c-4406-965c-cbf4614e065c">

## Prerequisites
1) Create a new app registration on Azure to be able to authenticate from [Azure/login](https://github.com/Azure/login) task.
2) Add the 

| Secret name | Description |
|----------|:-------------:|
| AZURE_CLIENT_ID | Application (client) ID from Azure App registration. |
| AZURE_DEVOPS_ORG | Link to your Azure DevOps organization in this format: https://dev.azure.com/MyOrganizationName |
| AZURE_DEVOPS_PAT | Azure DevOps PAT token with Build permissions. Needs to register the build agent. |
| AZURE_SUBSCRIPTION_ID | Your Azure subscription ID. |
| AZURE_TENANT_ID | Directory (tenant) ID from Azure App registration. |

## Step by step guide


<img width="585" alt="image" src="https://github.com/LeftTwixWand/winrm-infrastructure/assets/50652041/dcd4a681-b3de-49b1-80f8-981d867f692d">
