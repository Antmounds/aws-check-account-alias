#!/bin/bash
# Title: Deploy AWS Lambda Function
# Description: zips a directory containing an aws lambda function and optionally deploys  to default VPC
zip -r ./lambda_function_payload.zip ./lambda_function.rb

# terraform init to initialize
terraform init
# terraform plan and apply to deploy
terraform plan
terraform apply -auto-approve

# remove zip payload file
# rm ./lambda_function_payload.zip