

local food, water, drunk, cash = 0
local toghud = true

RegisterCommand('hud', function(source, args, rawCommand)

    if toghud then 
        toghud = false
    else
        toghud = true
    end

end)

RegisterNetEvent('hud:toggleui')
AddEventHandler('hud:toggleui', function(show)

    if show == true then
        toghud = true
    else
        toghud = false
    end

end)

local lungs = 0.0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(150)
        local player = PlayerPedId()
        local health = (GetEntityHealth(player) - 100)
        local armor = GetPedArmour(player)
        local playerTalking = NetworkIsPlayerTalking(PlayerId())
        food  = exports["em_medical"]:get_stat("FOOD")
        water = exports["em_medical"]:get_stat("WATER")

        if IsEntityInWater(player) then
            lungs =  GetPlayerUnderwaterTimeRemaining(PlayerId()) * 2.5
        else
            lungs = GetPlayerSprintTimeRemaining(PlayerId()) * 10
        end

        SendNUIMessage({
            action = 'updateStatusHud',
            pauseMenu = IsPauseMenuActive(),
            show = toghud,
            health = health,
            armour = armor,
            oxygen = lungs,
            hunger = food,
	        thirst = water,
			voice = playerTalking
        })
    end
end)