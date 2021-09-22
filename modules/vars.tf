
variable "cluster_size" {
  type        = number
  default     = 2
  description = "Number of DB instances to create in the cluster"
}

variable "cluster_type" {
  type        = string
  description = "Either `regional` or `global`. If `regional` will be created as a normal, standalone DB. If `global`, will be made part of a Global cluster (requires `global_cluster_identifier`)."
  default     = "regional"
}

variable "cluster_identifier" {
    type        = string
    default     = ""
    description = "The RDS Cluster Identifier. Will use generated label ID if not supplied"
}

variable "db_name" {
    type        = string
    default     = ""
    description = "Database name (default is not to create a database)"
}

variable "admin_user" {
    type        = string
    default     = "admin"
    description = "(Required unless a snapshot_identifier is provided) Username for the master DB user"
}

variable "admin_password" {
    type        = string
    default     = ""
    description = "(Required unless a snapshot_identifier is provided) Password for the master DB user"
}

variable "retention_period" {
    type        = number
    default     = 5
    description = "Number of days to retain backups for"
}

variable "backup_window" {
    type        = string
    default     = "07:00-09:00"
    description = "Daily time range during which the backups happen"
}

variable "copy_tags_to_snapshot" {
    type        = bool
    description = "Copy tags to backup snapshots"
    default     = false
}

variable "skip_final_snapshot" {
    type        = bool
    description = "Determines whether a final DB snapshot is created before the DB cluster is deleted"
    default     = true
}

variable "apply_immediately" {
    type        = bool
    description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
    default     = true
}

variable "storage_encrypted" {
    type        = bool
    description = "Specifies whether the DB cluster is encrypted. The default is `false` for `provisioned` `engine_mode` and `true` for `serverless` `engine_mode`"
    default     = false
}

variable "kms_key_arn" {
    type        = string
    description = "The ARN for the KMS encryption key. When specifying `kms_key_arn`, `storage_encrypted` needs to be set to `true`"
    default     = ""
}

variable "source_region" {
    type        = string
    description = "Source Region of primary cluster, needed when using encrypted storage and region replicas"
    default     = ""
}

variable "snapshot_identifier" {
    type        = string
    default     = null
    description = "Specifies whether or not to create this cluster from a snapshot"
}

variable "db_sg_id" {
    type        = list
    description = "The SG id for the DB instance"
    default     = []
}

variable "vpc_security_group_ids" {
    type        = list(string)
    description = "Additional security group IDs to apply to the cluster, in addition to the provisioned default security group with ingress traffic from existing CIDR blocks and existing security groups"
    default = []
}

variable "maintenance_window" {
    type        = string
    default     = "wed:03:00-wed:04:00"
    description = "Weekly time range during which system maintenance can occur, in UTC"
}

variable "iam_database_authentication_enabled" {
    type        = bool
    description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
    default     = false
}

variable "tags" {
    type        = map
    description = "The map of tags that need to be given for the cluster"
    default     = {}
}

variable "engine" {
    type        = string
    default     = "aurora"
    description = "The name of the database engine to be used for this DB cluster. Valid values: `aurora`, `aurora-mysql`, `aurora-postgresql`"
}

variable "engine_version" {
    type        = string
    default     = ""
    description = "The version of the database engine to use. See `aws rds describe-db-engine-versions` "
}

variable "allow_major_version_upgrade" {
    type        = bool
    default     = false
    description = "Enable to allow major engine version upgrades when changing engine versions. Defaults to false."
}

variable "engine_mode" {
    type        = string
    default     = "provisioned"
    description = "The database engine mode. Valid values: `parallelquery`, `provisioned`, `serverless`"
}

variable "iam_roles" {
    type        = list(string)
    description = "Iam roles for the Aurora cluster"
    default     = []
}

variable "backtrack_window" {
    type        = number
    description = "The target backtrack window, in seconds. Only available for aurora engine currently. Must be between 0 and 259200 (72 hours)"
    default     = 0
}

variable "enable_http_endpoint" {
    type        = bool
    description = "Enable HTTP endpoint (data API). Only valid when engine_mode is set to serverless"
    default     = false
}

variable "timeouts_configuration" {
    type = list(object({
        create = string
        update = string
        delete = string
    }))
    default     = []
    description = "List of timeout values per action. Only valid actions are `create`, `update` and `delete`"
}

variable "enabled_cloudwatch_logs_exports" {
    type        = list(string)
    description = "List of log types to export to cloudwatch. The following log types are supported: audit, error, general, slowquery"
    default     = []
}

variable "deletion_protection" {
    type        = bool
    description = "If the DB instance should have deletion protection enabled"
    default     = false
}

variable "instance_type" {
    type        = string
    default     = "db.t2.small"
    description = "Instance type to use"
}

variable "publicly_accessible" {
    type        = bool
    description = "Set to true if you want your cluster to be publicly accessible (such as via QuickSight)"
    default     = false
}

variable "db_tags" {
    type        = map
    description = "The map of tags that need to be given for db instance"
    default     = {}
}

variable "auto_minor_version_upgrade" {
    type        = bool
    default     = true
    description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
}

variable "rds_monitoring_interval" {
    type        = number
    description = "The interval, in seconds, between points when enhanced monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60"
    default     = 0
}

variable "performance_insights_enabled" {
    type        = bool
    default     = false
    description = "Whether to enable Performance Insights"
}

variable "performance_insights_kms_key_id" {
    type        = string
    default     = ""
    description = "The ARN for the KMS key to encrypt Performance Insights data. When specifying `performance_insights_kms_key_id`, `performance_insights_enabled` needs to be set to true"
}

variable "instance_availability_zone" {
    type        = string
    default     = ""
    description = "Optional parameter to place cluster instances in a specific availability zone. If left empty, will place randomly"
}

variable "db_subnet_group_name" {
    type        = string
    description = "The name of the DB subnet group"
    default     = ""
}

variable "subnets" {
    type        = list(string)
    description = "List of VPC subnet IDs"
    default     = []
}

variable "db_cluster_parameter_group_name" {
    type        = string
    description = "The name of the db cluster parameter group"
    default     = ""
}

variable "cluster_family" {
    type        = string
    default     = "aurora5.6"
    description = "The family of the DB cluster parameter group"
}

variable "cluster_parameters" {
    type = list(object({
        apply_method = string
        name         = string
        value        = string
    }))
    default     = []
    description = "List of DB cluster parameters to apply"
}

variable "db_parameter_group_name" {
    type        = string
    description = "The name of the DB instance parameter group"
    default     = ""
}

variable "instance_parameters" {
    type = list(object({
        apply_method = string
        name         = string
        value        = string
    }))
    default     = []
    description = "List of DB instance parameters to apply"
}