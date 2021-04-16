
local function build_context_menu()

    local context_dialog = {}
    local nearby_garage  = exports["em_fw"]:get_nearby_garage()

    local vehicle_context = take_out_vehicle(nearby_garage)
    if vehicle_context ~= nil then
        table.insert(context_dialog, vehicle_context)
    end

    local return_context = return_vehicle(nearby_garage)
    if return_context ~= nil then
        table.insert(context_dialog, return_context)
    end

    if #context_dialog == 0 then

        table.insert(context_dialog, {
            dialog = "[Nothing nearby]",
            callback = function()
                exports["em_dialog"]:hide_dialog()
            end
        })

    end

    return context_dialog

end

local function setup_context()

    local context_dialog = build_context_menu()
    exports["em_dialog"]:show_dialog("Context Menu", context_dialog)

end

RegisterCommand('context_menu', setup_context, false)
RegisterKeyMapping('context_menu', 'context_menu', 'keyboard', 'F4')