 
local IsChoosing = true
DisplayRadar(false)

local function wait_for_characters()

    DoScreenFadeOut(10)
    while not IsScreenFadedOut() do
        Citizen.Wait(4)
    end

    FreezeEntityPosition(GetPlayerPed(-1), true)

    while not exports["afw"]:characters_were_init() do
        Citizen.Wait(100)
    end

end

local function setup_character_ui()

    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(PlayerPedId()), true)
    NetworkFadeOutEntity(PlayerPedId(), true, false)
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        action = "openui",
        characters = exports["afw"]:get_all_characters(),
    })

end

RegisterNetEvent('kashactersC:SpawnCharacter')
AddEventHandler('kashactersC:SpawnCharacter', function(pos, isnew)
    
    TriggerServerEvent('es:firstJoinProper')
    TriggerEvent('es:allowedToSpawn')

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
    exports.arp:SetActivePed(PlayerPedId())
    TriggerEvent('kashacters:PlayerSpawned', isnew)

end)

local function reload_characters()

    exports["afw"]:init_all_characters()
    wait_for_characters()
    setup_character_ui()

end

RegisterNUICallback("CharacterChosen", function(data, cb)

    SetNuiFocus(false,false)
    DoScreenFadeOut(500)

    exports["afw"]:load_character(data["character_id"])

    while not IsScreenFadedOut() do
        Citizen.Wait(4)
    end
    cb("ok")

end)

RegisterNUICallback("DeleteCharacter", function(data, cb)

    SetNuiFocus(false,false)
    DoScreenFadeOut(500)

    exports["afw"]:delete_character(data["character_id"])

    while not IsScreenFadedOut() do
        Citizen.Wait(4)
    end
    cb("ok")
    reload_characters()

end)


Citizen.CreateThread(function()

    Citizen.Wait(5)
    while not NetworkIsSessionStarted() do
        Citizen.Wait(100)
    end

    wait_for_characters()
    setup_character_ui()

end)