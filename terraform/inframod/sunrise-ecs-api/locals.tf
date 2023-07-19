locals {
  # Configuration variables
  environment = var.environment == "dev" || var.environment == "test"
}