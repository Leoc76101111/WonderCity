local plugin_label = 'wonder_city' -- change to your plugin name

local utils = require "core.utils"
local settings = require 'core.settings'
local tracker = require 'core.tracker'

local status_enum = {
    IDLE = 'idle',
    WALKING = 'walking to enticement',
    INTERACTING = 'interacting with enticement',
    WAITING = 'waiting at enticement '
}
local task = {
    name = 'interact_enticement', -- change to your choice of task name
    status = status_enum['IDLE'],
    interact_time = nil
}
local get_closest_enticement = function ()
    local local_player = get_local_player()
    if not local_player then return end
    local actors = actors_manager:get_ally_actors()
    local closest_enticement, closest_dist
    for _, actor in pairs(actors) do
        local name = actor:get_skin_name()
        if (name:match('SpiritHearth_Switch') or
            name:match('X1_Undercity_Enticements_SpiritBeaconSwitch'))
        then
            local actor_pos = actor:get_position()
            local actor_coord = tostring(actor_pos:x()) .. ',' .. tostring(actor_pos:y())
            local dist = utils.distance(local_player, actor)
            if tracker.enticement[actor_coord] == nil and
                (closest_dist == nil or dist < closest_dist)
            then
                closest_dist = dist
                closest_enticement = actor
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
        BatmobilePlugin.set_target(plugin_label, enticement)
        BatmobilePlugin.move(plugin_label)
        if utils.distance(local_player, enticement) > 3 then
            task.status = status_enum['WALKING']
        else
            BatmobilePlugin.clear_target(plugin_label)
            local is_switch = enticement:get_skin_name():match('SpiritHearth_Switch')
            local timeout = settings.enticement_timeout
            if not is_switch then
                timeout = settings.beacon_timeout
            end
            local timed_out = task.interact_time ~= nil and
                task.interact_time + timeout < get_time_since_inject()
            if enticement:is_interactable() then
                orbwalker.set_clear_toggle(false)
                interact_object(enticement)
                task.status = status_enum['INTERACTING']
            elseif timed_out then
                local enticement_pos = enticement:get_position()
                local enticement_coord = tostring(enticement_pos:x()) ..
                    ',' .. tostring(enticement_pos:y())
                tracker.enticement[enticement_coord] = true
                task.interact_time = nil
                task.status = status_enum['IDLE']
            elseif task.interact_time == nil then
                task.interact_time = get_time_since_inject()
                console.print(task.interact_time)
                orbwalker.set_clear_toggle(true)
            else
                orbwalker.set_clear_toggle(true)
                local remaining = task.interact_time + timeout - get_time_since_inject()
                local timer = '(' .. string.format('%.2f', remaining) .. 's)'
                task.status = status_enum['WAITING'] .. timer
            end
        end
    end
end

return task