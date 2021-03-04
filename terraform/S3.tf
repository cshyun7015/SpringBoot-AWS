resource "aws_s3_bucket" "S3Bucket" {
  bucket = "ib07441-s3bucket-springboot-aws"
  force_destroy = true
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "IB07441-S3Bucket-SpringBoot-AWS"
    Environment = "Dev"
  }
}