# WinRm Infrastructure
Deploy whole infrastructure for IIS Web App Deployment Using WinRM extension in one click.
<img width="713" alt="image" src="https://github.com/LeftTwixWand/winrm-infrastructure/assets/50652041/58884e54-684c-4406-965c-cbf4614e065c">

## Prerequisites
1) Create a new app registration on Azure to be able to authenticate from [Azure/login](https://github.com/Azure/login) task.
2) Add federated credentials as a way of authentication. It's also possible to use client secrets, but WIF is recommended approach.
3) Add `AZURE_CLIENT_ID`, `AZURE_SUBSCRIPTION_ID`, `AZURE_TENANT_ID` to repository secrets.
4) Generated a new Azure DevOps PAT with build permissions and add it to repository secrets with this key: `AZURE_DEVOPS_PAT`
5) Add you Azure DevOps organization URL to secrets with this key: `AZURE_DEVOPS_ORG`
6) Create a new self-hosted agent pool in your Azure DevOps organization and name it **Self-Hosted**
7) Now you're ready to start the **Deploy Infrastructure** pipeline.

In the end your repository secrets should look like this:

<img width="585" alt="image" src="https://github.com/LeftTwixWand/winrm-infrastructure/assets/50652041/dcd4a681-b3de-49b1-80f8-981d867f692d">

| Secret name | Description |
|----------|:-------------:|
| AZURE_CLIENT_ID | Application (client) ID from Azure App registration. |
| AZURE_DEVOPS_ORG | Link to your Azure DevOps organization in this format: https://dev.azure.com/MyOrganizationName |
| AZURE_DEVOPS_PAT | Azure DevOps PAT token with Build permissions. Needs to register the build agent. |
| AZURE_SUBSCRIPTION_ID | Your Azure subscription ID. |
| AZURE_TENANT_ID | Directory (tenant) ID from Azure App registration. |
