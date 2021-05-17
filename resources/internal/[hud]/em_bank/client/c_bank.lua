
local function open_bank()

    exports["em_fw"]:bank_get_bank_accounts_async(function(results)

        SendNUIMessage({accounts = results, populate_accounts = true})
        for i = 1, #results do

            exports["em_fw"]:bank_get_pending_transactions_async(function(results)

                SendNUIMessage({pending = results, populate_pending = true})

            end, results[i].bank_account_id)

        end
        SendNUIMessage({display = true})

    end)

end


exports["em_commands"]:register_command("test_bank", function(source, args, raw_command)

    open_bank()

end, "Command for testing bank")