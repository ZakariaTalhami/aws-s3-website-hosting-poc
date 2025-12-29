
locals {
  # Load list of files in the build directory
  files = fileset(var.build_dir, "**")
}

# Iterate file list and upload files to the bucket
resource "aws_s3_object" "website_files" {
  for_each = local.files
  bucket   = aws_s3_bucket.s3-website-bucket.id
  key      = each.key
  source   = "${var.build_dir}/${each.key}"
  etag     = filemd5("${var.build_dir}/${each.key}") # Ensures updates are detected

  # Dynamically determine the content type for proper serving
  content_type = lookup(
    {
      "html" = "text/html"
      "css"  = "text/css"
      "js"   = "application/javascript"
      "png"  = "image/png"
      "jpg"  = "image/jpeg"
      "svg"  = "image/svg+xml"
      "ico"  = "image/x-icon"
    },
    regex("\\.(.*)$", each.key)[0],
    "binary/octet-stream" # Default fallback
  )
}