terraform {
  required_providers {
    rediscloud = {
      source = "RedisLabs/rediscloud"
    }
  }
  required_version = ">= 0.13"
}

data "rediscloud_regions" "example" {
}