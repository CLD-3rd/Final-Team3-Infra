variable "name_prefix" {
}
variable "vpc_id" {
}
variable "public_subnet_id" {
  type = list(string)
}
variable "tags" {
  type = map(string)
}
