# Control tower controls
[![Opstree Solutions][opstree_avatar]][opstree_homepage]<br/>[Opstree Solutions][opstree_homepage] 

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png
This module will help users to setting of controls on OUs
## Prerequisites
- AWS access of root account/management account of control tower with admin privilege
- Terraform
- AWS CLI
## Providers
AWS
## Note
- This module is capable for five level of organization units.
- User has to var: controltower_controls (map of object) in which key should be name of parent OU(only for first level) or name of parent OU/child OU.

## Input
| Name | Description | Type | Default | Required |
|-------|----------|------|-----|-----|
| controltower_controls | Specify controls for control tower| map(object) | - | yes |
| all_control_lists | List of all controls which will be used | map(string) | null | no |

## Usage
```hcl
module "control" {
  source                = "../modules/controltower_controls"
  controltower_controls = var.controltower_controls
  all_control_lists     = var.all_control_lists
}

# Variables
variable "controltower_controls" {
  type = map(object({
    all_controls          = optional(bool, false)
    specific_controls     = optional(map(string), {})
    not_specific_controls = optional(map(string), {})
  }))
  default = {
    "parent_OU_name/child_OU_name" = {
      all_controls = true
      specific_controls = {
        "name of API controlIdentifier" = "Description about control"
      }
      not_specific_controls = {
        "name of API controlIdentifier" = "Description about control"       
      }
    }
  }
}

variable "all_control_lists" {
  type = map(string)
  default = {
        "name of API controlIdentifier" = "Description about control"    
  }
```
## Contributor
[Ashutosh Yadav](https://github.com/ashutoshyadav66)
