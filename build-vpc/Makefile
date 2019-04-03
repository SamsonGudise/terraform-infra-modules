init:
	terraform init

plan:
	terraform init -backend-config=backend.tfvars
	terraform plan -out tfplan.out

apply:
	terraform apply tfplan.out

clean:
	rm -rf .terraform 
