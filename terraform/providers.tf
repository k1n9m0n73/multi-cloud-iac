terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
    azurerm = { source = "hashicorp/azurerm" }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "azurerm" {
  features {}
	subscription_id = "1d9237d4-fcb2-4917-937e-0748a1fde8fb"
}

