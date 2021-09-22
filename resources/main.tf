
terraform {
    required_version = ">= 0.11.11"
}

provider "aws" {
    region = "eu-west-2"
}

resource "random_password" "password" {
    length  = var.password_length
    special = var.special_allowed
}

module "rds_cluster" {
    source = "../modules"
    engine              = var.engine
    engine_mode         = var.engine_mode
    cluster_family      = var.cluster_family
    cluster_size        = var.cluster_size
    admin_user          = var.admin_user
    admin_password      = random_password.password.result
    db_name             = var.db_name
    instance_type       = var.instance_type
    db_sg_id            = var.db_sg_id
    subnets             = var.subnet_ids
    deletion_protection = var.deletion_protection

    cluster_parameters = [
        {
            name         = "character_set_client"
            value        = "utf8"
            apply_method = "pending-reboot"
        },
        {
            name         = "character_set_connection"
            value        = "utf8"
            apply_method = "pending-reboot"
        },
        {
            name         = "character_set_database"
            value        = "utf8"
            apply_method = "pending-reboot"
        },
        {
            name         = "character_set_results"
            value        = "utf8"
            apply_method = "pending-reboot"
        },
        {
            name         = "character_set_server"
            value        = "utf8"
            apply_method = "pending-reboot"
        },
        {
            name         = "collation_connection"
            value        = "utf8_bin"
            apply_method = "pending-reboot"
        },
        {
            name         = "collation_server"
            value        = "utf8_bin"
            apply_method = "pending-reboot"
        },
        {
            name         = "lower_case_table_names"
            value        = "1"
            apply_method = "pending-reboot"
        },
        {
            name         = "skip-character-set-client-handshake"
            value        = "1"
            apply_method = "pending-reboot"
        }
    ]
}

outputs "db_password" {
    value       = random_password.password.result
    description = "The password for connecting to DB instance"
}