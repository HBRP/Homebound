
local character_health = {}

function get_character_hunger()

    return character_health["hunger"]

end

function get_character_thirst()

    return character_health["thirst"]

end

local function update_character_health()

    TriggerServerEvent("UpdateCharacterHealth", get_character_id(), character_health)

end

function set_character_hunger(new_hunger)

    character_health["hunger"] = new_hunger
    update_character_health()

end

function set_character_thirst(new_thirst)

    character_health["thirst"] = new_thirst
    update_character_health()

end

function modify_character_hunger(hunger_change)

    character_health["hunger"] = character_health["hunger"] + hunger_change
    update_character_health()

end

function modify_character_thirst(thirst_change)

    character_health["thirst"] = character_health["thirst"] + hunger_change
    update_character_health()

end


function reset_character_hunger()

    set_character_hunger(100)

end

function reset_character_thirst()

    set_character_thirst(100)

end

function set_character_health(health)

    character_health = health

end