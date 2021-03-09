 
local IsChoosing = true
DisplayRadar(false)

local function setup_character_ui()

    exports.spawnmanager:setAutoSpawn(false)

    DoScreenFadeOut(10)
    while not IsScreenFadedOut() do
        Citizen.Wait(4)
    end

    FreezeEntityPosition(GetPlayerPed(-1), true)

    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(PlayerPedId()), true)
    NetworkFadeOutEntity(PlayerPedId(), true, false)
    DoScreenFadeIn(10)
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        action = "openui",
        characters = exports["em_fw"]:get_all_characters()
    })

end

RegisterNetEvent('kashactersC:SpawnCharacter')
AddEventHandler('kashactersC:SpawnCharacter', function(pos, isnew)
    
    exports.spawnmanager:setAutoSpawn(false)
	
    if isnew then
        TriggerEvent('esx_identity:showRegisterIdentity')
        TriggerServerEvent("arpit:PlayerFirstJoin")
        SetEntityCoords(GetPlayerPed(-1), (math.random(22175, 22185) * -0.01),(math.random(104900, 105500) * -0.01), 30.2)

    end

    PlaySoundFrontend(-1, "Zoom_Out", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1)
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)


    IsChoosing = false
    DisplayRadar(false)
    FreezeEntityPosition(GetPlayerPed(-1), false)

    DoScreenFadeOut(500)
    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(PlayerPedId()), true)
    SetEntityAlpha(PlayerPedId(), 0)
    NetworkFadeInEntity(PlayerPedId(), 0)
    ShutdownLoadingScreenNui()
    SendLoadingScreenMessage(json.encode(
        {
            eventName = "fadeOutVideo"
        }
    ))
    Wait(2300) 
    DoScreenFadeIn(500)
    TriggerEvent('kashacters:PlayerSpawned', isnew)

end)

local function spawn_character(character)

end


local function reload_characters()

    setup_character_ui()

end

RegisterNUICallback("CharacterChosen", function(data, cb)

    SetNuiFocus(false,false)
    DoScreenFadeOut(500)

    exports["em_fw"]:load_character(data["character_id"])

    while not IsScreenFadedOut() do
        Citizen.Wait(4)
    end
    cb("ok")

end)

RegisterNUICallback("CreateCharacter", function(data, cb)

    SetNuiFocus(false, false)
    local character_id = exports["em_fw"]:create_character(data)

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

        Citizen.Wait(5)
        setup_character_ui()

    end)

end)
