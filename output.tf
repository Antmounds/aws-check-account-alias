# output Lambda url and arn

output "Details" {
  value = "\nARN -  ${aws_lambda_function.check_alias_lambda.arn}\nVersion - ${aws_lambda_function.check_alias_lambda.version}\nLast Modified - ${aws_lambda_function.check_alias_lambda.last_modified}"
}
