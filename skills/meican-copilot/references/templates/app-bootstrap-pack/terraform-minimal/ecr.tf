module "ecr" {
  source = "git::https://gitlab.planetmeican.com/meican-cd/terraform-modules.git//aws3/meican/ecr?ref=aws3-meican-ecr-v1.0.0"

  image_tag_mutability = "IMMUTABLE"
  name                 = "${local.service}/${local.app}"
  tags                 = module.{{ENV}}.tags
}
