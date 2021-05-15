
function get_item_modifiers(item_id)

    local modifiers = nil
    trigger_server_callback("em_dal:get_item_modifiers", function(result)

        modifiers = result

    end, item_id)
    return modifiers

end

function get_weapons()

    local weapons = nil
    trigger_server_callback("em_dal:get_weapons", function(result)

        weapons = result

    end)
    return weapons

end

function get_attachments()

    local attachments = nil
    trigger_server_callback("em_dal:get_attachments", function(result)

        attachments = result

    end)
    return attachments

end

function get_items()

    local items = nil
    trigger_server_callback("em_dal:get_items", function(result)

        items = result

    end)
    return items

end