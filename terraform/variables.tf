
########## AWS ##########
variable "region" {
  description = "Region that the instances will be created"
  default = "ap-southeast-2"
}

variable "access_key" {}

variable "secret_key" {}

# Environment value in all lower (for things like tags)
variable "Environment" {
  description = "Shortcode for environment, e.g. dev, test"
  type        = string
  default     = "dev"
}

########### ECS ##########
variable "ECSHostSize" {
  description = "ECS hosts will be launch in this instance size"
  default     = "g4dn.2xlarge"
}

variable "ECSHostCount" {
  default = 1
}

variable "ECSHostAZ" {
  default = "ap-southeast-2a"
}

# Map the private subnet ID to the AZ - used for Instance builds where we specify
# the region to build, but need the subnet id for resources
locals {
  PrivateSubnet = {
    "ap-southeast-2a" = data.aws_subnet.PrivateA.id
    "ap-southeast-2b" = data.aws_subnet.PrivateB.id
    "ap-southeast-2c" = data.aws_subnet.PrivateC.id
  }
}

#####################################################
#  Affinda container env vars
#####################################################

variable db_host {}
variable db_pass {}
variable django_secret_key {}
variable django_superuser_password {}

#####################################################
#  Affinda image names - keeping in one spot in case we need to modify or turn into external reference (e.g. Octopus vars)
#####################################################
variable celery_worker_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/affinda-selfhosted:latest"
}

variable celery_beat_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/affinda-selfhosted:latest"
}

variable web_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/affinda-selfhosted:latest"
}

variable ocr_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/ocr:latest"
}

variable text_extraction_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/text_extraction:latest"
}

variable pdfkit_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/pdfkit:latest"
}

variable inference_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/affinda-inference-selfhosted-resumes:latest"
}

variable libreoffice_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/libre_office:latest"
}

variable redis_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/affinda-redis:latest"
}