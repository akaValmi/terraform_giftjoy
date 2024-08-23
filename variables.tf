variable project {
  default     = "giftjoy"
  description = "nombre del proyecto"
}

variable environment {
  default     = "dev"
  description = "nombre del ambiente"
}

variable location {
  default     = "East US 2"
  description = "nombre de la region"
}

variable tags {
  default     = {
    environment = "dev"
    project     = "giftjoy"
    creatred_by = "Terraform"
  }
  description = "nombre de los tags"
}

variable password {
  description = "password de la base de datos"
  type = string
  sensitive = true
}