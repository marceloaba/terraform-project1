terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
    cloud {
      organization = "marceloaba"
      workspaces {
        name = "lab1"
      }
    }
}

resource "aws_key_pair" "marcelo-ssh-key" {
  key_name   = "marcelo-ssh-key-pair"
  public_key = file("files/marcelo-key.pub")
}