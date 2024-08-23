provider "azurerm"{
    features{}
}

resource "azurerm_resource_group" "rg" {

    name = "rg-${var.project}-${var.environment}"
    location = var.location

    tags = {
        environment = var.environment
        project = var.project
        creatred_by = "Terraform"
    }

}