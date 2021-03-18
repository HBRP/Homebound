
function get_item_modifiers(item_id)

    local modifiers = nil
    trigger_server_callback("em_fw:get_item_modifiers", function(result)

        modifiers = result

    end, item_id)
    return modifiers

end