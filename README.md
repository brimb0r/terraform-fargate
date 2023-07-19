1. state / dynamo
2. ecr
3. route53
4. cert - domain ( registart takes up to 1 hour)
5. plan - apply - from root dir
6. - Follow env hierarchy e.g 001, 002, so on and so forth recursively as well
    1. terraform init 
    2. terraform plan -out=planfile
    3. terraform apply
    4. when done terraform destroy 
       5. Note :: You can use --auto-approve flag if you are confident
## Docker - build and push to ECR
``` 
docker build -t coast-test-go .
docker tag coast-test-go:latest public.ecr.aws/u8j1b7o3/coast-test:latest
docker push public.ecr.aws/u8j1b7o3/coast-test-go:latest

```

## TODO 

- Add in compose build process ( add in crud )
- local stack for local CI testing
