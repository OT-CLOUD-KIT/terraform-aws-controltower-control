locals {
  level_1_ous = flatten([
    for ou_details in data.aws_organizations_organizational_units.ids.children[*] :
    merge({
      name = ou_details.name
      id   = ou_details.id
      arn  = ou_details.arn
      key  = ou_details.name

    })
  ])
  map_level_1_ous = { for ou_details in local.level_1_ous : ou_details.key => ou_details }

  level_2_ous = flatten([
    for key, value in local.map_level_1_ous : [
      for sub_ous_details in data.aws_organizations_organizational_units.sub_ous_ids[key].children[*] : {
        name = sub_ous_details.name
        id   = sub_ous_details.id
        arn  = sub_ous_details.arn
        key  = join("/", [value.name], [sub_ous_details.name])
      }
    ]
  ])

  map_level_2_ous = {
    for sub_ous_details in local.level_2_ous : sub_ous_details.key => sub_ous_details
  }

  merged_ous = merge(local.map_level_2_ous, local.map_level_1_ous)
}

locals {
  all_control_tower_controls = [for key, value in var.controltower_controls :
    merge({
      key                = key,
      value              = value
      control_identifier = setsubtract(toset(concat(keys(value["specific_controls"]), keys(var.all_control_lists))), keys(value["not_specific_controls"])),
      ous_info           = local.merged_ous[key]
      merged_controls    = merge(value["specific_controls"], var.all_control_lists)
    })
  ]
  each_all_control_tower_control = flatten([
    for value in local.all_control_tower_controls :
    [for new_value in value["control_identifier"] :
      merge({
        arn          = value["ous_info"]["arn"]
        ou_id        = value["ous_info"]["id"]
        control_name = new_value
        key          = join(": ", [value.key], [value["merged_controls"][new_value]])
    })]
    if value["value"]["all_controls"]
  ])

  map_each_all_control_tower_control = { for value in local.each_all_control_tower_control : value.key => value }

  control_tower_controls = [for key, value in var.controltower_controls :
    merge({
      key                = key,
      value              = value
      control_identifier = setsubtract(keys(value["specific_controls"]), keys(value["not_specific_controls"])),
      ous_info           = local.merged_ous[key]
      merged_controls    = merge(value["specific_controls"], var.all_control_lists)
    })
  ]

  each_control_tower_control = flatten([
    for value in local.control_tower_controls :
    [for new_value in value["control_identifier"] :
      merge({
        control_name = new_value
        arn          = value["ous_info"]["arn"]
        ou_id        = value["ous_info"]["id"]
        key          = join(": ", [value.key], [value["merged_controls"][new_value]])
    })]
  ])

  map_each_control_tower_control = { for value in local.each_control_tower_control : value.key => value }

  merged_map_each_control_tower_control = merge(local.map_each_all_control_tower_control, local.map_each_control_tower_control)


}

