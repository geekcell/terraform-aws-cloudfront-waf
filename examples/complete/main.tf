module "example" {
  source = "../../"
  name   = "my-waf"

  providers = {
    aws = aws.us-east-1
  }
}

provider "aws" {
  allowed_account_ids = ["1234567890"]
  profile             = "AdministratorAccess-1234567890"
  region              = "us-east-1"
  alias               = "us-east-1"
}
