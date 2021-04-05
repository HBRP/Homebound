

local menu = MenuV:CreateMenu('Teleporters', 'Select landing', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', 'teleporter', 'native')

local function open_selected_teleporter(teleporter)

    exports["em_fw"]:get_teleporter_options_async(function(options)

        menu:ClearItems()
        for i = 1, #options do
            local button = menu:AddButton({label = options[i].teleporter_option_name, value = menu, description = options[i].teleporter_option_name })
            button:On('select', function(item)
                SetEntityCoords(PlayerPedId(), options[i].x, options[i].y, options[i].z+0.05)
                menu:Close()
            end)
        end
        MenuV:OpenMenu(menu)

    end, teleporter.teleporter_point_id)

end

local function refresh_loop(refresh_func)

    exports["em_fw"]:get_nearby_teleporter_points_async(refresh_func)

end

local function text(teleporter)

    return string.format("Press [E] to use %s", teleporter.teleporter_name)

end

AddEventHandler("em_fw:character_loaded", function()

    exports["em_points"]:register_points(refresh_loop, text, open_selected_teleporter)
    
end)