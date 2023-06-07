data "aws_region" "current" {}

data "aws_organizations_organization" "id" {}

data "aws_organizations_organizational_units" "level-1" {
  parent_id = data.aws_organizations_organization.id.roots[0].id
}

data "aws_organizations_organizational_units" "level-2" {
  for_each  = local.map_level_1_ous
  parent_id = each.value.id
}

data "aws_organizations_organizational_units" "level-3" {
  for_each  = local.map_level_2_ous
  parent_id = each.value.id
}

data "aws_organizations_organizational_units" "level-4" {
  for_each  = local.map_level_3_ous
  parent_id = each.value.id
}

data "aws_organizations_organizational_units" "level-5" {
  for_each  = local.map_level_4_ous
  parent_id = each.value.id
}

resource "aws_controltower_control" "for" {
  for_each           = local.merged_map_each_control_tower_control
  target_identifier  = each.value.arn
  control_identifier = "arn:aws:controltower:${data.aws_region.current.name}::control/${each.value.control_name}"
}
