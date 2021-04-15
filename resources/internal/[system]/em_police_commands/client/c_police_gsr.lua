local has_gsr = false
local disappear_time = 0

exports["em_commands"]:register_command("gsr", function(source, args, raw_command)

    if #args == 0 then
        return
    end
    local character_id = tonumber(args[1])

    exports["em_fw"]:is_character_id_in_radius_async(function(is_in_range) 

        if is_in_range then
            exports["em_fw"]:trigger_event_for_character("em_police_commands:gsr_request", character_id, exports["em_fw"]:get_character_id())
        else
            exports["t-notify"]:Alert({style="error", message = "Character isn't even around you"})
        end

    end, character_id, 5.0)

end, "Check if someone recently shot a gun", {{name = "character_id", help = "try /ids to find a character_id"}})

RegisterNetEvent("em_police_commands:gsr_request")
AddEventHandler("em_police_commands:gsr_request", function(other_character_id)

    if disappear_time < GetGameTimer() then
        has_gsr = false
    end

    exports["em_fw"]:trigger_event_for_character("em_police_commands:gsr_response", other_character_id, has_gsr)

end)

RegisterNetEvent("em_police_commands:gsr_response")
AddEventHandler("em_police_commands:gsr_response", function(gsr_positive)

    if gsr_positive then
        exports["t-notify"]:Alert({style="info", message = "tested positive for gsr"})
    else
        exports["t-notify"]:Alert({style="info", message = "tested negative for gsr"})
    end

end)

--[[
Citizen.CreateThread(function()

    while true do

        Citizen.Wait(25)
        if exports["em_items"]:is_ped_shooting_a_gun() then
            has_gsr = true
            disappear_time = GetGameTimer() + 1000 * 60 * 15
        end
        if disappear_time < GetGameTimer() then
            has_gsr = false
        end

    end

end)
]]

local running_gsr_loop = false
local function gsr_loop()

    print("in loop")
    local end_time = GetGameTimer() + 1000
    while end_time > GetGameTimer() do

        Citizen.Wait(20)
        if exports["em_items"]:is_ped_shooting_a_gun() then
            has_gsr = true
            disappear_time = GetGameTimer() + 1000 * 60 * 15
        end

        if disappear_time < GetGameTimer() then
            has_gsr = false
        end

    end
    running_gsr_loop = false

end

RegisterCommand('shoot_gun', function() 

    if running_gsr_loop then
        return
    end

    running_gsr_loop = true
    Citizen.CreateThread(gsr_loop)

end, false)

RegisterKeyMapping('shoot_gun', 'shoot_gun', 'mouse_button', 'MOUSE_LEFT')