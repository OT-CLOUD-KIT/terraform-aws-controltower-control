data "aws_region" "current" {}

data "aws_organizations_organization" "id" {}

data "aws_organizations_organizational_units" "ids" {
  parent_id = data.aws_organizations_organization.id.roots[0].id
}

data "aws_organizations_organizational_units" "sub_ous_ids" {
  for_each  = local.map_level_1_ous
  parent_id = each.value.id
}

resource "aws_controltower_control" "for" {
  for_each           = local.merged_map_each_control_tower_control
  target_identifier  = each.value.arn
  control_identifier = "arn:aws:controltower:${data.aws_region.current.name}::control/${each.value.control_name}"
}
