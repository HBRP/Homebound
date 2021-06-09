
local atms = {}

exports["em_dal"]:register_server_callback("em_bank:successful_hack", function(source, callback)

    local payout = math.random(600, 1200)
    exports["em_items"]:give_item_by_name(source, "cash", payout)
    callback(payout)

end)

exports["em_dal"]:register_server_callback("em_bank:can_hack", function(source, callback, coords)

    for i = 1, #atms do
        if #(atms[i].coords - coords) < 1.0 then
            callback(false)
            return
        end
    end
    callback(true)

end)

exports["em_dal"]:register_server_callback("em_bank:begin_hacking", function(source, callback, coords)

    table.insert(atms, {coords = coords, next_hacking_attempt = GetGameTimer() + 1000 * 60 * 60 * 2})
    callback()

end)

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(10000)
        local game_timer = GetGameTimer()
        for i = 1, #atms do

            if atms[i].next_hacking_attempt < game_timer then
                table.remove(atms, i)
                i = i - 1
            end

        end
    end

end)