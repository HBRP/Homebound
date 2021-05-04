

--TriggerEvent('chat:addSuggestion', '/emotebind', 'Bind an emote', {{ name="key", help="num4, num5, num6, num7. num8, num9. Numpad 4-9!"}, { name="emotename", help="dance, camera, sit or any valid emote."}})

RegisterNetEvent('em_commands:propagate_to_nearby_clients:response')
AddEventHandler('em_commands:propagate_to_nearby_clients:response', function(id, content, proximity)

    local myId = PlayerId()
    local my_server_id = GetPlayerServerId(myId)
    local pid = GetPlayerFromServerId(id)

    if pid == -1 and my_server_id ~= id then
        return
    end

    if pid == myId or GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < proximity then
        TriggerEvent('chat:addMessage', content)
    end

end)


register_command_no_perms("ad", function (source, args, raw)

    local msg = raw:sub(4)
    local fal = exports["em_fw"]:get_character_name()
    TriggerServerEvent("em_commands:propagate_to_clients", {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(214, 168, 0, 1); border-radius: 3px; font-size:18px;"> (AD) ({0}): {1}</div>',
        args = { fal, msg }
    })

end, 'Send an advertisement')

register_command_no_perms("me", function (source, args, raw)

    local msg = raw:sub(4)
    local fal = exports["em_fw"]:get_character_name()
    TriggerServerEvent("em_commands:propagate_to_nearby_clients", {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(86, 125, 188, 0.6); border-radius: 3px; font-size:18px;"> (ME) {0}: {1}</div>',
            args = { fal, msg }
    }, 15.0)

end, 'Express yourself')

register_command_no_perms("looc", function(source, args, raw)

    local msg = raw:sub(5)
    local fal = exports["em_fw"]:get_character_name()
    TriggerServerEvent("em_commands:propagate_to_nearby_clients", {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(140, 140, 140, 0.6); border-radius: 3px; font-size:18px;"> (OOC) {0}: {1}</div>',
            args = { fal, msg }
    }, 15.0)

end, "Talk in local ooc")

register_command_no_perms("pos", function(source, args, rawCommand)

    local coords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())

    Citizen.Trace(string.format("(%f, %f, %f, %f)\n", coords.x, coords.y, coords.z, heading))

    TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(140, 140, 140, 0.6); border-radius: 3px; font-size:18px;"> (POS) X: {0}, Y: {1}, Z: {2}, Heading: {3} </div>',
            args = { coords.x, coords.y, coords.z, heading }
    })

end, "Give your position")

register_command_no_perms("camera_rotation", function(source, args, raw_command)

    local result = GetGameplayCamRot()
    TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(140, 140, 140, 0.6); border-radius: 3px; font-size:18px;"> (POS) X: {0}, Y: {1}, Z: {2} </div>',
            args = { result.x, result.y, result.z }
    })

end, "Show the camera rotation")