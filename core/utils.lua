local tracker = require 'core.tracker'

local utils    = {
    settings = {},
}
utils.player_in_zone = function (zname)
    return get_current_world():get_current_zone_name() == zname
end
utils.player_in_undercity = function ()
    return get_current_world():get_current_zone_name():match('X1_Undercity_')
end
utils.is_looting = function ()
    if LooteerPlugin then
        return LooteerPlugin.getSettings('looting')
    end
    return false
end
utils.get_spirit_brazier = function ()
    local actors = actors_manager:get_ally_actors()
    for _, actor in pairs(actors) do
        local actor_name = actor:get_skin_name()
        if actor_name == 'Aubrie_Test_Undercity_Crafter' then
            return actor
        end
    end
    return nil
end
utils.get_entrance_portal = function ()
    local actors = actors_manager:get_ally_actors()
    for _, actor in pairs(actors) do
        if actor:is_interactable() then
            local actor_name = actor:get_skin_name()
            if actor_name == 'Portal_Dungeon_Undercity' then
                return actor
            end
        end
    end
    return nil
end
utils.undercity_done = function ()
    local actors = actors_manager:get_ally_actors()
    for _, actor in pairs(actors) do
        local actor_name = actor:get_skin_name()
        if actor_name:match('X1_Undercity_Chest_Attunement') then
            return actor
        end
    end
    return nil
end
utils.distance = function (a, b)
    if a.get_position then a = a:get_position() end
    if b.get_position then b = b:get_position() end
    local dx = math.abs(a:x() - b:x())
    local dy = math.abs(a:y() - b:y())
    return math.max(dx, dy) + (math.sqrt(2) - 1) * math.min(dx, dy)
end

return utils