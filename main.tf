terraform {
  required_providers {
    rediscloud = {
      source = "RedisLabs/rediscloud"
    }
  }
  required_version = ">= 0.13"
}

provider "rediscloud" {
  api_key    = var.access_key
  secret_key = var.secret_key
}

resource "rediscloud_cloud_account" "grabit" {
  access_key_id     = var.access_key_id
  access_secret_key = var.access_secret_key
  console_username  = var.console_username
  console_password  = var.console_password
  name              = "redis-grabit"
  provider_type     = "AWS"
  sign_in_login_url = var.sign_in_login_url
}

resource "rediscloud_subscription" "grabit" {
  name           = "Redis-Grabit"
  memory_storage = "ram"

  cloud_provider {
    provider         = data.rediscloud_cloud_account.grabit.provider_type
    cloud_account_id = data.rediscloud_cloud_account.grabit.id
    region {
      region                       = "ap-northeast-2"
      networking_deployment_cidr   = var.networking_deployment_cidr
      preferred_availability_zones = ["ap-northeast-2a"]
    }
  }

  database {
    name                         = "Redis-Grabit-DB"
    protocol                     = "redis"
    memory_limit_in_gb           = 0.01
    password                     = var.database_password
    replication                  = "false"
    throughput_measurement_by    = "operations-per-second"
    throughput_measurement_value = 10000
  }
}

resource "rediscloud_subscription_peering" "grabit" {
  subscription_id = rediscloud_subscription.grabit.id
  region          = "ap-northeast-2"
  aws_account_id  = var.aws_account_id
  vpc_id          = "vpc-a7bf2ccc"
  vpc_cidr        = var.networking_deployment_cidr
}

resource "aws_vpc_peering_connection_accepter" "grabit-peering" {
  vpc_peering_connection_id = rediscloud_subscription_peering.grabit.aws_peering_id
  auto_accept               = true
}

data "rediscloud_cloud_account" "grabit" {
  exclude_internal_account = true
  provider_type = "AWS"
  name = "redis-grabit"
}

output "cloud_account_id" {
  value = data.rediscloud_cloud_account.grabit.id
}

output "cloud_account_access_key_id" {
  value = data.rediscloud_cloud_account.grabit.access_key_id
}