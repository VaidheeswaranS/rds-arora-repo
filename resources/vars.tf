
variable "password_length" {
    type        = number
    description = "The length of the password"
    default     = 14
}

variable "special_allowed" {
    type        = bool
    description = "Determines if special character are allowed in the password"
    default     = true
}

variable "engine" {
    type        = string
    description = "The name of the database engine to be used for this DB cluster. Valid values: `aurora`, `aurora-mysql`, `aurora-postgresql`"
    default     = ""
}

variable "engine_mode" {
    type        = string
    description = "The database engine mode. Valid values: `parallelquery`, `provisioned`, `serverless`"
    default     = ""
}

variable "cluster_family" {
    type        = string
    description = "The family of the DB cluster parameter group"
    default     = ""
}

variable "cluster_size" {
    type        = number
    description = "Number of DB instances to create in the cluster"
    default     = ""
}

variable "admin_user" {
    type        = string
    description = "(Required unless a snapshot_identifier is provided) Username for the master DB user"
    default     = ""
}

variable "db_name" {
    type        = string
    description = "Database name"
    default     = ""
}

variable "instance_type" {
    type        = string
    description = "Instance type to use"
    default     = ""
}

variable "db_sg_id" {
    type        = list
    description = "The SG id for the DB instance"
    default     = []
}

variable "subnet_ids" {
    type        = list(string)
    description = "List of VPC subnet IDs"
    default     = []
}

variable "deletion_protection" {
    type        = bool
    description = "If the DB instance should have deletion protection enabled"
    default     = false
}