CurrentWeather = 'EXTRASUNNY'
local lastWeather = CurrentWeather
local baseTime = 0
local timeOffset = 0
local timer = 0
local freezeTime = false
local blackout = false

RegisterNetEvent('vSync:updateWeather')
AddEventHandler('vSync:updateWeather', function(NewWeather, newblackout)
    CurrentWeather = NewWeather
    blackout = newblackout
end)

Citizen.CreateThread(function()
    while true do
        if lastWeather ~= CurrentWeather then
            lastWeather = CurrentWeather
            SetWeatherTypeOverTime(CurrentWeather, 15.0)
            Citizen.Wait(15000)
        end
        Citizen.Wait(100) -- Wait 0 seconds to prevent crashing.
        SetBlackout(blackout)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(lastWeather)
        SetWeatherTypeNow(lastWeather)
        SetWeatherTypeNowPersist(lastWeather)
        if lastWeather == 'XMAS' then
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
        else
            SetForceVehicleTrails(false)
            SetForcePedFootstepsTracks(false)
        end
    end
end)

RegisterNetEvent('vSync:updateTime')
AddEventHandler('vSync:updateTime', function(base, offset, freeze)
    freezeTime = freeze
    timeOffset = offset
    baseTime = base
end)

Citizen.CreateThread(function()
    local hour = 0
    local minute = 0
    while true do
        Citizen.Wait(0)
        local newBaseTime = baseTime
        if GetGameTimer() - 500  > timer then
            newBaseTime = newBaseTime + 0.25
            timer = GetGameTimer()
        end
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime			
        end
        baseTime = newBaseTime
        hour = math.floor(((baseTime+timeOffset)/60)%24)
        minute = math.floor((baseTime+timeOffset)%60)
        NetworkOverrideClockTime(hour, minute, 0)
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('vSync:requestSync')
end)

-- Display a notification above the minimap.
function ShowNotification(text, blink)
    if blink == nil then blink = false end
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(blink, false)
end

RegisterNetEvent('vSync:notify')
AddEventHandler('vSync:notify', function(message, blink)
    ShowNotification(message, blink)
end)

exports["em_commands"]:register_command("freezetime", function(source, args, raw_command)

    TriggerServerEvent("vsync:freezetime")

end, 'Freeze / unfreeze time.')

exports["em_commands"]:register_command("freezeweather", function(source, args, raw_command)

    TriggerServerEvent("vsync:freezeweather")

end, 'Enable/disable dynamic weather changes.')

exports["em_commands"]:register_command("weather", function(source, args, raw_command)

    TriggerServerEvent("vsync:weather", args)

end, 'Change the weather.', {{ name="weatherType", help="Available types: extrasunny, clear, neutral, smog, foggy, overcast, clouds, clearing, rain, thunder, snow, blizzard, snowlight, xmas & halloween"}})

exports["em_commands"]:register_command("blackout", function(source, args, raw_command)

    TriggerServerEvent("vsync:blackout")

end, 'Toggle blackout mode.')

exports["em_commands"]:register_command("morning", function(source, args, raw_command)

    TriggerServerEvent("vsync:morning")

end, 'Set the time to 09:00')

exports["em_commands"]:register_command("noon", function(source, args, raw_command)

    TriggerServerEvent("vsync:noon")

end, 'Set the time to 12:00')

exports["em_commands"]:register_command("evening", function(source, args, raw_command)

    TriggerServerEvent("vsync:evening")

end, 'Set the time to 18:00')

exports["em_commands"]:register_command("night", function(source, args, raw_command)

    TriggerServerEvent("vsync:night")

end, 'Set the time to 23:00')

exports["em_commands"]:register_command("time", function(source, args, raw_command)

    TriggerServerEvent("vsync:time", args)

end, 'Change the time.', {{ name="hours", help="A number between 0 - 23"}, { name="minutes", help="A number between 0 - 59"}})