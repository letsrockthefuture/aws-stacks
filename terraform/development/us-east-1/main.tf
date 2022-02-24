resource "aws_s3_bucket" "development" {
  bucket = "letsrockthefuture-development-bucket"
  acl    = "public-read"

  tags = {
    Name        = "letsrockthefuture-development-bucket"
    Environment = "development"
  }
}
