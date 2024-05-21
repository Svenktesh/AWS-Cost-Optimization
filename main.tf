resource "aws_iam_saml_provider" {
  region = "us-east-1"
}

resource "aws_instance" "cost_optimization" {
  ami           = "ami-0fe630eb857a6ec83"
  instance_type = "t2.micro"
  subnet_id     = "subnet-0954fe2b5dbcca453"
  key_name      = "cost optimization"
}
