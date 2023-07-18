1. state / dynamo
2. ecr
3. route53
4. cert - domain ( registart takes up to 1 hour)
5. plan - apply - from root dir
    1. terraform init -backend-config=../env/dev/us-east-1/dev.backend
    2. terraform plan --var-file=../env/dev/us-east-1/dev.tfvars -out=planfile
    3. terraform apply --var-file=../env/dev/us-east-1/dev.tfvars

## Docker - build and push to ECR
``` 
docker build -t coast-test-go .
docker tag coast-test-go:latest public.ecr.aws/u8j1b7o3/coast-test:latest
docker push public.ecr.aws/u8j1b7o3/coast-test-go:latest

```
