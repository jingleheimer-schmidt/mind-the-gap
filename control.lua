
script.on_event(defines.events.on_player_changed_position, function(event)
  local player = game.get_player(event.player_index)
  local bounding_box = {}
  if player.character then
    bounding_box = player.character.bounding_box
  elseif player.vehicle then
    bounding_box = player.vehicle.bounding_box
  else
    return
  end
  local tile = player.surface.find_tiles_filtered(
  {
    -- position = player.position,
    -- radius = 1,
    area = bounding_box,
    name = "out-of-map",
    limit = 1,
  })
  if tile[1] and tile[1].name == "out-of-map" then
    if player.vehicle then
      player.vehicle.die()
    end
    if player.character then
      player.character.die("neutral", player.character)
    end
  end
end
)

local update_frequencies = {
  ["disabled"] = 9999999999999999999,
  ["10-ticks"] = 1,
  ["30-ticks"] = 3,
  ["60-ticks"] = 6,
  ["120-ticks"] = 12,
  ["240-ticks"] = 24,
  ["480-ticks"] = 48,
}

script.on_nth_tick(10, function()
  if not global.counter then
    global.counter = 1
  end
  local frequency = settings.global["void-update-frequency"].value
  if frequency == "disabled" then
    return
  elseif global.counter < update_frequencies[frequency] then
    global.counter = global.counter + 1
  else
    for unit_number, vehicle in pairs(global.vehicles) do
      if not vehicle.valid then
        global.vehicles[unit_number] = nil
      else
        local tile = vehicle.surface.find_tiles_filtered({
          area = vehicle.bounding_box,
          name = "out-of-map"
        })
        if tile[1] then
          vehicle.die()
        end
      end
    end
    global.counter = 1
  end
end
)

if not global.vehicles then
  global.vehicles = {}
end

script.on_init(function()
  for every, surface in pairs(game.surfaces) do
    for each, vehicle in pairs(surface.find_entities_filtered{type={"car","spider-vehicle"}}) do
      if not global.vehicles then
        global.vehicles = {}
      end
      global.vehicles[vehicle.unit_number] = vehicle
    end
  end
end)

script.on_configuration_changed(function()
  for every, surface in pairs(game.surfaces) do
    for each, vehicle in pairs(surface.find_entities_filtered{type={"car","spider-vehicle"}}) do
      if not global.vehicles then
        global.vehicles = {}
      end
      global.vehicles[vehicle.unit_number] = vehicle
    end
  end
end)

function on_built(event)
  local entity = event.created_entity or event.entity or event.destination
  if entity.type == "car" or entity.type == "spider-vehicle" then
    global.vehicles[entity.unit_number] = entity
  end
end

script.on_event(defines.events.on_built_entity, on_built)
script.on_event(defines.events.on_entity_cloned, on_built)
script.on_event(defines.events.on_robot_built_entity, on_built)
script.on_event(defines.events.script_raised_built, on_built)
script.on_event(defines.events.script_raised_revive, on_built)
