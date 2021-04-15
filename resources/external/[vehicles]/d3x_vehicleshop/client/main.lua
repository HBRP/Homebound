
local IsInShopMenu = false
local current_vehicles = {}

local function get_vehicle_amount(model)

	for i = 1, #current_vehicles do
		if current_vehicles[i].vehicle_model == model then
			return current_vehicles[i].vehicle_price
		end
	end

end

RegisterNUICallback('BuyVehicle', function(data, cb)

    SetNuiFocus(false, false)
	IsInShopMenu = false

	local amount = get_vehicle_amount(data.model)
	assert(amount ~= nil, string.format("Unable to find price for %s", data.model))
	local success = exports["em_transactions"]:remove_cash(amount)

	if success then

		local veh = exports["em_vehicles"]:spawn_vehicle(data.model, false, false, {-46.049, -1081.758, 26.70}, 67.98, false, true)

	end

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

	current_vehicles = {}

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
	current_vehicles = vehicles

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
