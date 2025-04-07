provider "aws" {
  region = "eu-central-1"
}

# Neuestes Amazon Linux 2 AMI finden (statt hardcoded AMI)
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Zugriff auf die gemeinsame VPC
data "terraform_remote_state" "shared" {
  backend = "local"
  config = {
    path = "../shared/terraform.tfstate"
  }
}

# Verwendung des Webserver-Moduls
module "prod_webserver" {
  source = "../../modules/webserver"
  
  environment   = "prod"
  instance_type = "t3a.micro"
  ami_id        = data.aws_ami.amazon_linux.id
  vpc_id        = data.terraform_remote_state.shared.outputs.vpc_id
  subnet_id     = data.terraform_remote_state.shared.outputs.subnet_id
  
  # Neue Parameter
  instance_count   = 3  # Drei Instanzen für Produktion (mehr Kapazität)
  webserver_content = <<-HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>Production Webserver</title>
      <style>
        body { font-family: Arial, sans-serif; background-color: #f5f5f5; padding: 20px; }
        h1 { color: #006600; }
        .prod-badge { 
          background-color: #006600; 
          color: white; 
          padding: 5px 10px; 
          border-radius: 5px; 
          display: inline-block; 
        }
      </style>
    </head>
    <body>
      <h1>Produktionsumgebung</h1>
      <div class="prod-badge">PRODUKTION</div>
      <p>Dies ist ein Live-Server der Produktionsumgebung.</p>
    </body>
    </html>
  HTML
}

# Outputs
output "prod_instance_ips" {
  value = module.prod_webserver.public_ips
}