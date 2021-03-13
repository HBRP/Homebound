

--TriggerEvent('chat:addSuggestion', '/emotebind', 'Bind an emote', {{ name="key", help="num4, num5, num6, num7. num8, num9. Numpad 4-9!"}, { name="emotename", help="dance, camera, sit or any valid emote."}})

RegisterNetEvent('em_commands:propagate_to_nearby_clients:response')
AddEventHandler('em_commands:propagate_to_nearby_clients:response', function(id, content, proximity)

    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)

    if pid == myId or GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < proximity then
        TriggerEvent('chat:addMessage', content)
    end

end)


register_command("ad", function (source, args, raw)

    local msg = raw:sub(4)
    local fal = exports["em_fw"]:get_character_name()
    TriggerServerEvent("em_commands:propagate_to_clients", {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(214, 168, 0, 1); border-radius: 3px; font-size:18px;"> Ad ({0}): {1}</div>',
        args = { fal, msg }
    })

end, 'Send an advertisement')

register_command("me", function (source, args, raw)

    local msg = raw:sub(4)
    local fal = exports["em_fw"]:get_character_name()
    TriggerServerEvent("em_commands:propagate_to_nearby_clients", {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(86, 125, 188, 0.6); border-radius: 3px; font-size:18px;"> (ME) {0}: {1}</div>',
            args = { fal, msg }
    }, 15.0)

end, 'Express yourself')

register_command("looc", function(source, args, raw)

    local msg = raw:sub(5)
    local fal = exports["em_fw"]:get_character_name()
    TriggerServerEvent("em_commands:propagate_to_nearby_clients", {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(140, 140, 140, 0.6); border-radius: 3px; font-size:18px;"> (OOC) {0}: {1}</div>',
            args = { fal, msg }
    }, 15.0)

end, "Talk in local ooc")

register_command("tpm", function(source, args, raw)

    local waypoint_coords = GetBlipCoords(GetFirstBlipInfoId(8))
    local _, z = GetGroundZFor_3dCoord(waypoint_coords.x, waypoint_coords.y, waypoint_coords.z+100)
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), waypoint_coords.x, waypoint_coords.y, z+1)
    FreezeEntityPosition(PlayerPedId(), false)

end, "Teleport to marker")


register_command("pos", function(source, args, rawCommand)

    local coords = GetEntityCoords(PlayerPedId())
    print(json.encode(coords))
    TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(140, 140, 140, 0.6); border-radius: 3px; font-size:18px;"> (POS) X: {0}, Y: {1}, Z: {2} </div>',
            args = { coords.x, coords.y, coords.z }
    })

end, "Give your position")