terraform {
  backend "s3" {
    bucket = "jumiker-terraform"
    key    = "sysdig"
    region = "ap-southeast-2"
  }
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "ap-southeast-2"
  region = "ap-southeast-2"
}

module "single-account-threat-detection-us-east-1" {
  providers = {
    aws = aws.us-east-1
  }
  source                  = "draios/secure-for-cloud/aws//modules/services/event-bridge"
  target_event_bus_arn    = "arn:aws:events:ap-southeast-2:263844535661:event-bus/ap-southeast-2-production-falco-1"
  trusted_identity        = "arn:aws:iam::263844535661:role/ap-southeast-2-production-secure-assume-role"
  external_id             = "f56505f244584976249dd60d6b257631"
  name                    = "sysdig-secure-events-4c9e"
  deploy_global_resources = true
}

module "single-account-threat-detection-ap-southeast-2" {
  providers = {
    aws = aws.ap-southeast-2
  }
  source               = "draios/secure-for-cloud/aws//modules/services/event-bridge"
  target_event_bus_arn = "arn:aws:events:ap-southeast-2:263844535661:event-bus/ap-southeast-2-production-falco-1"
  trusted_identity     = "arn:aws:iam::263844535661:role/ap-southeast-2-production-secure-assume-role"
  external_id          = "f56505f244584976249dd60d6b257631"
  name                 = "sysdig-secure-events-4c9e"
  role_arn             = module.single-account-threat-detection-us-east-1.role_arn
}

module "single-account-cspm" {
  providers = {
    aws = aws.us-east-1
  }
  source           = "draios/secure-for-cloud/aws//modules/services/trust-relationship"
  role_name        = "sysdig-secure-kgwt"
  trusted_identity = "arn:aws:iam::263844535661:role/ap-southeast-2-production-secure-assume-role"
  external_id      = "f56505f244584976249dd60d6b257631"
}

module "single-account-agentless-scanning-us-east-1" {
  providers = {
    aws = aws.us-east-1
  }
  source                  = "draios/secure-for-cloud/aws//modules/services/agentless-scanning"
  trusted_identity        = "arn:aws:iam::263844535661:role/ap-southeast-2-production-secure-assume-role"
  external_id             = "f56505f244584976249dd60d6b257631"
  name                    = "sysdig-secure-scanning-nu1s"
  scanning_account_id     = "878070807337"
  deploy_global_resources = true
}

module "single-account-agentless-scanning-ap-southeast-2" {
  providers = {
    aws = aws.ap-southeast-2
  }
  source              = "draios/secure-for-cloud/aws//modules/services/agentless-scanning"
  trusted_identity    = "arn:aws:iam::263844535661:role/ap-southeast-2-production-secure-assume-role"
  external_id         = "f56505f244584976249dd60d6b257631"
  name                = "sysdig-secure-scanning-nu1s"
  role_arn            = module.single-account-agentless-scanning-us-east-1.role_arn
  scanning_account_id = "878070807337"
}

terraform {

  required_providers {
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = "~> 1.24.2"
    }
  }
}

provider "sysdig" {
  sysdig_secure_url       = "https://app.au1.sysdig.com"
  sysdig_secure_api_token = "c48022c3-0534-4535-9030-742c190c1aef"
}

resource "sysdig_secure_cloud_auth_account" "aws_account_281031839323" {
  enabled       = true
  provider_id   = "281031839323"
  provider_type = "PROVIDER_AWS"

  feature {

    secure_threat_detection {
      enabled    = true
      components = ["COMPONENT_EVENT_BRIDGE/secure-runtime"]
    }

    secure_identity_entitlement {
      enabled    = true
      components = ["COMPONENT_EVENT_BRIDGE/secure-runtime", "COMPONENT_TRUSTED_ROLE/secure-posture"]
    }

    secure_config_posture {
      enabled    = true
      components = ["COMPONENT_TRUSTED_ROLE/secure-posture"]
    }

    secure_agentless_scanning {
      enabled    = true
      components = ["COMPONENT_TRUSTED_ROLE/secure-scanning", "COMPONENT_CRYPTO_KEY/secure-scanning"]
    }
  }
  component {
    type     = "COMPONENT_TRUSTED_ROLE"
    instance = "secure-posture"
    trusted_role_metadata = jsonencode({
      aws = {
        role_name = "sysdig-secure-kgwt"
      }
    })
  }
  component {
    type     = "COMPONENT_EVENT_BRIDGE"
    instance = "secure-runtime"
    event_bridge_metadata = jsonencode({
      aws = {
        role_name = "sysdig-secure-events-4c9e"
        rule_name = "sysdig-secure-events-4c9e"
      }
    })
  }
  component {
    type     = "COMPONENT_TRUSTED_ROLE"
    instance = "secure-scanning"
    trusted_role_metadata = jsonencode({
      aws = {
        role_name = "sysdig-secure-scanning-nu1s"
      }
    })
  }
  component {
    type     = "COMPONENT_CRYPTO_KEY"
    instance = "secure-scanning"
    crypto_key_metadata = jsonencode({
      aws = {
        kms = {
          alias    = "alias/sysdig-secure-scanning-nu1s"
          regions  = [
            "us-east-1",
            "ap-southeast-2",
          ]
        }
      }
    })
  }
  depends_on = [module.single-account-agentless-scanning-ap-southeast-2, module.single-account-agentless-scanning-us-east-1, module.single-account-cspm, module.single-account-threat-detection-ap-southeast-2, module.single-account-threat-detection-us-east-1]
}
