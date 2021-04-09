
local function animate_fast_pullout()

    local dict = "move_m@intimidation@cop@unarmed"

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end

    TaskPlayAnim(PlayerPedId(), dict, "idle", 8.0, 8.0, 750, 2 + 16 + 32, 1.0, 0, 0, 0)
    Citizen.Wait(750)
    TaskPlayAnim(PlayerPedId(), dict, "idle", 8.0, 8.0, 0, 16 + 32, 1.0, 0, 0, 0)

end

local function animate_normal_pullout()

    local dict = "reaction@intimidation@1h"

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end

    if intro then
        TaskPlayAnimAdvanced(GetPlayerPed(-1), dict, "intro", GetEntityCoords(PlayerPedId(), true), 0, 0, GetEntityHeading(PlayerPedId()), 8.0, 3.0, -1, 50, 0, 0, 0)
    else
        TaskPlayAnimAdvanced(GetPlayerPed(-1), dict, "outro", GetEntityCoords(PlayerPedId(), true), 0, 0, GetEntityHeading(PlayerPedId()), 8.0, 3.0, -1, 50, 0, 0, 0)
    end

    Citizen.Wait(2000)
    ClearPedTasks(PlayerPedId())

end

function animate_weapon_pullout(item_id, intro)

    if exports["em_jobs"]:can_fast_draw() and get_weapon_type(item_id) == item_weapon_type_ids.HANDGUN then
        animate_fast_pullout(intro)
    else
        animate_normal_pullout(intro)
    end

end