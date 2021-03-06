

local successful_crack = nil
local next_try_time = 0

local function dispatch_loop()

    while successful_crack == nil do

        Citizen.Wait(2000)
        if math.random(0, 1000) > 990 then

            TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "10-31b", "Store safe being cracked", 1)
            break

        end

    end

end

local function start_safe_cracking(point)

    exports["em_dal"]:trigger_server_callback_async("em_store_robbery:start_robbing_safe", function(can_rob) 

        if not can_rob then
            exports['t-notify']:Alert({style = 'error', message = "Cannot crack that right now."})
            return
        end

        local combination = {}
        for i = 1, math.random(2, 3) do
            table.insert(combination, math.random(0, 99))
        end

        Citizen.CreateThread(dispatch_loop)
        successful_crack = exports["pd-safe"]:createSafe(combination)

        if not successful_crack then
            next_try_time = GetGameTimer() + 15000
            if  math.random(0, 99) > 35 then
                TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "10-31b", "Store safe being cracked", 1)
            end
        end

        exports["em_dal"]:trigger_server_callback_async("em_store_robbery:stopped_robbing_safe", function(amount)

            if not successful_crack then
                return
            end

            local item_id = exports["em_items"]:get_item_id_from_name("cash")
            exports["em_dal"]:give_item(exports["em_dal"]:get_character_storage_id(), item_id, amount, -1, -1)
            exports['t-notify']:Alert({style = 'success', message = string.format("Took $%d from safe", amount)})

        end, point, successful_crack)

    end, point)

end

AddEventHandler("convenience_store_safe", function(point)

    successful_crack = nil

    local can_safe_crack = exports["em_dal"]:can_do_action("store_safe_cracking")

    if can_safe_crack then

        if GetGameTimer() < next_try_time then
            exports['t-notify']:Alert({style = 'error', message = "Slow down! You're feeling nervous."})
            return
        end

        start_safe_cracking(point)

    else
        exports['t-notify']:Alert({style = "error", message = "You don't have the necessary skill to safecrack.", duration = 5000})
    end

end)