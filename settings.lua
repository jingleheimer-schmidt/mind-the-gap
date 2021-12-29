--
-- local updateFrequency = {
--   type = "int-setting",
--   name = "void-update-frequency",
--   setting_type = "runtime-global",
--   default_value = 60,
--   minimum_value = 1,
-- }

local updateFrequency = {
  type = "string-setting",
  name = "void-update-frequency",
  setting_type = "runtime-global",
  default_value = "60-ticks",
  allowed_values = {
    "disabled",
    "10-ticks",
    "30-ticks",
    "60-ticks",
    "120-ticks",
    "240-ticks",
    "480-ticks"
  }
}

data:extend({
  updateFrequency
})
