# ============================================================
# cloudticket-platform — EC2 + SSH Key Pair
# File: terraform/ec2.tf
# ============================================================

# ─────────────────────────────────────────
# SSH Key Pair
# Generate with: ssh-keygen -t rsa -b 4096 -f ~/.ssh/cloudticket
# ─────────────────────────────────────────
resource "aws_key_pair" "main" {
  key_name   = "${var.project_name}-key"
  public_key = file(var.ssh_public_key_path)

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-keypair"
  })
}

# ─────────────────────────────────────────
# Latest Ubuntu 22.04 AMI (free tier)
# ─────────────────────────────────────────
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ─────────────────────────────────────────
# EC2 Instance — t2.micro (free tier)
# ─────────────────────────────────────────
resource "aws_instance" "main" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = aws_key_pair.main.key_name

  root_block_device {
    volume_size = 20    # GB — free tier allows up to 30GB
    volume_type = "gp2"
  }

  user_data = file("${path.module}/../scripts/install-k3s.sh")

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-ec2"
    Role = "k3s-master"
  })
}

# ─────────────────────────────────────────
# Elastic IP — keeps same IP after reboots
# ─────────────────────────────────────────
resource "aws_eip" "main" {
  instance = aws_instance.main.id
  domain   = "vpc"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-eip"
  })
}
