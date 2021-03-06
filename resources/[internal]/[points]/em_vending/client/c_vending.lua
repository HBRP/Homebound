
local function play_pay_animation()

    TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_ATM', 0, true)
    Citizen.Wait(3000)
    ClearPedTasksImmediately(PlayerPedId())

end

local function purchase_item(item_name, item_cost)

    if exports["em_transactions"]:get_cash_on_hand() < item_cost then
        exports["t-notify"]:Alert({style = "error", message = string.format("Need $%d to buy a %s", item_cost, item_name)})
        return
    end

    local item_id = exports["em_items"]:get_item_id_from_name(item_name)
    local response = exports["em_dal"]:give_item(exports["em_dal"]:get_character_storage_id(), item_id, 1, -1, -1)

    if response.response.success then
        exports["em_transactions"]:remove_cash(item_cost)
        exports["t-notify"]:Alert({style = "success", message = string.format("Bought a %s", item_name)})
    end

end

AddEventHandler("buy_coffee", function(prop)

    play_pay_animation()
    purchase_item("coffee", 2)

end)

AddEventHandler("buy_sludgie", function(prop)

    play_pay_animation()
    purchase_item("sludgie", 5)

end)

AddEventHandler("buy_sprunk", function(prop)

    local sprunk = {
        {
            dialog = "Buy sprunk ($2)", 
            callback = function()

                exports["em_dialog"]:hide_dialog()
                play_pay_animation()
                purchase_item("sprunk", 2)

            end
        },
        {
            dialog = "Kick machine",
            callback = function()
                if math.random(0, 99) > 85 then
                    local item_id = exports["em_items"]:get_item_id_from_name(item_name)
                    exports["em_dal"]:give_item(exports["em_dal"]:get_character_storage_id(), item_id, 1, -1, -1)
                    exports['t-notify']:Alert({style = "success", message = "A sprunk fell out!"})
                else
                    exports['t-notify']:Alert({style = "error", message = "You kicked the machine, but nothing happened"})
                end
            end
        }
    }
    exports["em_dialog"]:show_dialog("Sprunk Machine", sprunk)

end)