

--TriggerEvent('chat:addSuggestion', '/emotebind', 'Bind an emote', {{ name="key", help="num4, num5, num6, num7. num8, num9. Numpad 4-9!"}, { name="emotename", help="dance, camera, sit or any valid emote."}})

RegisterNetEvent('em_commands:propagate_to_nearby_clients:response')
AddEventHandler('em_commands:propagate_to_nearby_clients:response', function(id, content, proximity)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)

    if pid == myId or GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < proximity then
        TriggerEvent('chat:addMessage', content)
    end

end)


RegisterCommand("ad", function (source, args, raw)

    local msg = raw:sub(4)
    local fal = exports["em_fw"]:get_character_name()
    TriggerServerEvent("esx_rpchat:propagate_to_clients", {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(214, 168, 0, 1); border-radius: 3px;"> ({0}) Advertisement: {1}</div>',
        args = { fal, msg }
    })

end)

RegisterCommand("me", function (source, args, raw)

    local msg = raw:sub(4)
    local fal = exports["em_fw"]:get_character_name()
    TriggerServerEvent("em_commands:propagate_nearby_to_clients", {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(86, 125, 188, 0.6); border-radius: 3px;"> (me) {0}: {1}</div>',
            args = { name, message }
    }, 15.0)

end)

RegisterCommand("looc", function (source, args, raw)

    local msg = raw:sub(5)
    local fal = exports["em_fw"]:get_character_name()
    TriggerServerEvent("em_commands:propagate_nearby_to_clients", {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(41, 41, 41, 0.6); border-radius: 3px;"> (OOC) {0}: {1}</div>',
            args = { name, message }
    }, 15.0)

end)

Citizen.CreateThread(function()

    Citizen.Wait(0)
    TriggerEvent('chat:addSuggestion', '/me', 'Express yourself')
    TriggerEvent('chat:addSuggestion', '/looc', 'Talk in local ooc')
    TriggerEvent('chat:addSuggestion', '/ad', 'Send an advertisement')

end)