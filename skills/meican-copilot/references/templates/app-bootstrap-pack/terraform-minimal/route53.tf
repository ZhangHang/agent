module "{{APP}}_grpc_route53" {
  source = "git::https://gitlab.planetmeican.com/meican-cd/terraform-modules.git//aws3/meican/kong_route53?ref=aws3-meican-kong_route53-v1.0.0"

  zone_id          = module.{{ENV}}.route53_zone_id
  name             = "{{HOST_BASE}}"
  alias_name_kong1 = module.{{ENV}}.route53_alias_name_kong1
  kong1_weighted   = 100
  alias_name_kong2 = module.{{ENV}}.route53_alias_name_kong2
  kong2_weighted   = 0
  alias_zone_id    = module.{{ENV}}.route53_alias_zone_id
}
