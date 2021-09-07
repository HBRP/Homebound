
local vehicle_shop_menu = nil
local category_menus = {}
local vehicle_store_name = nil

local function setup_menus()

    vehicle_shop_menu = MenuV:CreateMenu('Vehicles', 'Select Category', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', 'vehicle_shop', 'native')
    for i = 1, #categories do
        category_menus[i] = MenuV:CreateMenu(categories[i], 'Pull out vehicle', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', categories[i], 'native')
    end

end

local showcasing_vehicle_id = 0
local showcasing_vehicle = nil

local function delete_showcased_vehicle()

    exports["em_vehicles"]:despawn_vehicle(showcasing_vehicle_id)
    showcasing_vehicle_id = 0

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
        showcasing_vehicle_id = exports["em_vehicles"]:spawn_vehicle(vehicle.vehicle_model, false, false, veh_position, veh_heading, false, false)
        exports["em_vehicles"]:register_vehicle_as_player_owned(showcasing_vehicle_id)
        showcasing_vehicle = vehicle


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

        if bank_account.funds < vehicle.vehicle_price then
            exports["t-notify"]:Alert({style = "error", duration=5000, message="You do not have the required funds in your bank account"})
        else
            exports["em_dal"]:trigger_event_for_character("em_vehicle_shop:sell_vehicle_acceptance", seller_character_id, exports["em_dal"]:get_character_id(), vehicle)
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
AddEventHandler("em_vehicle_shop:sell_vehicle_acceptance", function(accepting_character_id, vehicle)

    if vehicle.vehicle_model ~= showcasing_vehicle.vehicle_model then
        exports["t-notify"]:Alert({style="info", duration=10000, message=string.format("Someone attempted to purchase a %s, but was unable to. Please seek them out when possible to restart the process", vehicle.vehicle_model)})
        return
    end

    local vehicle = {

        character_id = accepting_character_id,
        vehicle_model = showcasing_vehicle.vehicle_model,
        vehicle_mods = exports["em_vehicles"]:get_vehicle_mods(showcasing_vehicle_id),
        vehicle_state = exports["em_vehicles"]:get_vehicle_state(showcasing_vehicle_id)

    }

    exports["em_dal"]:purchase_vehicle_async(function(response)

        if response.result.success then
            SetVehicleNumberPlateText(showcasing_vehicle_id, response.plate)
            exports["em_vehicles"]:register_vehicle_as_player_owned(showcasing_vehicle_id, accepting_character_id)
            exports['t-notify']:Alert({style = "success", duration = 5000, message = string.format("Successfully sold vehicle. Received $%d in commission", response.commission_amount)})
            showcasing_vehicle_id = 0
        else
            exports["t-notify"]:Alert({style = "error", message = response.result.message})
        end

    end, vehicle, vehicle_store_name)

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
        exports["em_dal"]:trigger_event_for_character("em_vehicle_shop:sell_vehicle_query", character_id, exports["em_dal"]:get_character_id(), showcasing_vehicle)

    end, "Selling Vehicle", form_inputs)

end

local function confirm_finance_ability(seller_character_id, finance_weeks, vehicle)

    exports["em_dal"]:bank_get_default_bank_account_async(function(bank_account)

        if bank_account.funds < math.floor(vehicle.vehicle_price * 0.2) then
            exports["t-notify"]:Alert({style = "error", duration=5000, message="You do not have the required funds in your bank account."})
        else
            exports["em_dal"]:trigger_event_for_character("em_vehicle_shop:finance_vehicle_query_acceptance", seller_character_id, exports["em_dal"]:get_character_id(), finance_weeks, vehicle)
        end

    end)

end

RegisterNetEvent("em_vehicle_shop:finance_vehicle_query")
AddEventHandler("em_vehicle_shop:finance_vehicle_query", function(seller_character_id, finance_weeks, vehicle)

    local form_inputs = {
        {
            input_type = "radiobutton",
            input_name =  "radio_button",
            options =  {"Agree", "Disagree"}
        }
    }

    local downpayment_amount = math.floor(vehicle.vehicle_price * 0.2)
    local weekly_amount = math.floor(vehicle.vehicle_price * 0.8 / finance_weeks)

    local question = "Do you agree to finance a %s and pay the down payment of $%d? Keep in mind, with financing, you agree to make a payment for %d every week for %d weeks"
    question = string.format(question, vehicle.vehicle_name, downpayment_amount, weekly_amount, finance_weeks)
    exports["em_form"]:display_form(function(inputs)

        local response = exports["em_form"]:get_form_value(inputs, "radio_button")
        if response == "Agree" then

            confirm_finance_ability(seller_character_id, finance_weeks, vehicle)

        end

    end, question, form_inputs)

end)

RegisterNetEvent("em_vehicle_shop:finance_vehicle_query_acceptance")
AddEventHandler("em_vehicle_shop:finance_vehicle_query_acceptance", function(buyer_character_id, finance_weeks, vehicle)

    if vehicle.vehicle_model ~= showcasing_vehicle.vehicle_model then
        exports["t-notify"]:Alert({style="info", duration=10000, message=string.format("Someone attempted to finance a %s, but was unable to. Please seek them out when possible to restart the process", vehicle.vehicle_model)})
        return
    end


end)

local function finance_vehicle_form()

    local form_inputs = {
        {
            input_type = "text_input",
            input_name = "character_id",
            placeholder = "The character's id",
            options = {},
            numbers_valid = true,
            characters_valid =  false,
            optional = false
        },
        {  
            input_type = "dropdown",
            input_name = "finance_weeks",
            placeholder = "",
            options = ["4", "8", "12"],
            numbers_valid = true,
            characters_valid = true,
            optional = false
        }
    }
    exports["em_form"]:display_form(function(inputs)

        local character_id = tonumber(exports["em_form"]:get_form_value(inputs, "character_id"))
        local finance_weeks = tonumber(exports["em_form"]:get_form_value(inputs, "finance_weeks"))
        exports["em_dal"]:trigger_event_for_character("em_vehicle_shop:finance_vehicle_query", character_id, exports["em_dal"]:get_character_id(), finance_weeks, showcasing_vehicle)

    end, "Selling Vehicle", form_inputs)

end

local function setup_vehicle_floor(store_name)

    vehicle_store_name = store_name
    local dialog_menu = {}
    
    if GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
        table.insert(dialog_menu, {
            dialog = "Pull out vehicle",
            callback = function()

                exports["em_dialog"]:hide_dialog()
                exports["em_dal"]:get_vehicle_store_stock_async(function(stock)

                    open_vehicle_shop_menu(stock)

                end, vehicle_store_name)

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

    if showcasing_vehicle_id ~= 0 and GetVehiclePedIsIn(PlayerPedId(), false) == showcasing_vehicle_id then
        for i = 1, #showcase_items do
            table.insert(dialog_menu, showcase_items[i])
        end
    end

    return dialog_menu

end

exports["em_context"]:register_multi_context("PDM Vehicle Floor", function()

    return setup_vehicle_floor(PDM_STORE)

end)

Citizen.CreateThread(function()

    Citizen.Wait(0)
    setup_menus()

    assert(vehicle_shop_menu ~= nil, "Vehicle shop menu could not be initialized")
    assert(#category_menus > 0, "Vehicle category menus not initialized")

end)