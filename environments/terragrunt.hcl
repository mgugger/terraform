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
  tenant_id = "a5f516d3-a4e5-414a-8463-9e78921e4769"
  location = "northeurope"
  connectivity_resource_group_name = "tf-sandbox"
  storage_resource_group_name = "tf-storage"
  arc_resource_group_name = "tf-arc"
  vpn_root_cert = "MIIC5jCCAc6gAwIBAgIIIzLyH5DesMMwDQYJKoZIhvcNAQELBQAwETEPMA0GA1UEAxMGVlBOIENBMB4XDTIxMDkwOTEyNDkwMFoXDTI0MDkwODEyNDkwMFowETEPMA0GA1UEAxMGVlBOIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1ooyO3OCYOkAoEJ2o7LVdExnKS5rXADWa8PaH8lHvfUXE+X1bu/qhKfeJT4ThV0+CY4LqhwynlpwP+GgdBcDEmVbrw/rbHZEcoxgA1kSnOOwKxxAx2zW3IZqr6byS7QHTd0bluBncg17sW44BnmghJhYaSGtSRW1Wms2CHZ88RnLqYwvBS23NV2Coaupbpp0jmzqC/QXZ+otlaaXFB8msopZHn32306nFEQIDFZGvL+bbOGMl5VpFlejwSfvyVWhePHUZ0hqhKZuYT3JORUghhgmV2lbiXWdmNzxLhQbK2fNDCEYB0TllIc1ig4E9jibCNs50RB95VVO17B02zwDDQIDAQABo0IwQDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUKdM/6NPvW+AKq1/2HnA9yiS+nQQwDQYJKoZIhvcNAQELBQADggEBAM1qA/p1eVwhq4gPRQcs4LOvhwy3tWte/ZP1gytlslopU1xbspgiqGFHXG2dibZjQxr5+KvV/j5cYE9d4bp5n3JrD+kqOH5Qu8RXX68W12XtYgbrXUVN6UWWTcMgya4uVUtw2eg4r5ZOiMADx4Rtuq2FCAlLe2TEWrUzaS4ppq4k2jS3M9umaWsUGoFPxaoHxlLaPz7qkqhiwH/JABZ2ygz/AUojsQ2YJNoaJgxOVlmffeQvDH2OKhb8jOJ8UdxEctlXBO8AzkA078Y6OWOGqx7NyteGno2oRfoBQpfIllB0BUi3V+Ojin6nq0pnzoUP43w6j/o/DqXyQ45oeSybZeA="
}