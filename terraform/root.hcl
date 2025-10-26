

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

  terraform {
    backend "s3" {
    region                      = "us-east-2"                        
      bucket                      = "tartarus-infra"                    
      key                         = "terraform/${path_relative_to_include()}/terraform.tfstate"             
      encrypt                     = true
    }
  }
EOF
}
