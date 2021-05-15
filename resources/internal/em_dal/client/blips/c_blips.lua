
function get_blips()

    local current_blips = nil
    trigger_server_callback("em_dal:get_blips", function(blips)

        current_blips = blips

    end)
    return current_blips
    
end