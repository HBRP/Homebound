
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

local vehicle_shop_menu = nil
local category_menus = {}

local function setup_menus()

    vehicle_shop_menu = MenuV:CreateMenu('Vehicles', 'Select Category', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', 'vehicle_shop', 'native')
    for i = 1, #categories do
        category_menus[i] = MenuV:CreateMenu(categories[i], 'Pull out vehicle', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', categories[i], 'native')
    end

end

local function open_vehicle_shop_menu(stock)

    vehicle_shop_menu:ClearItems()

	for i = 1, #categories do

		local button = vehicle_shop_menu:AddButton({label = categories[i], value = category_menus[i]})

		category_menus[i]:On('open', function(m)
            category_menus[i]:ClearItems()
			m:AddButton({label = 'temp', value = function() end})
		end)

	end
    MenuV:OpenMenu(vehicle_shop_menu)

end

exports["em_context"]:register_context("PDM Vehicle Floor", function()

    return {
        dialog = "Pull out vehicle",
        callback = function()

            exports["em_dialog"]:hide_dialog()
            exports["em_dal"]:get_vehicle_store_stock_async(function(stock)

                open_vehicle_shop_menu(stock)

            end, "PDM Basic")

        end
    }

end)

Citizen.CreateThread(function()

    Citizen.Wait(0)
    setup_menus()

    assert(vehicle_shop_menu ~= nil, "Vehicle shop menu could not be initialized")
    assert(#category_menus > 0, "Vehicle category menus not initialized")

end)