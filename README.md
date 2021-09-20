# terraform

# Create the required storage account
```
az login
LOCATION=switzerlandnorth
STORAGE_ACCOUNT_NAME=<your storage account name>
SUBSCRIPTION=<your subscription id>

az group create --name terraform --location $LOCATION

az storage account create --name $STORAGE_ACCOUNT_NAME \
  --resource-group terraform \
  --location $LOCATION \
  --sku Standard_LRS \
  --kind StorageV2

az ad signed-in-user show --query objectId -o tsv | az role assignment create \
    --role "Storage Blob Data Contributor" \
    --assignee @- \
    --scope "/subscriptions/$SUBSCRIPTION/resourceGroups/terraform/providers/Microsoft.Storage/storageAccounts/$STORAGE_ACCOUNT_NAME"

az storage container create \
    --account-name $STORAGE_ACCOUNT_NAME \
    --resource-group terraform \
    --name tfstate
```

# Plan & Apply
In the respective environment run:
```
terragrunt init
terragrunt plan
terragrunt apply
```