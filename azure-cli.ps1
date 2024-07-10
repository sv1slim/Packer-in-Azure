# Install Azure CLI on Windows https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli
# Install Packer https://www.packer.io/downloads

# Logint to Azure and set your default subscribtion
az login
az account show --output table
az account set --subscription "Visual Studio Enterprise Subscription"

# Create a resource group 
az group create -n myPackerResourceGroup -l eastus 
az group list --output table

# Create a service principal and paste the IDs into ubuntu.json file 
az ad sp create-for-rbac --role Contributor --scopes /subscriptions/f7806be4-19fa-45cf-b6e7-636c8ebd49d9 --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"

az role assignment list --subscription "f7806be4-19fa-45cf-b6e7-636c8ebd49d9" --assignee "c65add7d-b105-463f-bc42-d9a7fa0ff660"

# Obtain your Azure subscription ID
az account show --query "{ subscription_id: id }"

# Build the image (modify client_id, client_secret, tenant_id)
packer build ubuntu.json

# Create VM from Azure Image
az vm create --resource-group myResourceGroup --name myVM --image myPackerImage --admin-username azureuser --generate-ssh-keys

# Open port 80
az vm open-port --resource-group myResourceGroup --name myVM --port 80
