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
  connectivity_resource_group_name = "tf-connectivity"
  storage_resource_group_name = "tf-storage"
  arc_resource_group_name = "tf-arc"
  k3s_resource_group_name = "tf-k3s"
  aks_resource_group_name = "tf-aks"
}