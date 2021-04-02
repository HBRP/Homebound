 
local IsChoosing = true

local cam = nil
local cam2 = nil
local function setup_character_ui()

    exports.spawnmanager:setAutoSpawn(false)
    SetEntityCoords(GetPlayerPed(-1), -1047.87, -2768.70, 4.63)
    FreezeEntityPosition(GetPlayerPed(-1), true)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -416.47, 5916.21, 250.0, 1.229*57.0, 0.0, 2.98*57.0, 100.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(PlayerPedId()), true)
    NetworkFadeOutEntity(PlayerPedId(), true, false)
    
    SendNUIMessage({
        action = "openui",
        characters = exports["em_fw"]:get_all_characters()
    })
    SetNuiFocus(true, true)

end

local function spawn_character(character)

    local pos = character["position"];
    SetEntityCoords(GetPlayerPed(-1), pos.x, pos.y, pos.z)
    Citizen.Wait(500)
    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",  -416.47, 5916.21, 250.0, 1.229*57.0, 0.0, 2.98*57.0, 100.00, false, 0)
    PointCamAtCoord(cam2, pos.x,pos.y,pos.z+200)
    SetCamActiveWithInterp(cam2, cam, 900, true, true)
    Citizen.Wait(900)

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x,pos.y,pos.z+200.0, 1.229*57.0, 0.0, 2.98*57.0, 100.00, false, 0)
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
    local character = exports["em_fw"]:load_character(data["character_id"])
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
    exports["em_fw"]:delete_character(data["character_id"])
    cb("ok")
    reload_characters()

end)

RegisterNetEvent("em_fw:player_loaded")
AddEventHandler("em_fw:player_loaded", function()

    Citizen.Wait(1000)
    setup_character_ui()

end)

SetNuiFocus(true, true)