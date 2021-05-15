
local function open_full_customization()

    exports['fivem-appearance']:setPlayerModel("mp_m_freemode_01")
    Citizen.Wait(500)
    local config = {
        ped = true,
        headBlend = true,
        faceFeatures = true,
        headOverlays = true,
        components = true,
        props = true,
    }

    exports['fivem-appearance']:startPlayerCustomization(function(appearance)
        if (appearance) then

            exports["em_dal"]:create_skin(json.encode(appearance))
            local outfit = {
                ped_components = exports["fivem-appearance"]:getPedComponents(),
                props = exports["fivem-appearance"]:getPedProps()
            }

        else
            open_full_customization()
        end
    end, config)


end

AddEventHandler("esx_kashacters:spawned_character", function()

    local skin = exports["em_dal"]:get_skin()
    if skin == nil then
        open_full_customization()
    else
        exports['fivem-appearance']:setPlayerAppearance(skin["character_skin"])
        TriggerEvent("em_customization:loaded_appearance")
    end

end)

exports["em_commands"]:register_command('f_appearance', function()

      local config = {
        ped = true,
        headBlend = true,
        faceFeatures = true,
        headOverlays = true,
        components = true,
        props = true
      }

      exports['fivem-appearance']:startPlayerCustomization(function(appearance)
        if (appearance) then
          print('Saved')
        else
          print('Canceled')
        end
      end, config) 

end, "Customize your character")
