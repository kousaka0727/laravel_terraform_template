profile_name = nomura-admin

init:
	terraform init

apply:
	aws-vault exec $(profile_name) -- terraform apply -parallelism=20

plan:
	aws-vault exec $(profile_name) -- terraform plan -parallelism=20
	
destroy:
	aws-vault exec $(profile_name) -- terraform destroy -auto-approve

fmt:
	terraform fmt
