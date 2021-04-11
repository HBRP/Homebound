

local function get_beg_response(ped)

    local response = nil
    local callback = nil

    if IsEntityDead(ped.entity) then

        response = "[You beg for money, but the local is dead and doesn't respond.]"
        callback = function()
            exports["em_dialog"]:hide_dialog()
            FreezeEntityPosition(ped.entity, false)
        end

    else
        response = "Umm ... lets see."
        callback = function()

            if math.random(0, 99) > 80 then
                local amount = math.random(1, 10)
                local item_id = exports["em_items"]:get_item_id_from_name("cash")
                exports["em_fw"]:give_item(exports["em_fw"]:get_character_storage_id(), item_id, amount, -1, -1)
                exports['t-notify']:Alert({style = "success", message = string.format("You have received $%d from begging", amount)})
            else
                exports['t-notify']:Alert({style = "error", message = "You didn't receive anything."})
            end
            exports["em_dialog"]:hide_dialog()
            FreezeEntityPosition(ped.entity, false)

        end
    end

    return {
        dialog = "Could you spare some change? [Beg]",
        response = response,
        callback = callback
    }

end

local function fuck_you_up_response(ped)

    local response = nil
    local callback = nil

    if IsEntityDead(ped.entity) then

        response = "[You threaten a corpse. It doesn't respond.]"
        callback = function()

            exports["em_dialog"]:hide_dialog()
            FreezeEntityPosition(ped.entity, false)

        end

    elseif math.random(0, 99) > 50 then

        response = "Here, just take it!"
        callback = function()

            local amount = math.random(5, 25)
            local item_id = exports["em_items"]:get_item_id_from_name("cash")
            exports["em_fw"]:give_item(exports["em_fw"]:get_character_storage_id(), item_id, amount, -1, -1)
            exports['t-notify']:Alert({style = "success", message = string.format("You have received $%d from threatening", amount)})
            exports["em_dialog"]:hide_dialog()

            FreezeEntityPosition(ped.entity, false)

            if math.random(0, 99) > 15 then
                TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "10-31b", string.format("Someone just robbed me of $%d!", amount), 1)
            end

        end

    else

        local dismissive_responses = {"Fuck off bitch", "Get a job", "Get a life", "Lowlife scum, get away from me.", "Yeah, sorry, no cash."}
        response = dismissive_responses[math.random(#dismissive_responses)]
        callback = function()

            exports["em_dialog"]:hide_dialog()
            FreezeEntityPosition(ped.entity, false)

            if math.random(0, 99) > 30 then
                TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "10-31b", "Someone just tried to rob me!", 1)
            end
            if math.random(0, 99) > 80 then
                TaskCombatPed(ped.entity, PlayerPedId(), 0, 16)
            end 

        end

    end

    return {

        dialog = "Give me your money, bitch. [Threaten]",
        response = response,
        callback = callback
    }

end

local function five_minutes(ped)

    local five_minute_responses = 
    {
        "Piss off, fuck face", 
        "Ha, you couldn't afford it", 
        "Get out of my face, bitch.",
        "I ain't selling.",
        "I'm not a bitch, bitch.",
        "You didn't graduate grade school, did you?",
        "Lowlife scum (the local says, shaking their head)", 
        "HA, good one. Move on. (the local says, a bit of anger in their tone)",
        "How much do YOU charge? Fucking asshole. (The local shakes their head and looks away)"
    }

    local dead_responses = 
    {
        "[You solicit the corpse. It doesn't respond]",
        "[The corpse remains a corpse.]",
        "What is wrong with you? This is a dead body!",
        "You ... realize this local is dead, right?",
        "... [They're dead]"
    }

    local responses = {}

    if IsEntityDead(ped.entity) then
        responses = dead_responses
    else
        responses = five_minute_responses
    end

    return {
        dialog = "How much for 5 minutes? [Solicit]",
        response = responses[math.random(#responses)],
        callback = function()

            exports["em_dialog"]:hide_dialog()
            FreezeEntityPosition(ped.entity, false)
            if not IsEntityDead(ped.entity) then
                if math.random(0, 99) > 90 then
                    TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "10-31b", "Someone solicted me for sex!", 2)
                end
                if math.random(0, 99) > 80 then
                    TaskCombatPed(ped.entity, PlayerPedId(), 0, 16)
                end 
            end

        end
    }

end

local function clean_up(ped)

    FreezeEntityPosition(ped.entity, false)
    local player_coords = GetEntityCoords(PlayerPedId())
    if not IsAnyHostilePedNearPoint(PlayerPedId(), player_coords.x, player_coords.y, player_coords.z, 10.0) then
        TaskStandStill(ped.entity, 0)
    end

end

local function get_pleasantries(ped)

    local response = "Fine ... I guess. How are you doing?"
    if IsEntityDead(ped.entity) then
        response = "[The local is dead and doesn't respond]"
    end

    return {
        dialog = "Hey, how are you?",
        response = response,
        callback = function()
            talk_to_selected_ped(ped, ped.entity, true)
        end
    }

end

function talk_to_selected_ped(ped, entity, skip_animation)

    TaskStandStill(ped.entity, 1000000)
    FreezeEntityPosition(ped.entity, true)

    if not skip_animation then
        exports["em_animations"]:play_animation_sync("gestures@m@standing@casual", "gesture_hello", 1000, 16 + 32)
    end

    local ped_dialog = {}
    table.insert(ped_dialog, get_pleasantries(ped))
    table.insert(ped_dialog, five_minutes(ped))
    table.insert(ped_dialog, get_beg_response(ped))
    table.insert(ped_dialog, fuck_you_up_response(ped))

    exports["em_dialog"]:show_dialog("Local citizen", ped_dialog, function() clean_up(ped) end)

end

local function refresh_loop(refresh_func)

    local peds = {}

    local hit, coords, entity = table.unpack(exports["em_fw"]:ray_cast_game_play_camera(10.0))
    if not hit then
        refresh_func(peds)
        return
    end

    local successful, hash = pcall(GetEntityModel, entity)
    if not successful then
        refresh_func(peds)
        return
    end

    if not IsEntityAPed(entity) or IsPedAPlayer(entity) or GetPedType(entity) == 28 or exports["em_interactions"]:is_interaction_ped(entity) then
        refresh_func(peds)
        return
    end

    local x, y, z = table.unpack(GetEntityCoords(entity))
    table.insert(peds, {x = x, y = y, z = z, prop_hash = hash, entity = entity})

    refresh_func(peds)

end

local function text(nearby_ped)

    return string.format("Press [E] to talk")

end

AddEventHandler("em_fw:character_loaded", function()

    exports["em_points"]:register_raycast_points(refresh_loop, text, talk_to_selected_ped, 500)
    
end)

