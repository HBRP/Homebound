
local vehicle_stock_menu = MenuV:CreateMenu('Vehicle Stock', 'Select Option', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', 'vehicle_stock_menu', 'native')

local purchase_vehicle_menu = MenuV:CreateMenu('Purchase Vehicle', 'Select category', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', 'purchase_stock_menu', 'native')
local current_stock_menu    = MenuV:CreateMenu('Current Stock', 'Select category', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', 'current_stock_menu', 'native')

local vehicle_stock_categories = {}
local vehicle_shop_categories  = {}


local function populate_local_stock_menu(stock)

	for i = 1, #categories do

        if not has_any_stock_from_category(stock, i) then
            goto vehicle_stock_menu_continue
        end

		local button = vehicle_shop_menu:AddButton({label = categories[i], value = vehicle_stock_categories[i]})

		vehicle_stock_categories[i]:On('open', function(menu)

            vehicle_stock_categories[i]:ClearItems()
            for j = 1, #stock do
                if stock[j].vehicle_category_id == i then
                    --add_vehicle_button_to_category(stock[j], menu)
                end
            end

		end)
        ::vehicle_stock_menu_continue::

	end

end

local function initialize_category_menus(store_name)

	if #vehicle_stock_categories ~= 0 then

		for i = 1, #vehicle_stock_categories do
			vehicle_stock_categories[i]:ClearItems()
		end
		for i = 1, #vehicle_shop_categories do
			vehicle_shop_categories[i]:ClearItems()
		end

	else

		for i = 1, #categories do
			vehicle_stock_categories[i] = MenuV:CreateMenu(string.format('%s Stock', categories[i]), 'Select Option', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', string.format('stock_%s', categories[i]), 'native')
			vehicle_shop_categories[i]  = MenuV:CreateMenu('Order a vehicle', 'Select vehicle', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', string.format('purchase_vehicle_%s', categories[i]), 'native')

			vehicle_stock_categories[i]:On('open', function(menu)

			end)

			vehicle_stock_categories[i]:On('open', function(menu)

			end)

		end

	end

end

local function initialize_menus(store_name)

	vehicle_stock_menu:ClearItems()
	purchase_vehicle_menu:ClearItems()
	current_stock_menu:ClearItems()

	vehicle_stock_menu:AddButton({label = 'Purchase Vehicle', value = purchase_vehicle_menu})
	vehicle_stock_menu:AddButton({label = "Current Stock", value = current_stock_menu})


	initialize_category_menus()
	purchase_vehicle_menu:On('open', function(menu)

		for i = 1, #categories do

			menu:AddButton({label = categories[i], value = category_menus[i]})

		end

	end)

	current_stock_menu:On('open', function(menu)

		current_stock_menu:ClearItems()
		exports["em_dal"]:get_vehicle_store_stock_async(function(stock)

			populate_local_stock_menu(stock)

		end, PDM_STORE)

	end)
	MenuV:OpenMenu(vehicle_stock_menu)

end


AddEventHandler("vehicle_shop", function(args)

	print("here")
	initialize_menus(args.store_name)

end)