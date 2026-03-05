module "{{ENV}}" {
  source = "git::https://gitlab.planetmeican.com/meican-cd/terraform-modules.git//aws3/meican/{{CONTEXT_MODULE}}?ref={{CONTEXT_REF}}"

  app            = local.app
  role           = local.role
  service        = local.service
  cluster        = local.cluster
  environment    = local.environment
  team           = local.team
  costing_family = local.costing_family
}
