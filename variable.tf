variable "cluster_name" {
    type = string
  
}

variable "cidr_block" {

    type = string
  
}
variable "public_subnets" {
    type = list(string)
  
}
variable "private_subnets" {
    type = list(string)
  
}
variable "sql-pwd" {
    type = string
}

