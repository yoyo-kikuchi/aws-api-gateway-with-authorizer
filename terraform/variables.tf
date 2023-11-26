variable "profile" {
  type = string
}

variable "db_host" {
  type = string
}

variable "db_pass" {
  type = string
}

variable "db_port" {
  type    = string
  default = "5432"
}

variable "db_schema" {
  type = string
}

variable "db_user" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "domain_name" {
  type        = string
  description = "FQDN"
}

variable "jwt_secret" {
  type = string
}
