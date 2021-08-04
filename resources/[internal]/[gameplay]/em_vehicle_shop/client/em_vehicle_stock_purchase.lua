
local vehicle_stock_menu = MenuV:CreateMenu('Vehicle Stock', 'Select Option', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', 'vehicle_stock_menu', 'native')

local purchase_vehicle_menu = MenuV:CreateMenu('Purchase Vehicle', 'Select category', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', 'purchase_stock_menu', 'native')
local current_stock_menu    = MenuV:CreateMenu('Current Stock', 'Select category', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', 'current_stock_menu', 'native')


AddEventHandler("Vehicle Shop", function(args)

	--args.store_name




end)

local function initialize_menus()

	vehicle_stock_menu:AddButton({label = 'Purchase Vehicle', value = purchase_vehicle_menu})
	vehicle_stock_menu:AddButton({label = "Current Stock", value = current_stock_menu})

	purchase_vehicle_menu:On('open', function(menu)

		for i = 1, #categories do

			menu:AddButton({label = categories[i], value = category_menus[i]})

		end

	end)

	current_stock_menu:On('open', function(menu)

        exports["em_dal"]:get_vehicle_store_stock_async(function(stock)

            open_vehicle_shop_menu(stock)

        end, PDM_STORE)

	end)

end

Citizen.CreateThread(function()

	Citizen.Wait(0)
	initialize_menus()

end)