resource "aws_iam_saml_provider" {
  region = "us-east-1"
}

resource "aws_instance" "cost_optimization" {
  ami           = "ami-0fe630eb857a6ec83"
  instance_type = "t2.micro"
  key_name      = "AKIAX3XRTPF2ZNOFCU7Z"

}
