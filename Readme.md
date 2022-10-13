## Explanation
Template for creating an ECS environment divided into an APP container and a Nginx container

## Configuration
The ECS container is located on a private subnet and only receives requests via ALB.

Only HTTPS is allowed for client requests,   
and if HTTP requests is received, it will be converted to HTTPS requests.

