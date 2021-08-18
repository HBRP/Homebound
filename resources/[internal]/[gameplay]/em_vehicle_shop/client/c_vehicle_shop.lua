
local vehicle_shop_menu = nil
local category_menus = {}

local function setup_menus()

    vehicle_shop_menu = MenuV:CreateMenu('Vehicles', 'Select Category', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', 'vehicle_shop', 'native')
    for i = 1, #categories do
        category_menus[i] = MenuV:CreateMenu(categories[i], 'Pull out vehicle', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', categories[i], 'native')
    end

end

local showcasing_vehicle = 0
local showcasing_vehicle_stats = nil

local function delete_showcased_vehicle()

    exports["em_vehicles"]:despawn_vehicle(showcasing_vehicle)
    showcasing_vehicle = 0

end

local function add_vehicle_button_to_category(vehicle, menu)

    local spawn_vehicle = function()

        delete_showcased_vehicle()

        local player_coords = GetEntityCoords(PlayerPedId())
        local forward_vec   = GetEntityForwardVector(PlayerPedId())

        local veh_position  = {
            forward_vec.x * 2.5 + player_coords.x,
            forward_vec.y * 2.5 + player_coords.y,
            forward_vec.z * 1.0 + player_coords.z 
        }
        local veh_heading = GetEntityHeading(PlayerPedId()) + 90.0
        showcasing_vehicle = exports["em_vehicles"]:spawn_vehicle(vehicle.vehicle_model, false, false, veh_position, veh_heading, false, false)
        exports["em_vehicles"]:register_vehicle_as_player_owned(showcasing_vehicle)
        showcasing_vehicle_stats = vehicle


    end

    local button = menu:AddButton({label = string.format("(%d) %s - $%d", vehicle.stock, vehicle.vehicle_name, vehicle.vehicle_price)})
    button:On("select", spawn_vehicle)

end

local function open_vehicle_shop_menu(stock)

    vehicle_shop_menu:ClearItems()

	for i = 1, #categories do

        if not has_any_stock_from_category(stock, i) then
            goto vehicle_shop_menu_continue
        end

		local button = vehicle_shop_menu:AddButton({label = categories[i], value = category_menus[i]})

		category_menus[i]:On('open', function(menu)

            category_menus[i]:ClearItems()
            for j = 1, #stock do
                if stock[j].vehicle_category_id == i then
                    add_vehicle_button_to_category(stock[j], menu)
                end
            end

		end)
        ::vehicle_shop_menu_continue::

	end

    MenuV:OpenMenu(vehicle_shop_menu)

end

local function confirm_purchase_ability(seller_character_id, vehicle)

    exports["em_dal"]:bank_get_default_bank_account_async(function(bank_account)

        print(json.encode(bank_account))
        if bank_account.funds < vehicle.vehicle_price then
            exports["t-notify"]:Alert({style = "error", duration=5000, message="You do not have the required funds in your bank account"})
        else
            exports["em_dal"]:trigger_event_for_character("em_vehicle_shop:sell_vehicle_acceptance", exports["em_dal"]:get_character_id())
        end

    end)

end

RegisterNetEvent("em_vehicle_shop:sell_vehicle_query")
AddEventHandler("em_vehicle_shop:sell_vehicle_query", function(seller_character_id, vehicle)

    local form_inputs = {
        {
            input_type = "radiobutton",
            input_name =  "radio_button",
            options =  {"Agree", "Disagree"}
        }
    }
    exports["em_form"]:display_form(function(inputs)

        local response = exports["em_form"]:get_form_value(inputs, "radio_button")
        if response == "Agree" then

            confirm_purchase_ability(seller_character_id, vehicle)

        end

    end, string.format("Do you agree to purchase a %s for %d", vehicle.vehicle_name, vehicle.vehicle_price), form_inputs)

end)

RegisterNetEvent("em_vehicle_shop:sell_vehicle_acceptance")
AddEventHandler("em_vehicle_shop:sell_vehicle_acceptance", function(accepting_character_id)

    print("accepted")

end)

local function sell_vehicle_form()

    local form_inputs = {
        {
            input_type = "text_input",
            input_name = "character_id",
            placeholder = "The character's id",
            options = {},
            numbers_valid = true,
            characters_valid =  false,
            optional = false
        }
    }
    exports["em_form"]:display_form(function(inputs)

        local character_id = tonumber(exports["em_form"]:get_form_value(inputs, "character_id"))
        exports["em_dal"]:trigger_event_for_character("em_vehicle_shop:sell_vehicle_query", character_id, exports["em_dal"]:get_character_id(), showcasing_vehicle_stats)

    end, "Selling Vehicle", form_inputs)

end

exports["em_context"]:register_multi_context("PDM Vehicle Floor", function()

    local dialog_menu = {}
    
    if GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
        table.insert(dialog_menu, {
            dialog = "Pull out vehicle",
            callback = function()

                exports["em_dialog"]:hide_dialog()
                exports["em_dal"]:get_vehicle_store_stock_async(function(stock)

                    open_vehicle_shop_menu(stock)

                end, PDM_STORE)

            end
        })
    end

    local showcase_items = {
        {
            dialog = "[Put away vehicle]",
            callback = function()
                exports["em_dialog"]:hide_dialog()
                delete_showcased_vehicle()
            end
        },
        {
            dialog = "[Finance Vehicle]",
            callback = function()
                exports["em_dialog"]:hide_dialog()
            end
        },
        {
            dialog = "[Sell Vehicle]",
            callback = function()
                exports["em_dialog"]:hide_dialog()
                sell_vehicle_form()
            end
        }
    }

    if showcasing_vehicle ~= 0 and GetVehiclePedIsIn(PlayerPedId(), false) == showcasing_vehicle then
        for i = 1, #showcase_items do
            table.insert(dialog_menu, showcase_items[i])
        end
    end

    return dialog_menu

end)

Citizen.CreateThread(function()

    Citizen.Wait(0)
    setup_menus()

    assert(vehicle_shop_menu ~= nil, "Vehicle shop menu could not be initialized")
    assert(#category_menus > 0, "Vehicle category menus not initialized")

end)