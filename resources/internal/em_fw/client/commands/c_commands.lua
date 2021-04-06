


function can_use_command(command, command_arguments)

    local can_use = false
    trigger_server_callback("em_fw:can_use_command", function(response) 

        can_use = response["can_use"]

    end, get_character_id(), command, command_arguments)
    return can_use

end