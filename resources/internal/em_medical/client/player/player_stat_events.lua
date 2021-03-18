RegisterNetEvent("esx_status:add")
RegisterNetEvent('esx_basicneeds:onEat')
RegisterNetEvent('esx_basicneeds:onDrink')
RegisterNetEvent('esx_basicneeds:onDonut')
RegisterNetEvent('esx_status:set')

--[[ HANDLERS ]]
AddEventHandler("esx_status:add", function(name, amount)
    add_stat(name, amount)
end)
AddEventHandler("kashacters:PlayerSpawned", function()
    --InitStats()
end)
AddEventHandler('esx_basicneeds:onEat', function(propName)
    --on_eat(propName)
end)
AddEventHandler('esx_basicneeds:onDrink', function(propName)
    --on_drink(propName)
end)

AddEventHandler('esx_basicneeds:onDonut', function(propName)
    --on_donut(propName)
end)

AddEventHandler('esx_status:set', function(name, val)
	set_stat(name, val)
end)

Citizen.CreateThread(function() 

    Citizen.Wait(5)
    local next_check_time = GetGameTimer() + 1000
    while true do

        if GetGameTimer() >= next_check_time then

            next_check_time = GetGameTimer() + 1000
            food_loop()
            water_loop()

        end

        Citizen.Wait(1000)

    end

end)