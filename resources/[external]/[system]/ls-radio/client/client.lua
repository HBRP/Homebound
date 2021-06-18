
--===============================================================================
--=== Stworzone przez Alcapone aka suprisex. Zakaz rozpowszechniania skryptu! ===
--===================== na potrzeby LS-Story.pl =================================
--===============================================================================



local radioMenu = false
local current_radio_channel = nil

function PrintChatMessage(text)
    TriggerEvent('chatMessage', "system", { 255, 0, 0 }, text)
end



function enableRadio(enable)

  SetNuiFocus(true, true)
  radioMenu = enable

  SendNUIMessage({

    type = "enableui",
    enable = enable

  })

end

exports["em_commands"]:register_command("test_radio", function(source, args, raw_command)

  enableRadio(true)

end, "Test the radio!")

exports["em_items"]:register_item_use("radio", function()

  enableRadio(true)

end)


local function can_join_restricted_channel()

  return exports["em_dal"]:can_do_action("encrypted_radio")

end

RegisterNUICallback('joinRadio', function(data, cb)
    local _source = source
    local playerName = GetPlayerName(PlayerId())
    local channel = tonumber(data.channel)

      if channel <= Config.RestrictedChannels then

        if can_join_restricted_channel() then

          current_radio_channel = channel
          exports["pma-voice"]:removePlayerFromRadio()
          exports["pma-voice"]:setRadioChannel(channel)
          exports["pma-voice"]:addPlayerToRadio(channel)
          exports["pma-voice"]:setVoiceProperty("micClicks", true)
          exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
          exports["t-notify"]:Alert({style = "info", message = Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz'})

        else

          current_radio_channel = nil
          exports["t-notify"]:Alert({style = "info", message = Config.messages['restricted_channel_error']})

        end

      elseif channel > Config.RestrictedChannels then

        current_radio_channel = channel
        exports["pma-voice"]:removePlayerFromRadio()
        exports["pma-voice"]:setRadioChannel(channel)
        exports["pma-voice"]:addPlayerToRadio(channel)
        exports["pma-voice"]:setVoiceProperty("micClicks", true)
        exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
        exports["t-notify"]:Alert({style = "info", message = Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz'})

      end
    cb('ok')
end)

RegisterNUICallback('leaveRadio', function(data, cb)

  if current_radio_channel ~= nil then

    exports["pma-voice"]:removePlayerFromRadio()
    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
    exports["t-notify"]:Alert({style = "info", message = Config.messages['you_leave'] .. current_radio_channel .. '.00 MHz'})
    current_radio_channel = channel

  end

  cb('ok')

end)

RegisterNUICallback('escape', function(data, cb)

    enableRadio(false)
    SetNuiFocus(false, false)
    cb('ok')

end)

-- net eventy

RegisterNetEvent('ls-radio:use')
AddEventHandler('ls-radio:use', function()
  enableRadio(true)
end)

AddEventHandler("em_dal:inventory_change", function()

  if current_radio_channel == nil then
    return
  end

  if exports["em_items"]:has_item_by_name("radio") then
    return
  end

  exports["pma-voice"]:removePlayerFromRadio()
  exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
  exports['t-notify']:Alert({style = info, message = Config.messages['you_leave'] .. current_radio_channel .. '.00 MHz'})

end)

Citizen.CreateThread(function()
    while true do
        if radioMenu then
            DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
            DisableControlAction(0, 2, guiEnabled) -- LookUpDown

            DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlternate

            DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride

            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({
                    type = "click"
                })
            end
        end
        Citizen.Wait(0)
    end
end)
