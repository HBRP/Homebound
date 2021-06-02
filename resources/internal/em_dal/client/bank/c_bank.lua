
local default_bank_account = nil

local function check_to_trigger_bank_event(bank_account_id)

    if bank_account_id == default_bank_account.bank_account_id then
        TriggerEvent("em_dal:DefaultBankChange")
    end

end

function bank_withdraw_amount(bank_account_id, amount)

    local data = nil
    trigger_server_callback("em_dal:bank_withdraw_amount", function(result)

        data = result
        check_to_trigger_bank_event(bank_account_id)

    end, bank_account_id, amount)

    return data

end

function bank_deposit_money(bank_account_id, amount)

    local data = nil
    trigger_server_callback("em_dal:bank_deposit_money", function(result)

        data = result
        check_to_trigger_bank_event(bank_account_id)

    end, bank_account_id, amount)
    
    return data

end

function bank_post_payment(bank_account_id, bank_pending_transaction_id, amount)

    local data = nil
    trigger_server_callback("em_dal:bank_post_payment", function(result)

        data = result
        check_to_trigger_bank_event(bank_account_id)

    end, bank_account_id, bank_pending_transaction_id, amount)

    return data

end

function bank_get_pending_transactions(bank_account_id)

    local data = nil
    trigger_server_callback("em_dal:bank_get_pending_transactions", function(result)

        data = result

    end, bank_account_id)

    return data

end

function bank_get_default_bank_account_async(callback)

    trigger_server_callback_async("em_dal:bank_get_default_bank_account", function(account)

        default_bank_account = account
        callback(account)

    end)

end

function bank_get_bank_accounts()

    local data = nil
    trigger_server_callback("em_dal:bank_get_bank_accounts", function(result)

        data = result

    end)

    return data

end

function bank_transfer_amount(amount, from_bank_account_id, to_bank_account_id, reason)

    local data = nil
    trigger_server_callback("em_dal:bank_transfer_amount", function(result)

        data = result
        check_to_trigger_bank_event(from_bank_account_id)
        check_to_trigger_bank_event(to_bank_account_id)


    end, amount, from_bank_account_id, to_bank_account_id, reason)

    return data

end

function bank_get_transactions(bank_account_id)

    local data = nil
    trigger_server_callback("em_dal:bank_get_transactions", function(result)

        data = result

    end, bank_account_id)

    return data

end
