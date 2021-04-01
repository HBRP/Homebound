
local blip_subscriptions = {}

local function get_blip_group_id(group_id)

    for i = 1, #blip_subscriptions do
        if blip_subscriptions[i].group_id == group_id then
            return blip_subscriptions[i].blip_group_id
        end
    end
    return 0

end

local function get_blip_color(group_id)

    for i = 1, #blip_subscriptions do
        if blip_subscriptions[i].group_id == group_id then
            return blip_subscriptions[i].blip_color
        end
    end
    return 0


end

local function send_character_blip_groups()

    local character_jobs = exports["em_fw"]:get_current_character_jobs()

    for i = 1, #character_jobs do

        local other_characters = {}
        if not character_jobs[i].job.clocked_in then
            goto continue
        end

        local blip_group_id = get_blip_group_id(character_jobs[i].job.group_id)
        if blip_group_id == 0 then
            goto continue
        end

        for j = 1, #character_jobs do

            local other_blip_group_id = get_blip_group_id(character_jobs[j].job.group_id)
            if other_blip_group_id == blip_group_id then

                local coords = GetEntityCoords(GetPlayerPed(character_jobs[j].source))
                table.insert(other_characters, {blip_color = get_blip_color(other_blip_group_id), x = coords.x, y = coords.y, z = coords.z, callsign = character_jobs[j].job.callsign})

            end

        end
        TriggerClientEvent("em_blips:set_blips", character_jobs[i].source, other_characters)
        ::continue::

    end

end

local function blip_group_loop()

    while true do

        Citizen.Wait(1000)
        send_character_blip_groups()

    end

end

Citizen.CreateThread(function()

    Citizen.Wait(0)
    exports["em_fw"]:get_blip_group_subscription(function(result)

        blip_subscriptions = result
        Citizen.CreateThread(blip_group_loop)

    end)

end)