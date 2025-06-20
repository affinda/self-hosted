
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
# If running Pelias geocoder, you need at least 4xlarge, or errors will happen
# If not running Pelias geocoder, 2xlarge will do
variable "ECSHostSize" {
  description = "ECS hosts will be launch in this instance size"
  default     = "g4dn.4xlarge"
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
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/affinda-selfhosted:6.33.445"
}

variable celery_beat_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/affinda-selfhosted:6.33.445"
}

variable web_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/affinda-selfhosted:6.33.445"
}

variable ocr_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/ocr:6.33.445"
}

variable text_extraction_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/text_extraction:7.54.1"
}

variable pdfkit_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/pdfkit:6.33.445"
}

variable inference_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/affinda-inference-selfhosted-resumes:6.33.445"
}

variable libreoffice_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/libre_office:6.33.445"
}

variable redis_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/affinda-redis:6.33.445"
}
variable opensearch_image {
  default = "opensearchproject/opensearch:2.8.0"
}
# And these four are for the Geo service
variable pelias_elasticsearch_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/pelias_elasticsearch:latest"
}

variable pelias_api_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/pelias_api:latest"
}

variable pelias_placeholder_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/pelias_placeholder:latest"
}

variable pelias_libpostal_image {
  default = "335594571162.dkr.ecr.ap-southeast-2.amazonaws.com/pelias_libpostal:latest"
}
