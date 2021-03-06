
local vehicle_stock_menu = MenuV:CreateMenu('Vehicle Stock', 'Select Option', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', 'vehicle_stock_menu', 'native')

local purchase_vehicle_menu = MenuV:CreateMenu('Purchase Vehicle', 'Select category', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', 'purchase_stock_menu', 'native')
local current_stock_menu    = MenuV:CreateMenu('Current Stock', 'Select category', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', 'current_stock_menu', 'native')
local current_orders_menu   = MenuV:CreateMenu('Current Orders', 'Current Order', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', 'current_orders_menu', 'native')

local vehicle_stock_categories = {}
local vehicle_shop_categories  = {}
local vehicle_models = {}

local current_store = ""

local function add_vehicle_button(vehicle, menu)

	local button = menu:AddButton({label = string.format("(%d) %s - $%d", vehicle.stock, vehicle.vehicle_name, vehicle.vehicle_price)})
	button:On("select", function()



	end)

end

local function populate_local_stock_menu(stock)

	for i = 1, #categories do

        if not has_any_stock_from_category(stock, i) then
            goto vehicle_stock_menu_continue
        end

		current_stock_menu:AddButton({label = categories[i], value = vehicle_stock_categories[i]})

		vehicle_stock_categories[i]:On('open', function(menu)

            vehicle_stock_categories[i]:ClearItems()
            for j = 1, #stock do
                if stock[j].vehicle_category_id == i then
                    add_vehicle_button(stock[j], menu)
                end
            end

		end)
        ::vehicle_stock_menu_continue::

	end

end

local function purchase_vehicle_form(vehicle)

	local purchase_form = {

		{
			input_type = "text_input",
			input_name = "purchase_amount",
			placeholder = "How many to order",
			options = {},
			numbers_valid = true,
			characters_valid =  false,
			optional = false
		}
	}

	exports["em_form"]:display_form(function(inputs)

		local purchase_amount = tonumber(exports["em_form"]:get_form_value(inputs, "purchase_amount"))
		if purchase_amount < 1 then
			exports['t-notify']:Alert({style = "error", message = "You must type a number greater than 0"})
		end
		exports["em_dal"]:order_vehicle_async(function(response)

			if response.result.success then
				exports['t-notify']:Alert({style="success", message=string.format("Successfully purchased %d %s", purchase_amount, vehicle.vehicle_name)})
			else
				exports['t-notify']:Alert({style = "error", message = response.result.success})
			end

		end, vehicle.vehicle_model_id, purchase_amount)

	end, string.format("Ordering %s", vehicle.vehicle_name), purchase_form)

end

local function set_vehicle_models(idx, menu)


	local relevant_models = Fun:new(vehicle_models):filter(function(obj) return obj.vehicle_category_id == idx end):into_inner()
	for i = 1, #relevant_models do
		local button = menu:AddButton({label = string.format("%s (%s) $%d", relevant_models[i].vehicle_name, relevant_models[i].vehicle_model, relevant_models[i].vehicle_base_price)})
		button:On("select", function()

			purchase_vehicle_form(relevant_models[i])
			MenuV:CloseMenu(menu)
			MenuV:CloseMenu(purchase_vehicle_menu)
			MenuV:CloseMenu(vehicle_stock_menu)

		end)
	end

end

local function initialize_category_menus(store_name)

	if #vehicle_stock_categories ~= 0 then

		for i = 1, #vehicle_stock_categories do
			vehicle_stock_categories[i]:ClearItems()
		end

	else

		for i = 1, #categories do
			vehicle_stock_categories[i] = MenuV:CreateMenu(string.format('%s Stock', categories[i]), 'Select Option', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', string.format('stock_%s', categories[i]), 'native')
			vehicle_shop_categories[i]  = MenuV:CreateMenu('Order a vehicle', 'Select vehicle', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', string.format('purchase_vehicle_%s', categories[i]), 'native')

			vehicle_shop_categories[i]:On('open', function(menu)

				vehicle_shop_categories[i]:ClearItems()
				set_vehicle_models(i, menu)

			end)

		end

	end

end

local function set_vehicle_orders_menu(orders)

	for i = 1, #orders do
		print(json.encode(orders[i]))
		local button = current_orders_menu:AddButton({label = string.format("(%d) %s : (Arrival Date) %s ", orders[i].order_amount, orders[i].vehicle_name, orders[i].order_fill_date)})
	end

end

local function initialize_menus(store_name)

	vehicle_stock_menu:ClearItems()
	vehicle_stock_menu:AddButton({label = 'Purchase Vehicle', value = purchase_vehicle_menu})
	vehicle_stock_menu:AddButton({label = "Current Stock", value = current_stock_menu})
	vehicle_stock_menu:AddButton({label = "Current Orders", value = current_orders_menu})


	initialize_category_menus()
	purchase_vehicle_menu:On('open', function(menu)

		purchase_vehicle_menu:ClearItems()
		for i = 1, #categories do

			menu:AddButton({label = categories[i], value = vehicle_shop_categories[i]})

		end


	end)

	current_stock_menu:On('open', function(menu)

		exports["em_dal"]:get_vehicle_store_stock_async(function(stock)

			current_stock_menu:ClearItems()
			populate_local_stock_menu(stock)

		end, store_name)

	end)

	current_orders_menu:On('open', function(menu)

		exports["em_dal"]:get_vehicle_orders_async(function(orders)

			print(json.encode(orders))
			current_orders_menu:ClearItems()
			set_vehicle_orders_menu(orders)

		end, store_name)

	end)

	MenuV:OpenMenu(vehicle_stock_menu)

end



AddEventHandler("em_dal:character_loaded", function()

	exports["em_dal"]:get_all_vehicle_models_async(function(response)

		vehicle_models = response

	end)

end)


AddEventHandler("vehicle_shop", function(point)

	current_store = point.args.store_name
	initialize_menus(point.args.store_name)

end)