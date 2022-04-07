provider "aws" {
  region = "eu-west-2"
}

variable "glue_job_role" {
  default = "arn:aws:iam::776347453069:role/AWSGlue-Universal-Crawler"
}

resource "aws_s3_bucket" "glue_bucket" {}

# Download Python WHL files to the dependencies folder using an Amazon Linux 2 Docker container OR fiddle with platform arguments to PIP
# resource "null_resource" "install_requirements" {
#     provisioner "local-exec" {
#       command = "/usr/local/bin/pip3 download --platform linux_x86_64 --no-deps --dest dependencies -r requirements.txt"
#     }
# }

resource "aws_s3_object" "dependencies" {
  # depends_on = [null_resource.install_requirements]
  
  for_each = fileset("dependencies/", "*")
  bucket   = aws_s3_bucket.glue_bucket.id
  key      = each.value
  source   = "dependencies/${each.value}"
  etag     = filemd5("dependencies/${each.value}")
}

# output "dep_list" {
#   value = join(",", formatlist("s3://${aws_s3_bucket.glue_bucket.id}/dependencies/%s", fileset("dependencies/","*")))
# }

resource "aws_s3_object" "glue_env_script" {
  bucket = aws_s3_bucket.glue_bucket.id
  key    = "glue-env-script.py"
  source = "glue-env.py"

  etag = filemd5("glue-env.py")
}

resource "aws_glue_job" "glue_env_job" {
  # depends_on = [null_resource.install_requirements]
  
  name     = "glue-env-job"
  role_arn = var.glue_job_role
  glue_version = "2.0"
  number_of_workers = 2
  worker_type = "G.1X"

  command {
    script_location = "s3://${aws_s3_bucket.glue_bucket.id}/${aws_s3_object.glue_env_script.key}"
  }

  default_arguments = {
    "--additional-python-modules" = join(",", formatlist("s3://${aws_s3_bucket.glue_bucket.id}/%s", fileset("dependencies/","*")))
  }
}