

register_item_use("9mm ammo box", function(storage_item_id)

    exports["rprogress"]:Custom({
        Async    = false,
        Duration = 5000,
        Label    = "Unpacking"
    })

    local response = exports["em_fw"]:give_item(exports["em_fw"]:get_character_storage_id(), get_item_id_from_name("9mm round"), 60, -1, -1)
    if response.response.success then
        exports["em_fw"]:remove_item(storage_item_id, 1)
        exports['t-notify']:Alert({style = 'success', message = "Unpacked 60 9mm rounds"})
    end

end)