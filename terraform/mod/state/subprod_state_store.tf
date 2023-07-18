# create an S3 bucket to store the state file in
resource "aws_s3_bucket" "subprod-terraform-state-storage-s3" {
  count  = var.is_prod == "false" ? 1 : 0
  bucket = "subprod-terraform-state-store-${var.aws_bucket_region}"
  tags = {
    Name = "S3 SubProd Remote Terraform State Store"
  }
}

resource "aws_s3_bucket_object" "subprod-state_folder" {
  count                  = var.is_prod == "false" ? 1 : 0
  key                    = format("env:/%v/", "subprod")
  bucket                 = aws_s3_bucket.subprod-terraform-state-storage-s3.0.id
  source                 = "/dev/null"
  server_side_encryption = "AES256"
}

resource "aws_dynamodb_table" "subprod-terraform-state-lock-dynamodb" {
  count          = var.is_prod == "false" ? 1 : 0
  name           = "subprod-state-store"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "DynamoDB SubProd Terraform State Lock Table"
  }
}
