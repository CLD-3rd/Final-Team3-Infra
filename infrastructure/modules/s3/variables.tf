variable "bucket_name" {
  description = "Globally unique name of the S3 bucket"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = false
}

variable "enable_website" {
  description = "Enable static website hosting for the S3 bucket"
  type        = bool
  default     = false
}

variable "index_document" {
  description = "Index document filename for static website hosting"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Error document filename for static website hosting"
  type        = string
  default     = "error.html"
}

variable "block_public_acls" {
  description = "Block public ACLs on this bucket"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block public bucket policies on this bucket"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignore any public ACLs on this bucket"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restrict public access to this bucket"
  type        = bool
  default     = true
}

variable "bucket_policy" {
  description = "Optional JSON object representing the bucket access policy"
  type        = any
  default     = null
}

variable "tags" {
  description = "A map of tags to apply to the S3 bucket"
  type        = map(string)
  default     = {}
}

