variable s3_bucket_names {
  description = "List of bucket names"
  type = list 
}
variable tags { type = map }
variable sse_algorithm { default = "AES256" }
variable block_public_access { 
  description = "Block public access"
  default = true 
}

resource "aws_kms_key" "terraform-s3" {
  count = var.sse_algorithm == "AES256" ? 0 : 1
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "terraform-s3-bucket" {
  count = length(var.s3_bucket_names)
  bucket = var.s3_bucket_names[count.index]
  acl    = "private"
  versioning {
      enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = var.sse_algorithm
      }
    }
  }

  tags = merge(var.tags, 
        map("Name", var.s3_bucket_names[count.index])
  )
}

resource "aws_s3_bucket_public_access_block" "terraform-s3-bucket" {
  count = var.block_public_access ? length(var.s3_bucket_names) : 0
  bucket = aws_s3_bucket.terraform-s3-bucket.*.id[count.index]
  block_public_acls   = var.block_public_access
  block_public_policy = var.block_public_access
  ignore_public_acls = var.block_public_access
  restrict_public_buckets = var.block_public_access
}
