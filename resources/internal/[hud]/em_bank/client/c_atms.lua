
local hacking = false

AddEventHandler("datacrack", function(successful)

    if not hacking then
        return
    end

    if successful then
        print("Success")
    else
        print("failure")
    end

end)

local function get_hacking_dialog(prop)

    local dialog   = "[Attempt to Hack]"
    local response = nil
    local callback = nil
    if exports["em_items"]:has_item_by_name("usb") then

        local can_hack = true
        if not can_hack then
            response = "(You attempt to jam the USB into the card slot. Nothing happens. Why is hacking so difficult?)"
            callback = function()
                exports["em_dialog"]:hide_dialog()
            end
        else
            response = "(You stick the USB in the appropriate place and begin working your magic.) ((Use left click!))"
            callback = function()
                hacking = true
                exports["em_dialog"]:hide_dialog()
                exports["datacrack"]:Start(3.5)
            end
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


end)