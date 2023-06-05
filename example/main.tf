module "control" {
  source                = "./module"
  controltower_controls = var.controltower_controls
  all_control_lists     = var.all_control_lists
}

