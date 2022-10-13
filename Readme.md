<img width="1228" alt="スクリーンショット 2022-10-13 23 25 07" src="https://user-images.githubusercontent.com/57698798/195623883-e6601055-2abd-4f3e-89b2-b6783b0c4457.png">


## Explanation
Template for creating an ECS environment divided into an APP container and a Nginx container

## Configuration
The ECS container is located on a private subnet and only receives requests via ALB.

Only HTTPS is allowed for client requests,   
and if HTTP requests is received, it will be converted to HTTPS requests.

## Preparation
Please do the following in advance

1. Getting Domain Name
2. Creating Host Zones with Route53
3. Registering images in the ECR
