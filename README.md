# terraform

# Create the required storage account
```
az login

az group create --name terraform --location north-europe

az storage account create --name terraformbucket \
  --resource-group terraform \
  --location northeurope \
  --sku Standard_LRS \
  --kind StorageV2

az ad signed-in-user show --query objectId -o tsv | az role assignment create \
    --role "Storage Blob Data Contributor" \
    --assignee @- \
    --scope "/subscriptions/<subscription>/resourceGroups/terraform/providers/Microsoft.Storage/storageAccounts/terraformbucket"

az storage container create \
    --account-name terraformbucket \
    --resource-group terraform \
    --name tfstate \
```

# Plan & Apply
In the respective environment run:
```
terragrunt init
terragrunt plan
terragrunt apply
```