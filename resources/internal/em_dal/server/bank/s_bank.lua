

function direct_deposit(character_id, transaction_amount)

    local endpoint = string.format("/Bank/DirectDeposit/%d/%d", character_id, transaction_amount)
    HttpPut(endpoint, nil, function(error_code, result_data, result_headers) end)

end