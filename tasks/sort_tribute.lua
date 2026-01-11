local plugin_label = 'wonder_city' -- change to your plugin name


local status_enum = {
    IDLE = 'idle',
}
local task = {
    name = 'sort_tribute', -- change to your choice of task name
    status = status_enum['IDLE']
}
task.shouldExecute = function ()
    return true
end
task.Execute = function () end

return task