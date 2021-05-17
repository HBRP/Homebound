
function bank_withdraw_amount_async(callback, bank_account_id, amount)

    trigger_server_callback_async("em_dal:bank_withdraw_amount", callback, bank_account_id, amount)

end

function bank_deposit_money_async(callback, bank_account_id, amount)

    trigger_server_callback_async("em_dal:bank_deposit_money", callback, bank_account_id, amount)

end

function bank_post_payment_async(callback, bank_account_id, bank_pending_transaction_id, amount)

    trigger_server_callback_async("em_dal:bank_deposit_money", callback, bank_account_id, bank_pending_transaction_id, amount)

end

function bank_get_pending_transactions_async(callback, bank_account_id)

    trigger_server_callback_async("em_dal:bank_get_pending_transactions", callback, bank_account_id)

end

function bank_get_bank_accounts_async(callback)

    trigger_server_callback_async("em_dal:bank_get_bank_accounts", callback)

end

function bank_transfer_amount_async(callback, amount, from_bank_account_id, to_bank_account_id, reason)

    trigger_server_callback_async("em_dal:bank_transfer_amount", callback, amount, from_bank_account_id, to_bank_account_id, reason)

end