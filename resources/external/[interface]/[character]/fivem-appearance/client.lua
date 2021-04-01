

RegisterCommand("customization", function (source, args, raw)

    Citizen.CreateThread(function()
        
        local config = {
            ped = true,
            headBlend = true,
            faceFeatures = true,
            headOverlays = true,
            components = true,
            props = true,
        }

        Citizen.Wait(5)
        exports['fivem-appearance']:startPlayerCustomization(function(appearance)
            if (appearance) then
                print("help")
            else
                print("don't help")
            end
        end, config)

    end)

end)