
locals {
  cluster_instance_count = var.cluster_size
  is_regional_cluster    = var.cluster_type
}

resource "aws_rds_cluster" "primary" {
    cluster_identifier                  = var.cluster_identifier
    database_name                       = var.db_name
    master_username                     = var.admin_user
    master_password                     = var.admin_password
    backup_retention_period             = var.retention_period
    preferred_backup_window             = var.backup_window
    copy_tags_to_snapshot               = var.copy_tags_to_snapshot
    final_snapshot_identifier           = format("%s-%s", var.cluster_identifier, "final-snapshot")
    skip_final_snapshot                 = var.skip_final_snapshot
    apply_immediately                   = var.apply_immediately
    storage_encrypted                   = var.storage_encrypted
    kms_key_id                          = var.kms_key_arn
    source_region                       = var.source_region
    snapshot_identifier                 = var.snapshot_identifier
    vpc_security_group_ids              = [var.db_sg_id]
    preferred_maintenance_window        = var.maintenance_window
    db_subnet_group_name                = join("", aws_db_subnet_group.default.*.name)
    db_cluster_parameter_group_name     = join("", aws_rds_cluster_parameter_group.default.*.name)
    iam_database_authentication_enabled = var.iam_database_authentication_enabled
    tags                                = var.tags
    engine                              = var.engine
    engine_version                      = var.engine_version
    allow_major_version_upgrade         = var.allow_major_version_upgrade
    engine_mode                         = var.engine_mode
    iam_roles                           = var.iam_roles
    backtrack_window                    = var.backtrack_window
    enable_http_endpoint                = var.engine_mode == "serverless" && var.enable_http_endpoint ? true : false

    depends_on = [
        aws_db_subnet_group.default,
        aws_rds_cluster_parameter_group.default,
        aws_security_group.default,
    ]

    dynamic "timeouts" {
        for_each = var.timeouts_configuration
        content {
            create = lookup(timeouts.value, "create", "120m")
            update = lookup(timeouts.value, "update", "120m")
            delete = lookup(timeouts.value, "delete", "120m")
        }
    }

    enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
    deletion_protection             = var.deletion_protection
}
    

resource "aws_rds_cluster_instance" "default" {
    count                           = local.cluster_instance_count
    identifier                      = "${var.cluster_identifier}-${count.index + 1}"
    cluster_identifier              = aws_rds_cluster.primary.id
    instance_class                  = var.instance_type
    db_subnet_group_name            = aws_db_subnet_group.default.name
    db_parameter_group_name         = aws_db_parameter_group.default.name
    publicly_accessible             = var.publicly_accessible
    tags                            = var.db_tags
    engine                          = var.engine
    engine_version                  = var.engine_version
    auto_minor_version_upgrade      = var.auto_minor_version_upgrade
    monitoring_interval             = var.rds_monitoring_interval
    performance_insights_enabled    = var.performance_insights_enabled
    performance_insights_kms_key_id = var.performance_insights_kms_key_id
    availability_zone               = var.instance_availability_zone
    apply_immediately               = var.apply_immediately

    depends_on = [
        aws_db_subnet_group.default,
        aws_db_parameter_group.default,
        aws_iam_role.enhanced_monitoring,
        aws_rds_cluster.secondary,
        aws_rds_cluster_parameter_group.default,
    ]

    lifecycle {
        ignore_changes = [engine_version]
    }
}

resource "aws_db_subnet_group" "default" {
    name        = var.db_subnet_group_name
    description = "Allowed subnets for DB cluster instances"
    subnet_ids  = var.subnets
}

resource "aws_rds_cluster_parameter_group" "default" {
    name        = var.db_cluster_parameter_group_name
    description = "DB cluster parameter group"
    family      = var.cluster_family

    dynamic "parameter" {
        for_each = var.cluster_parameters
        content {
            apply_method = lookup(parameter.value, "apply_method", null)
            name         = parameter.value.name
            value        = parameter.value.value
        }
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_db_parameter_group" "default" {
    name        = var.db_parameter_group_name
    description = "DB instance parameter group"
    family      = var.cluster_family

    dynamic "parameter" {
        for_each = var.instance_parameters
        content {
            apply_method = lookup(parameter.value, "apply_method", null)
            name         = parameter.value.name
            value        = parameter.value.value
        }
    }

    lifecycle {
        create_before_destroy = true
    }
}