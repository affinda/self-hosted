2023-06-22 - Stoo Brighting

Terraform project to create ECS cluster for Affinda services with two tasks; one for core Affinda services, and one for optional Geocoding Pelias services

Things to note:
* Project can be deployed "per environment" and as such there is an environment variable everywhere to control naming
* Some variables do not change that often and therefore are hard coded in variables.tf
* Project is currently designed to be deployed with Octopus Deploy, which is why there is an octopus.tfvars file. This file is added on the commandline when terraform apply is called from Octopus, and is used on conjunction with Octopus variable substition in order to pass correct per-environment variables to the project as it runs, depending on which environment its currently being deployed to. It also helps keep passwords and keys obfuscated and hidden as 
* The above Octopus can be removed by simply renaming the octopus.tfvars to terraform.tfvars and manually hard coding the values you need in there.
* State file is configured for S3 bucket. Custom Octopus "terraform apply" step also substitutes different state file locations in, depending on environment being deployed to, as you cannot use variables inside backend definitions (happens "outside" the main process kinda thing)




