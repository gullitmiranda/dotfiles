# Terragrunt aliases
tg() { terragrunt "$@"; }
tgp() { terragrunt plan "$@"; }
tga() { terragrunt apply "$@"; }
tgi() { terragrunt init "$@"; }
tgd() { terragrunt destroy "$@"; }
tgra() { terragrunt run-all "$@"; }
