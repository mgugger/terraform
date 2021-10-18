resource "azurerm_resource_group" "tf-aks" {
  name     = var.aks_resource_group_name
  location = var.location
  tags = {
    environment = "work"
  }
}

resource "azurerm_log_analytics_workspace" "log-aks-main" {
  name                = "log-aks-main"
  location            = var.location
  resource_group_name = var.aks_resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_kubernetes_cluster" "aks" {
    name                = "aks-main"
    location            = azurerm_resource_group.tf-aks.location
    resource_group_name = azurerm_resource_group.tf-aks.name
    dns_prefix          = "aks-main"
    automatic_channel_upgrade = "rapid"
    private_cluster_enabled = true
    private_cluster_public_fqdn_enabled = true
    private_dns_zone_id = "System"
    sku_tier = "Free"

    network_profile {
        network_policy      = "calico"
        network_plugin = "kubenet"
        load_balancer_sku = "Standard"
        service_cidr = "10.244.0.0/17"
        pod_cidr = "10.244.128.0/17"
        docker_bridge_cidr = "172.17.0.1/16"
        dns_service_ip = "10.244.0.10"
    }

    linux_profile {
        admin_username = var.vm_username
        ssh_key {
            key_data = file("~/.ssh/id_rsa.pub")
        }
    }

    default_node_pool {
        name            = "agentpool"
        node_count      = 1
        vm_size         = "Standard_D2_v2"
        vnet_subnet_id      = azurerm_subnet.aks.id
    }

    identity {
        type = "SystemAssigned"
    }

    addon_profile {
        oms_agent {
            enabled                    = true
            log_analytics_workspace_id = azurerm_log_analytics_workspace.log-aks-main.id
        }

        aci_connector_linux {
            enabled = false
        }

        azure_policy {
            enabled = true
        }

        http_application_routing {
            enabled = false
        }

        ingress_application_gateway {
            enabled                              = false
        }

        kube_dashboard {
            enabled = false
        }
    }

    tags = {
        Environment = "work"
    }
}
