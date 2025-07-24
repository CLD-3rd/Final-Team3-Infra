variable "name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "force_delete" {
  description = "If true, will delete the repository even if it contains images"
  type        = bool
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
}

variable "tags" {
  description = "A map of tags to assign to the repository"
  type        = map(string)
}

variable "image_tag_mutability" {
  description = "Whether image tags are mutable or immutable"
  type        = string
}

variable "encryption_type" {
  description = "Encryption type for ECR"
  type        = string
}