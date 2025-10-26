include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  extra_arguments "secrets" {
    commands  = ["plan", "apply"]
    required_var_files = [
      "${get_parent_terragrunt_dir()}/secrets.tfvars.json"
    ]
  }
}
