--====================================================================================
-- # Discord XenKnighT#7085
--====================================================================================

--[[
      Appeller SendNUIMessage({event = 'updateBankbalance', banking = xxxx})
      à la connection & à chaque changement du compte
--]]

-- ES / ESX Implementation
inMenu = true
local bank = 0
local firstname = ''
function setBankBalance (value)
    bank = value
    SendNUIMessage({ event = 'updateBankbalance', banking = bank })
end

local bank_account_cache = 

AddEventHandler("em_dal:character_loaded", function()

    exports["em_dal"]:bank_get_default_bank_account_async(function(account)

        bank_account_cache = account
        setBankBalance(account.funds)

    end)

end)

AddEventHandler("em_dal:DefaultBankChange", function()

    exports["em_dal"]:bank_get_default_bank_account_async(function(account)

        bank_account_cache = account
        setBankBalance(account.funds)

    end)

end)

    exports["em_dal"]:bank_get_default_bank_account_async(function(account)

        bank_account_cache = account
        setBankBalance(account.funds)

    end)


--===============================================
--==         Transfer Event                    ==
--===============================================
AddEventHandler('gcphone:bankTransfer', function(data)

    data.amount = tonumber(data.amount)
    data.id = tonumber(data.id)
    if bank_account_cache.bank_account_id > data.amount then

        exports['t-notify']:Alert({style = "error", message = "Not enough funds."})
        return

    end
    
    exports['t-notify']:Alert({style = "success", message = string.format("Sent $%d", data.amount)})
    exports["em_dal"]:bank_transfer_amount(data.amount, bank_account_cache.bank_account_id, data.id, "Phone App Transfer")
    
end)







