provider "azurerm"{
    features{}
}

resource "azurerm_resource_group" "rg" {

    name = "rg-giftjoy-dev"
    location = "East US 2"

    tags = {
        environment = "dev"
        project = "giftjoy"
        creatred_by = "Terraform"
    }

}