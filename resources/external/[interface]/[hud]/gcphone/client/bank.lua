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

AddEventHandler("em_dal:character_loaded", function()

    exports["em_dal"]:bank_get_default_bank_account_async(function(account)
        setBankBalance(account.funds)
    end)
    
end)

AddEventHandler("em_dal:DefaultBankChange", function()

    exports["em_dal"]:bank_get_default_bank_account_async(function(account)
        setBankBalance(account.funds)
    end)

end)



--===============================================
--==         Transfer Event                    ==
--===============================================
AddEventHandler('gcphone:bankTransfer', function(data)
    TriggerServerEvent('bank:transfer', data.id, data.amount)
    TriggerServerEvent('bank:balance')
end)







