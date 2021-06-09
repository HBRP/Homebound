

function direct_deposit(character_id, transaction_amount)

    local endpoint = string.format("/Bank/DirectDeposit/%d/%d", character_id, transaction_amount)
    HttpPut(endpoint, nil, function(error_code, result_data, result_headers) end)

end

register_server_callback("em_dal:bank_withdraw_amount", function(source, callback, bank_account_id, amount)

    local character_id = get_character_id_from_source(source)
    local endpoint = string.format("/Bank/Withdraw/%d/%d/%d", character_id, bank_account_id, amount)
    HttpPost(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:bank_deposit_money", function(source, callback, bank_account_id, amount)

    local character_id = get_character_id_from_source(source)
    local endpoint = string.format("/Bank/Deposit/%d/%d/%d", character_id, bank_account_id, amount)
    HttpPost(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:bank_post_payment", function(source, callback, bank_account_id, bank_pending_transaction_id, amount)

    local character_id = get_character_id_from_source(source)
    local data = {character_id = character_id, bank_account_id = bank_account_id, bank_pending_transaction_id = bank_pending_transaction_id, amount = amount}
    HttpPost("/Bank/PostPayment", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:bank_get_pending_transactions", function(source, callback, bank_account_id)

    local endpoint = string.format("/Bank/Pending/%d", bank_account_id)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:bank_get_default_bank_account", function(source, callback)

    local endpoint = string.format("/Bank/Accounts/Default/%d", get_character_id_from_source(source))
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:bank_get_bank_accounts", function(source, callback)

    local character_id = get_character_id_from_source(source)
    local endpoint = string.format("/Bank/Accounts/%d", character_id)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)


register_server_callback("em_dal:bank_transfer_amount", function(source, callback, amount, from_bank_account_id, to_bank_account_id, reason)

    local character_id = get_character_id_from_source(source)
    local data = {character_id = character_id, amount = amount, from_bank_account_id = from_bank_account_id, to_bank_account_id = to_bank_account_id, reason = reason}
    HttpPost("/Bank/Transfer", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:bank_get_transactions", function(source, callback, bank_account_id)

    local endpoint = string.format("/Bank/Transactions/%d", bank_account_id)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)