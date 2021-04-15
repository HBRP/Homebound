
local IsInShopMenu = false

RegisterNUICallback('BuyVehicle', function(data, cb)
    SetNuiFocus(false, false)

    local model = data.model
	local playerPed = PlayerPedId()
	IsInShopMenu = false
	exports['mythic_notify']:PersistentHudText('START','waiting','vermelho',_U('wait_vehicle'))

    ESX.TriggerServerCallback('d3x_vehicleshop:buyVehicle', function(hasEnoughMoney)
		exports['mythic_notify']:PersistentHudText('END','waiting')

		if hasEnoughMoney then

			ESX.Game.SpawnVehicle(model, Config.Zones.ShopOutside.Pos, Config.Zones.ShopOutside.Heading, function (vehicle)
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

				local newPlate     = GeneratePlate()
				local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
				vehicleProps.plate = newPlate
				SetVehicleNumberPlateText(vehicle, newPlate)

				if Config.EnableOwnedVehicles then
					TriggerServerEvent('d3x_vehicleshop:setVehicleOwned', vehicleProps)
				end

				ESX.ShowNotification(_U('vehicle_purchased'))
			end)

		else
			ESX.ShowNotification(_U('not_enough_money'))
		end

	end, model)
end)

RegisterNUICallback('CloseMenu', function(data, cb)

    SetNuiFocus(false, false)
	IsInShopMenu = false
	cb(false)

end)


RegisterCommand('closeshop', function()

	SetNuiFocus(false, false)
    IsInShopMenu = false

end)

local categories ={
	'muscle',
    'compacts',
    'vans',
    'sedans',
    'suvs',
    'sports classics',
    'offroad',
    'coupes',
    'sports',
    'super',
    'motorcycles',
    'bicycles'
}

function OpenShopMenu(vehicles)

	local vehicle = {}

	if IsInShopMenu then
		return
	end

	IsInShopMenu = true
	SetNuiFocus(true, true)

	local temp_categories = {}
	for i = 1, #categories do
		table.insert(temp_categories, {name = categories[i], label = categories[i]})
	end
	for i = 1, #vehicles do
		vehicles[i].category_name = categories[vehicles[i].vehicle_category_id]
	end

	SendNUIMessage({
        show = true,
		cars = vehicles,
		categories = temp_categories
    })

	Citizen.CreateThread(function()
		while IsInShopMenu do
			Citizen.Wait(1)
	
			DisableControlAction(0, 75,  true) -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		end
	end)

end

AddEventHandler("OpenVehicleShop", OpenShopMenu)
