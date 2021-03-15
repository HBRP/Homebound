local disPlayerNames = 5
local playerDistances = {}

local function DrawText3D(position, text, r,g,b) 
    local onScreen,_x,_y=World3dToScreen2d(position.x,position.y,position.z+1)
    local dist = #(GetGameplayCamCoords()-position)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        if not useCustomScale then
            SetTextScale(0.0*scale, 0.55*scale)
        else 
            SetTextScale(0.0*scale, customScale)
        end
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

local end_time = 0
local function draw_character_ids()

    Citizen.Wait(500)
    while end_time > GetGameTimer() do
        for _, id in ipairs(GetActivePlayers()) do
            local targetPed = GetPlayerPed(id)
            if playerDistances[id] then
                if playerDistances[id].distance < disPlayerNames then
                    local targetPedCords = GetEntityCoords(targetPed)
                    DrawText3D(targetPedCords, playerDistances[id].character_id, 255,255,255)
                end
            end
        end
        Citizen.Wait(0)
    end

end

local function set_player_coords()

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    playerDistances = {}

    local server_ids = {}
    for _, id in ipairs(GetActivePlayers()) do

        local targetPed = GetPlayerPed(id)
        local distance = #(playerCoords - GetEntityCoords(targetPed))
        local server_id = GetPlayerServerId(id)
        table.insert(server_ids, server_id)
        playerDistances[id] = {distance = distance, server_id = server_id}

    end

    local character_ids = exports["em_fw"]:get_target_character_id_batch(server_ids)
    for k, v in pairs(playerDistances) do
        for i = 1, #character_ids do
            if v.server_id == character_ids[i].source then
                playerDistances[k].character_id = character_ids[i].character_id
            end
        end
    end

end

exports["em_commands"]:register_command("ids", function(source, args, raw) 

    end_time = GetGameTimer() + 5000
    set_player_coords()
    Citizen.CreateThread(draw_character_ids)

end, "Show Character id's on people heads.")