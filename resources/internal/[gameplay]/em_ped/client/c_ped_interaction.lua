

local function get_beg_response(ped)

    return {
        dialog = "Could you spare some change? [Beg]",
        response = "Umm ... lets see.",
        callback = function()

        end
    }

end

local function fuck_you_up_response(ped)

    local response = nil
    local callback = nil

    if math.random(0, 99) > 50 then

        response = "Sure ... here, I guess"
        callback = function()
            --exports["em_fw"]:give_item()
            local amount = math.random(5, 10)
            exports['t-notify']:Alert({style = "success", message = string.format("You have received $%d from begging", amount)})
            exports["em_dialog"]:hide_dialog()
            FreezeEntityPosition(ped.entity, false)

        end

    else

        local dismissive_responses = {"Fuck off bitch", "Get a job", "Get a life", "Lowlife scum, get away from me.", "Yeah, sorry, no cash."}
        response = dismissive_responses[math.random(0, #dismissive_responses)]
        callback = function()

            exports["em_dialog"]:hide_dialog()
            FreezeEntityPosition(ped.entity, false)

            if math.random(0, 99) > 30 then
                TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "10-31b", "Someone just tried to rob me!", 1)
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
        "How much do YOU charge? Asshole. (The local shakes their head)"
    }
    return {
        dialog = "How much for 5 minutes?",
        response = five_minute_responses[math.random(0, #five_minute_responses)],
        callback = function()

            exports["em_dialog"]:hide_dialog()
            FreezeEntityPosition(ped.entity, false)

        end
    }

end

local function talk_to_selected_ped(ped)

    FreezeEntityPosition(ped.entity, true)

    local ped_dialog = {
        {
            dialog = "Hey, how are you?",
            response = "Fine ... I guess. How are you doing?",
            callback = function()
                talk_to_selected_ped(ped)
            end
        }
    }
    table.insert(ped_dialog, five_minutes(ped))
    table.insert(ped_dialog, get_beg_response(ped))
    table.insert(ped_dialog, fuck_you_up_response(ped))
    exports["em_dialog"]:show_dialog("Local citizen", ped_dialog)

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

    if not IsEntityAPed(entity) or IsPedAPlayer(entity) or GetPedType(entity) == 28 then
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

