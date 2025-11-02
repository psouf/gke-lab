plugin "google" {
    enabled = true
    version = "0.37.1"
    source  = "github.com/terraform-linters/tflint-ruleset-google"
}

config {
  format            = "compact"
  force             = false
  call_module_type  = "local"  
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "google_compute_instance_invalid_machine_type" {
  enabled = true
}