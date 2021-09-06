remote_state {
    backend = "azurerm"
    config = {
        key = "${path_relative_to_include()}/terraform.tfstate"
        resource_group_name = "terraform"
        storage_account_name = "terraformbucket"
        container_name = "tfstate"
    }
}

inputs = {
  location = "northeurope"
  resource_group_name = "tf-sandbox"
}