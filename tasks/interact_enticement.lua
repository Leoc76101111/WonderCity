local plugin_label = 'wonder_city' -- change to your plugin name

local utils = require "core.utils"
local settings = require 'core.settings'
local tracker = require 'core.tracker'

local status_enum = {
    IDLE = 'idle',
    WALKING = 'walking to enticement',
    INTERACTING = 'interacting '
}
local task = {
    name = 'interact_enticement', -- change to your choice of task name
    status = status_enum['IDLE'],
}
local get_closest_enticement = function ()
    local local_player = get_local_player()
    if not local_player then return end
    local actors = actors_manager:get_ally_actors()
    local closest_enticement, closest_dist
    for _, actor in pairs(actors) do
        if actor:is_interactable() then
            local name = actor:get_skin_name()
            if actor:is_interactable() and (name:match('SpiritHearth_Switch') or
                name:match('X1_Undercity_Enticements_SpiritBeaconSwitch'))
            then
                local dist = utils.distance(local_player, actor)
                if dist < settings.check_distance and (closest_dist == nil or dist < closest_dist) then
                    closest_dist = dist
                    closest_enticement = actor
                end
            end
        end
    end
    return closest_enticement
end

task.shouldExecute = function ()
    return get_closest_enticement() ~= nil and
        utils.player_in_undercity()
end
task.Execute = function ()
    local local_player = get_local_player()
    if not local_player then return end
    BatmobilePlugin.pause(plugin_label)
    BatmobilePlugin.update(plugin_label)

    local enticement = get_closest_enticement()
    if enticement ~= nil then
        if utils.distance(local_player, enticement) > 3 then
            BatmobilePlugin.set_target(plugin_label, enticement)
            BatmobilePlugin.move(plugin_label)
            task.status = status_enum['WALKING']
        else
            BatmobilePlugin.clear_target(plugin_label)
            task.status = status_enum['WALKING']
            orbwalker.set_clear_toggle(false)
            interact_object(enticement)
        end
    end
end

return task