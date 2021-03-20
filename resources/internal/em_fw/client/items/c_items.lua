
function get_item_modifiers(item_id)

    local modifiers = nil
    trigger_server_callback("em_fw:get_item_modifiers", function(result)

        modifiers = result

    end, item_id)
    return modifiers

end

function get_weapons()

    local weapons = nil
    trigger_server_callback("em_fw:get_weapons", function(result)

        weapons = result

    end)
    return weapons

end

function get_items()

    local items = nil
    trigger_server_callback("em_fw:get_items", function(result)

        items = result

    end)
    return items

end