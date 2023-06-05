variable "controltower_controls" {
  type = map(object({
    all_controls          = optional(bool, false)
    specific_controls     = optional(map(string), {})
    not_specific_controls = optional(map(string), {})
  }))
  description = "Define Control Tower controls for Organization units"
}


variable "all_control_lists" {
  type = map(string)
  default = null
  description = "All controls for Control Tower"
}