resource "aws_instance" "web" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web.id]
  
  # Webserver mit benutzerdefiniertem Inhalt
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              
              cat > /var/www/html/index.html << 'HTMLCONTENT'
              ${var.webserver_content}
              <p>Server Nummer ${count.index + 1} in der ${var.environment}-Umgebung</p>
              <p>Erstellt am: $(date)</p>
              HTMLCONTENT
              EOF

  tags = {
    Name        = "webserver-${var.environment}-${count.index + 1}"
    Environment = var.environment
  }
}