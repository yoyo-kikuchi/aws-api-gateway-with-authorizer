# AWS Api Gateway with Authorizer

Api Gateway lambda function and lambda Authorizer sample

## Requirement

- Ruby: >=3.3.2
- terraform: >= 1.6.4

## Usage

### Control aws api gateway resources

before execute, need setup tfvars

```bash
cp terraform.tfvars.example terraform.tfvars
# then fill-up each values
```

- init

```
cd terraform
terraform init
```

- create

```
cd terraform apply
```

- destroy

```
terraform destroy
```
