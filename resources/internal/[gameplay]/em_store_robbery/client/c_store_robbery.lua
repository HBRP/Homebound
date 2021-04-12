
local store_type_ids = {

    CONVENIENCE  = 1,
    BLACK_MARKET = 2,
    PAWN_SHOP    = 3,
    AMMUNATION   = 4,
    TATTOO_SHOP  = 5

}

local function robbing_loop(ped)

    local robbing_store = true
    exports["rprogress"]:Custom({
        Async    = true,
        Duration = 60000,
        Label = "Robbing convenience store",
        onComplete = function(data, cb)
            robbing_store = false
        end
    })

    local starting_coords = GetEntityCoords(PlayerPedId())
    while robbing_store do

        Citizen.Wait(100)
        if #(GetEntityCoords(PlayerPedId()) - starting_coords) > 25.0 then

            exports["t-notify"]:Alert({style = "error", message = "Failed to execute robbery. Too far away."})
            exports["rprogress"]:Stop()
            return

        end

    end

    exports["em_fw"]:trigger_server_callback("em_store_robbery:finished_robbing_store", function(amount) 

        if amount > 0 then
            TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "10-31b", string.format("They took $%d from my register!", amount), 1)
        end

    end, ped.interaction_ped_id, true)

end

local function rob_npc_dialog(ped)

    local response = string.format("Woah, slow down ... (%s moves on hand underneath the desk, pressing a button before complying)", ped.ped_name)
    local callback = function() end
    exports["em_fw"]:trigger_server_callback("em_store_robbery:can_rob_store", function(can_rob)

        if not can_rob then
            response = string.format("Come on man! I just got robbed (%s moves a hand underneath the desk, pressing a button as he speaks)", ped.ped_name)
            callback = function() 

                TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "10-31b", "Help! Someone just tried to rob me again!", 1)
                exports["em_dialog"]:hide_dialog()

            end
        else
            callback = function()

                exports["em_fw"]:trigger_server_callback_async("em_store_robbery:begin_robbing_store", function(can_still_rob_store)

                    exports["em_dialog"]:hide_dialog()
                    if can_still_rob_store then
                        TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "10-31b", "Help! Someone is robbing the store!", 1)                
                        Citizen.CreateThread(function() robbing_loop(ped) end)
                    else
                        exports['t-notify']:Alert({style = "error", message = "Someone else is robbing the store"})
                    end

                end, ped.interaction_ped_id)
                
            end
        end

    end, ped.interaction_ped_id)

    return {
        dialog = "Put the money in the bag! [Rob]",
        response = response,
        callback = callback
    }

end

local function shop_dialog()

    return {
        dialog = "I'd like to buy items",
        response = "Sure thing.",
        callback = function()

            exports["em_fw"]:get_store_items_async(function(store_items)

                exports["em_dialog"]:hide_dialog()
                TriggerEvent("esx_inventoryhud:open_store", {store_name = "Convenience Store"}, store_items)

            end, store_type_ids.CONVENIENCE)

        end
    }

end

AddEventHandler("convenience_clerk", function(ped, entity)

    local clerk_dialog = {}
    table.insert(clerk_dialog, shop_dialog())
    table.insert(clerk_dialog, rob_npc_dialog(ped))

    exports["em_dialog"]:show_dialog(ped.ped_name, clerk_dialog)

end)