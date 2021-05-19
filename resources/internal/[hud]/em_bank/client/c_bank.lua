
local function load_bank_data()

    local bank_accounts = exports["em_dal"]:bank_get_bank_accounts()
    local pending_transactions = {}
    local transactions = {}

    for i = 1, #bank_accounts do

        local temp_pending = exports["em_dal"]:bank_get_pending_transactions(bank_accounts[i].bank_account_id)
        local temp_transactions = exports["em_dal"]:bank_get_transactions(bank_accounts[i].bank_account_id)

        for _, v in ipairs(temp_pending) do 
            table.insert(pending_transactions, v)
        end

        for _, v in ipairs(temp_transactions) do 
            table.insert(transactions, v)
        end

    end

    SendNUIMessage({accounts = bank_accounts, populate_accounts = true})
    SendNUIMessage({pending = pending_transactions, populate_pending = true})
    SendNUIMessage({transactions = transactions, populate_transactions = true})
    SendNUIMessage({cash = exports["em_transactions"]:get_cash_on_hand(), populate_cash = true})
    SendNUIMessage({display = true, name = exports["em_dal"]:get_character_name()})

    SetNuiFocus(true, true)
end

local function open_bank()

    SendNUIMessage({show_loading = true})
    load_bank_data()

end

RegisterNUICallback("refresh_bank", function(data, cb)

    load_bank_data()
    cb()

end)

RegisterNUICallback("deposit_cash", function(data, cb)

    if exports["em_transactions"]:get_cash_on_hand() < data.deposit_amount then
        return
    end

    exports["em_dal"]:bank_deposit_money(data.bank_account_id, data.deposit_amount)
    SendNUIMessage({cash = exports["em_transactions"]:get_cash_on_hand(), populate_cash = true})

    cb()

end)

RegisterNUICallback("withdraw_cash", function(data, cb)

    exports["em_dal"]:bank_withdraw_amount(data.bank_account_id, data.withdraw_amount)
    SendNUIMessage({cash = exports["em_transactions"]:get_cash_on_hand(), populate_cash = true})
    cb()

end)

RegisterNUICallback("load_bank", function(data, cb)

    local temp_pending = exports["em_dal"]:bank_get_pending_transactions(data.bank_account_id)
    local temp_transactions = exports["em_dal"]:bank_get_transactions(data.bank_account_id)

    SendNUIMessage({pending = temp_pending, populate_pending = true})
    SendNUIMessage({transactions = temp_transactions, populate_transactions = true})
    cb()

end)

RegisterNUICallback("hide", function(data, cb)

    SetNuiFocus(false, false)
    cb()

end)


exports["em_commands"]:register_command("test_bank", function(source, args, raw_command)

    open_bank()

end, "Command for testing bank")