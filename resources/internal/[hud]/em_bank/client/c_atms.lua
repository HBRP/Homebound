
local hacking = false

AddEventHandler("datacrack", function(successful)

    if not hacking then
        return
    end

    if successful then
        exports["em_dal"]:trigger_server_callback("em_bank:successful_hack", function(payout)

            exports["t-notify"]:Alert({style = "success", message = string.format("ATM machine paid out $%d", payout), duration = 5000})

            if math.random(100) >= 80  then
                TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "ATM Hacked", string.format("ATM tampered with. $%d stolen.", payout), 2)
            end

        end)

    else
        exports["t-notify"]:Alert({style = "error", message = "You failed to hack the ATM."})
        TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "ATM Hacked", string.format("ATM tampered with."), 2)
    end
    hacking = false

end)

local function dispatch_loop()

    Citizen.Wait(2000)
    while hacking do

        if math.random(100) >= 90 then
            TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "ATM Hacked", "ATM is currently being tampered with", 2)
            break
        end
        Citizen.Wait(2500)

    end

end

local function get_hacking_dialog(prop)

    local dialog   = "[Attempt to Hack]"
    local response = nil
    local callback = nil
    if exports["em_items"]:has_item_by_name("usb") then

        local can_hack = exports["em_dal"]:can_do_action("atm_hacking")
        if not can_hack then
            response = "(You attempt to jam the USB into the card slot. Nothing happens. Why is hacking so difficult?)"
            callback = function()
                exports["em_dialog"]:hide_dialog()
            end
        else

            exports["em_dal"]:trigger_server_callback("em_bank:can_hack", function(atm_is_hackable)
                
                if atm_is_hackable then
                    response = "(You stick the USB in the appropriate place and begin working your magic.) ((Use left click!))"
                    callback = function()

                        hacking = true
                        exports["em_dal"]:trigger_server_callback_async("em_bank:begin_hacking", function() end, GetEntityCoords(PlayerPedId()))
                        exports["em_dialog"]:hide_dialog()
                        Citizen.CreateThread(dispatch_loop)
                        exports["datacrack"]:Start(3.75)

                    end
                else
                    response = "(You take out your USB but before you slot it in, you notice the ATM has already been tampered with. Try again later)"
                    callback = function()
                        exports["em_dialog"]:hide_dialog()
                    end
                end

            end, GetEntityCoords(PlayerPedId()))

        end

    else
        response = "(You smack the side of the ATM. Nothing happens.)"
        callback = function()
            exports["em_dialog"]:hide_dialog()
        end
    end

    return {
        dialog = dialog,
        callback = callback,
        response = response
    }

end

AddEventHandler("use_atm", function(prop)

    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_ATM", 0, true)

    local dialog = {
        {
            dialog = "[Use ATM]",
            response = "(You input your pin and the banking app begins to load)",
            callback = function()
                TriggerEvent("em_bank:open_bank")
                exports["em_dialog"]:hide_dialog()
            end
        }
    }

    local hacking_dialog = get_hacking_dialog(prop)
    if hacking_dialog ~= nil then
        table.insert(dialog, hacking_dialog)
    end

    exports["em_dialog"]:show_dialog("ATM", dialog)

    Citizen.Wait(5000)
    ClearPedTasksImmediately(PlayerPedId())

end)