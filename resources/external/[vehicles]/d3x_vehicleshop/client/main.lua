
local IsInShopMenu = false

RegisterNUICallback('BuyVehicle', function(data, cb)

    SetNuiFocus(false, false)
	IsInShopMenu = false
	exports["em_vehicles"]:spawn_vehicle(data.model, false, false, {-46.049, -1081.758, 26.70}, 67.98, false, true)

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
