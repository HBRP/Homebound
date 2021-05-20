

exports["em_dal"]:register_server_callback("em_bank:successful_hack", function(source, callback)

    local payout = math.random(600, 1200)
    exports["em_items"]:give_item_by_name(source, "cash", payout)
    callback(payout)

end)