
script.on_event(defines.events.on_player_changed_position, function(event)
  local player = game.get_player(event.player_index)
  local tile = player.surface.find_tiles_filtered(
  {
    position = player.position,
    radius = 1,
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

local ticks = settings.global["void-update-frequency"].value

script.on_nth_tick(ticks, function()
  for a,b in pairs(game.surfaces) do
    local vehicles = b.find_entities_filtered(
    {
      type = {"car", "spider-vehicle"}
    })
    for c,d in pairs(vehicles) do
      local tile = d.surface.find_tiles_filtered(
      {
        position = d.position,
        radius = 1,
        name = "out-of-map",
        limit = 1,
      })
      if tile[1] and tile[1].name == "out-of-map" then
        d.die()
      end
    end
  end
end
)
