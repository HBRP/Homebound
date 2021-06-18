

function create_temp_blip(coords, blip_type, blip_color, blip_name, blip_time)

	Citizen.CreateThread(function()

        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, blip_type)
        SetBlipColour(blip, blip_color)
        SetBlipAsShortRange(blip, false)
        SetBlipScale(blip, 0.8)
        
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(blip_name)
        EndTextCommandSetBlipName(blip)

        Citizen.Wait(blip_time)
        RemoveBlip(blip)

	end)

end