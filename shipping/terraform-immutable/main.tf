module "shipping" {
  source              = "git::https://DevOps-Batches@dev.azure.com/DevOps-Batches/DevOps60/_git/terraform-immutable//app-module"
  INSTANCE_TYPE       = var.INSTANCE_TYPE
  ENV                 = var.ENV
  SPOT_INSTANCE_COUNT = var.SPOT_INSTANCE_COUNT
  OD_INSTANCE_COUNT   = var.OD_INSTANCE_COUNT
  COMPONENT           = "shipping"
  PORT                = 8080
  IS_PRIVATE_LB       = true
  LB_RULE_PRIORITY    = 104
  APP_VERSION         = var.APP_VERSION
  NEXUS_USER          = var.NEXUS_USER
  NEXUS_PASS          = var.NEXUS_PASS
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
}
