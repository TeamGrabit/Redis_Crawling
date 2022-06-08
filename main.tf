terraform {
  required_providers {
    rediscloud = {
      source = "RedisLabs/rediscloud"
    }
  }
  required_version = ">= 0.13"
}

provider "rediscloud" {
  url        = var.url
  api_key    = var.access_key
  secret_key = var.secret_key
}

resource "rediscloud_subscription" "subscription" {
  name                         = "Redis-Grabit"
  memory_storage               = "ram"

  cloud_provider {
    provider = "AWS"
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