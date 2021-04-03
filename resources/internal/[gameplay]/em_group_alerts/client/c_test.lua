
exports["em_commands"]:register_command("test_dispatch", function(source, args, raw_command)

    local coords = GetEntityCoords(PlayerPedId())
    local street_name, crossing_road = GetStreetNameAtCoord(coords.x, coords.y, coords.z)


    local test_data = {
        code = "10-40",
        street = GetStreetNameFromHashKey(street_name),
        priority = 1,
        title = "Test dispatch",
        position = {
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        blipname = "Test dispatch",
        color = 2,
        sprite = 304,
        fadeOut = 30,
        duration = 5000,
        officer = "Test officername"
    }
    TriggerServerEvent("em_group_alerts:send_alert", "Law Enforcement", test_data)

end, "Test dispatch system")