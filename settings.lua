
local updateFrequency = {
  type = "int-setting",
  name = "void-update-frequency",
  setting_type = "runtime-global",
  default_value = 60,
  minimum_value = 1,
}

data:extend({
  updateFrequency
})
