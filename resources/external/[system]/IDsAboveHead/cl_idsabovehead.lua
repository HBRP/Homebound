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
    while end_time < GetGameTimer() do
        for _, id in ipairs(GetActivePlayers()) do
            local targetPed = GetPlayerPed(id)
            if targetPed ~= PlayerPedId() then
                if playerDistances[id] then
                    if playerDistances[id].distance < disPlayerNames then
                        local targetPedCords = GetEntityCoords(targetPed)
                        DrawText3D(targetPedCords, playerDistances[id].character_id , 255,255,255)
                    end
                end
            end
        end
        Citizen.Wait(0)
    end

end

local function set_player_coords()

    while end_time < GetGameTimer() do

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        playerDistances = {}

        for _, id in ipairs(GetActivePlayers()) do
            local targetPed = GetPlayerPed(id)
            if targetPed ~= playerPed then
                local distance = #(playerCoords - GetEntityCoords(targetPed))
                playerDistances[id] = {distance = distance, character_id = get_target_character_id(GetPlayerServerId(id))}
            end
        end
        Citizen.Wait(1000)
    end

end

exports["em_commands"]:register_command("ids", function(source, args, raw) 

    end_time = GetGameTimer() + 5000
    Citizen.CreateThread(set_player_coords)
    Citizen.CreateThread(draw_character_ids)

end, "Show Character id's on people heads.")