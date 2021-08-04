
local context_functions = {}
local multi_context_functions = {}
local always_checked_context_functions = {}
local always_checked_multi_context_functions = {}

function register_context(name, callback)

    for i = 1, #context_functions do

        if context_functions[i].name == name then
            Citizen.Trace(string.format("Replacing context %s\n", name))
            context_functions[i].callback = callback
            return
        end

    end
    table.insert(context_functions, {name = name, callback = callback})

end

function register_multi_context(name, callback)

    for i = 1, #multi_context_functions do

        if multi_context_functions[i].name == name then
            Citizen.Trace(string.format("Replacing multi context %s\n", name))
            multi_context_functions[i].callback = callback
            return
        end

    end
    table.insert(multi_context_functions, {name = name, callback = callback})

end

function register_always_checked_context(name, callback)

    for i = 1, #always_checked_context_functions do

        if always_checked_context_functions[i].name == name then
            Citizen.Trace(string.format("Replacing always checked context %s\n", name))
            always_checked_context_functions[i].callback = callback
            return
        end

    end
    table.insert(always_checked_context_functions, {name = name, callback = callback})

end

function register_always_checked_multi_context(name, callback)

    for i = 1, #always_checked_multi_context_functions do

        if always_checked_multi_context_functions[i].name == name then
            Citizen.Trace(string.format("Replacing always checked multi context %s\n", name))
            always_checked_multi_context_functions[i].callback = callback
            return
        end

    end
    table.insert(always_checked_multi_context_functions, {name = name, callback = callback})

end


local function build_context_menu()

    local context_dialog = {}
    local nearby_garage  = exports["em_dal"]:get_nearby_garage()

    local vehicle_context = take_out_vehicle(nearby_garage)
    if vehicle_context ~= nil then
        table.insert(context_dialog, vehicle_context)
    end

    local return_context = return_vehicle(nearby_garage)
    if return_context ~= nil then
        table.insert(context_dialog, return_context)
    end

    return context_dialog

end

local function get_context_if_exists(funcs, context_name)

    for i = 1, #funcs do
        if funcs[i].name == context_name then
            return funcs[i].callback()
        end
    end

    return nil

end

local function setup_context()

    exports["em_dal"]:get_context_async(function(results) 

        local context_dialog = build_context_menu()

        for i = 1, #results do

            local context = get_context_if_exists(context_functions, results[i].context_name)
            if context ~= nil then
                table.insert(context_dialog, context)
            end

            local context = get_context_if_exists(multi_context_functions, results[i].context_name)
            if context ~= nil then
                for j = 1, #context do
                    table.insert(context_dialog, context[j])
                end
            end

        end

        for i = 1, #always_checked_context_functions do
            local context = always_checked_context_functions[i].callback()
            if context ~= nil then
                table.insert(context_dialog, context)
            end
        end

        for i = 1, #always_checked_multi_context_functions do
            local context = always_checked_multi_context_functions[i].callback()
            if context ~= nil then
                for j = 1, #context do
                    table.insert(context_dialog, context[i])
                end
            end
        end

        if #context_dialog == 0 then

            table.insert(context_dialog, {
                dialog = "[Nothing to do]",
                callback = function()
                    exports["em_dialog"]:hide_dialog()
                end
            })

        end
        
        exports["em_dialog"]:show_dialog("Context Menu", context_dialog)

    end)

end

RegisterCommand('context_menu', setup_context, false)
RegisterKeyMapping('context_menu', 'context_menu', 'keyboard', 'F4')