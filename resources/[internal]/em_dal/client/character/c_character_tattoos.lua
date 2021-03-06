
function get_tattoos()

    local tattoos = {}
    trigger_server_callback("em_dal:get_tattoos", function(result)

        tattoos = result

        if type(result) == "string" then
            tattoos = json.decode(result)
        end

    end, get_character_id())

    return tattoos

end

function get_tattoos_async(callback)

    trigger_server_callback_async("em_dal:get_tattoos", function(result) 

        local temp = result

        if type(result) == "string" then
            temp = json.decode(result)
        end

        callback(temp)

    end, get_character_id())

end

function update_tattoos(tattoos)

    trigger_server_callback("em_dal:update_tattoos", function() end, get_character_id(), tattoos)

end