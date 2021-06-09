local ESX = nil


register_clock_in_station("usmarshal", -577.49, -199.45, 42)
register_clock_in_station("offusmarshal", -577.49, -199.45, 42)
register_locker("usmarshal", "USMS Supply Locker", -573.67, -199.86, 42)
register_locker("usmarshal", "USMS Evidence Locker", -583.04, -203.34, 42)
register_locker_for_grade(1600, "USMS Supply Locker - Director", -583.86, -214.34, 42)

local marshal_clocked_in = false
local CARBINE_MK2_HASH       = GetHashKey('WEAPON_CARBINERIFLE_MK2')
local CARBINE_MK2_GRIP_HASH  = GetHashKey('COMPONENT_AT_AR_AFGRIP_02')
local CARBINE_MK2_SCOPE_HASH = GetHashKey('COMPONENT_AT_SCOPE_MACRO_MK2')
local CARBINE_MK2_FLASH_HASH = GetHashKey('COMPONENT_AT_AR_FLSH')
local CARBINE_MK2_MUZZLE_HASH = GetHashKey('COMPONENT_AT_MUZZLE_04')


local function give_marshal_components()

    local PLAYER_PED = PlayerPedId()
    if not HasPedGotWeaponComponent(PLAYER_PED, CARBINE_MK2_HASH, CARBINE_MK2_GRIP_HASH) then
        GiveWeaponComponentToPed(PLAYER_PED, CARBINE_MK2_HASH, CARBINE_MK2_GRIP_HASH)
        GiveWeaponComponentToPed(PLAYER_PED, CARBINE_MK2_HASH, CARBINE_MK2_SCOPE_HASH)
        GiveWeaponComponentToPed(PLAYER_PED, CARBINE_MK2_HASH, CARBINE_MK2_FLASH_HASH)
        GiveWeaponComponentToPed(PLAYER_PED, CARBINE_MK2_HASH, CARBINE_MK2_MUZZLE_HASH)
    end

end

RegisterNetEvent('usmarshal_clock_in')
AddEventHandler('usmarshal_clock_in', function()

    marshal_clocked_in = true

    give_marshal_components()
    Citizen.CreateThread(function() 

        while marshal_clocked_in do

            Citizen.Wait(5000)
            give_marshal_components()
            
        end

    end)

    TriggerEvent('ascension_pager:SubscribeToGroup', 'police')
    SetPedArmour(PlayerPedId(), 100)

end)

RegisterNetEvent('usmarshal_clock_off')
AddEventHandler('usmarshal_clock_off', function()

    TriggerEvent('ascension_pager:UnsubscribeFromGroup', 'police')
    SetPedArmour(PlayerPedId(), 0)
    marshal_clocked_in = false

end)

function IsMarshal()

    assert(ESX ~= nil)
    return ESX.GetPlayerData().job.name == "usmarshal"

end

AddEventHandler("kashacters:PlayerSpawned", function ()

    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    
end)