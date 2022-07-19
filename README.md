# Affinda Document Parser Self-Hosted

Affinda Resume Parser Self-hosted is a self-contained instance of Affinda’s document parsing API. It is designed 
specifically for environments with stringent compliance, privacy, and security requirements, where the cloud hosted 
API is not suitable. It can be deployed to your own self-managed infrastructure, where all processing is performed 
strictly within.

The Affinda Document Parser is provided as set of docker containers. Once deployed, you can submit 
parse requests via the API just like you would to the cloud hosted API. The API endpoints are identical, making 
migration to/from and testing against our cloud endpoints simple.

This repository contains configurations that can be used to run the Affinda document parser in a local deployment.
Some instructions are AWS-specific, however running on other cloud platforms is also possible.

You will need access to the relevant Affinda repositories to run this code.  Please contact sales@affinda.com.

## Configuration

There are two supported approaches to configuring the service: EC2 instance running docker compose, or Elastic Container
Service (ECS).  For organizations running a single instance, we recommend docker compose.  For organizations running
many instances who may require auto-scaling of capacity based on demand, we recommend ECS.

### Docker compose

1. Launch a new G4dn.2xlarge instance using [ami-03d86650f7383f67c](https://ap-southeast-2.console.aws.amazon.com/ec2/v2/home?region=ap-southeast-2#ImageDetails:imageId=ami-03d86650f7383f67c). 
The configuration is optimised for this instance type, so if we recommend running additional instances if you require
higher throughput.
   1. If you are not running in the region of the ami (ap-southeast-2), you will need to copy the AMI to your region.
      (actions -> copy AMI)
   2. If you are not using AWS, then launch an instance with NVIDIA GPU drivers and docker engine/compose installed.
2. Authenticate docker with AWS. Note that the affinda repositories are private. Contact sales@affinda.com for access.
Additionally, the IAM role for this instance will need to have ECR permissions assigned.
```
aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin 332187135683.dkr.ecr.ap-southeast-2.amazonaws.com
```
3. Add the [docker compose](docker-compose.yml) file to your the home directory on the server.  This could also be
achieved by cloning this repostory with `git clone git@github.com:affinda/self-hosted.git`
4. Run `docker compose pull` and `docker compose up` to pull the containers and start the service. 
5. Note that the first time it runs it will take
approximately 5 minutes to complete initial database migrations.
6. You should now be able to access the admin login page at the IP address of the service.  The initial login 
credentials are: `admin`, password: `changeme`  You know what to do.

### Elastic Container Service (ECS)

Task definition can be found at [ECS-task-definition.json](ECS-task-definition.json)

Further instructions to come.
