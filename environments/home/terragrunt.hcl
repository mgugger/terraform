remote_state {
    backend = "azurerm"
    config = {
        key = "${path_relative_to_include()}/terraform.tfstate"
        resource_group_name = "terraform"
        storage_account_name = "mdghometf"
        container_name = "tfstate"
    }
}

inputs = {
  location = "switzerlandnorth"
  connectivity_resource_group_name = "tf-connectivity"
  storage_resource_group_name = "tf-storage"
  vms_resource_group_name = "tf-vms"
  customimages_resource_group_name = "tf-vmimages"
  vm_snapshot_resource_id = "/subscriptions/9cd44e3c-5f40-4eea-95f7-bb551bac9cdd/resourceGroups/tf-vmimages/providers/Microsoft.Compute/snapshots/archlinux_gen1_snapshot"
}