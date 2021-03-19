 
local IsChoosing = true

local cam = nil
local cam2 = nil
local function setup_character_ui()

    exports.spawnmanager:setAutoSpawn(false)

    DoScreenFadeOut(10)
    while not IsScreenFadedOut() do
        Citizen.Wait(4)
    end

    SetEntityCoords(GetPlayerPed(-1), -1047.87, -2768.70, 4.63)
    SetTimecycleModifier('hud_def_blur')
    FreezeEntityPosition(GetPlayerPed(-1), true)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1355.93,-1487.78,520.75, 300.00,0.00,0.00, 100.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(PlayerPedId()), true)
    NetworkFadeOutEntity(PlayerPedId(), true, false)
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        action = "openui",
        characters = exports["em_fw"]:get_all_characters()
    })

end

local function spawn_character(character)

    
    SetTimecycleModifier('default')
    local pos = character["position"];
    SetEntityCoords(GetPlayerPed(-1), pos.x, pos.y, pos.z)
    DoScreenFadeIn(500)
    Citizen.Wait(500)
    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1355.93,-1487.78,520.75, 300.00,0.00,0.00, 100.00, false, 0)
    PointCamAtCoord(cam2, pos.x,pos.y,pos.z+200)
    SetCamActiveWithInterp(cam2, cam, 900, true, true)
    Citizen.Wait(900)

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x,pos.y,pos.z+200, 300.00,0.00,0.00, 100.00, false, 0)
    PointCamAtCoord(cam, pos.x,pos.y,pos.z+2)
    SetCamActiveWithInterp(cam, cam2, 3700, true, true)
    SetEntityCoords(GetPlayerPed(-1), pos.x, pos.y, pos.z)
    Citizen.Wait(3700)
    PlaySoundFrontend(-1, "Zoom_Out", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1)
    RenderScriptCams(false, true, 500, true, true)
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
    FreezeEntityPosition(GetPlayerPed(-1), false)
    Citizen.Wait(500)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    IsChoosing = false
    DisplayHud(true)
    SetEntityCoords(GetPlayerPed(-1), pos.x, pos.y, pos.z)
    TriggerEvent("esx_kashacters:spawned_character")

end


local function reload_characters()

    setup_character_ui()

end

RegisterNUICallback("CharacterChosen", function(data, cb)

    SetNuiFocus(false,false)
    DoScreenFadeOut(500)

    local character = exports["em_fw"]:load_character(data["character_id"])

    while not IsScreenFadedOut() do
        Citizen.Wait(4)
    end
    spawn_character(character)


end)

RegisterNUICallback("CreateCharacter", function(data, cb)

    SetNuiFocus(false, false)
    local character_id = exports["em_fw"]:create_character(data)
    local character = exports["em_fw"]:load_character(character_id)

    spawn_character(character)

end)

RegisterNUICallback("DeleteCharacter", function(data, cb)

    SetNuiFocus(false,false)
    DoScreenFadeOut(500)

    exports["em_fw"]:delete_character(data["character_id"])

    while not IsScreenFadedOut() do
        Citizen.Wait(4)
    end
    cb("ok")
    reload_characters()

end)

RegisterNetEvent("em_fw:player_loaded")
AddEventHandler("em_fw:player_loaded", function()

    Citizen.CreateThread(function()

        Citizen.Wait(0)
        setup_character_ui()

    end)

end)
