Environment                   = "#{Octopus.Environment.Name | ToLower}"
access_key                    = "#{Terraform_Key}"
secret_key                    = "#{Terraform_Secret}"

db_host                       = "#{DB_HOST}"
db_pass                       = "#{DB_PASS}"
django_secret_key             = "#{DJANGO_SECRET_KEY}"
django_superuser_password     = "#{DJANGO_SUPERUSER_PASSWORD}"