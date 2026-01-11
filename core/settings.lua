local gui = require 'gui'

local settings = {
    plugin_label = gui.plugin_label,
    plugin_version = gui.plugin_version,
    enabled = false,
    reset_timeout = 600,
    exit_undercity_delay = 10,
    party_enabled = false,
    party_mode = 0,
    confirm_delay = 5,
    use_magoogle_tool = false,
    check_distance = 16,
    follower_explore = false,
    boss_delay = 0,
    loot_obols = true,
    beacon_timeout = 15,
    enticement_timeout = 5,
}

settings.get_keybind_state = function ()
    local toggle_key = gui.elements.keybind_toggle:get_key();
    local toggle_state = gui.elements.keybind_toggle:get_state();
    local use_keybind = gui.elements.use_keybind:get()
    -- If not using keybind, skip
    if not use_keybind then
        return true
    end

    if use_keybind and toggle_key ~= 0x0A and toggle_state == 1 then
        return true
    end
    return false
end

settings.update_settings = function ()
    settings.enabled = gui.elements.main_toggle:get()
    settings.reset_timeout = gui.elements.reset_timeout:get()
    settings.exit_undercity_delay = gui.elements.exit_undercity_delay:get()
    settings.party_enabled = gui.elements.party_enabled:get()
    settings.party_mode = gui.elements.party_mode:get()
    settings.confirm_delay = gui.elements.confirm_delay:get()
    settings.use_magoogle_tool = gui.elements.use_magoogle_tool:get()
    settings.follower_explore = gui.elements.follower_explore:get()
    settings.boss_delay = gui.elements.boss_delay:get()
    settings.loot_obols = gui.elements.loot_obols:get()
    settings.beacon_timeout = gui.elements.beacon_timeout:get()
    settings.enticement_timeout = gui.elements.enticement_timeout:get()

end

return settings