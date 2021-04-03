
local sprites = {
    ["10-31b"] = {color = 39, sprite = 156}
}

AddEventHandler("em_group_alerts:send_dispatch", function(group_alert_name, code, title, priority, requesting_officer)

    print("here")
    local coords = GetEntityCoords(PlayerPedId())
    local street_name, crossing_road = GetStreetNameAtCoord(coords.x, coords.y, coords.z)

    local street = GetStreetNameFromHashKey(street_name)
    if crossing_road ~= 0 then
        street = string.format("%s | %s", street, GetStreetNameFromHashKey(crossing_road))
    end

    assert(sprites[code] ~= nil, string.format("Code %s not specified in sprites table", code))
    local data = {
        code = code,
        street = street,
        priority = 1,
        title = title,
        position = {
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        blipname = title,
        color = sprites[code].color,
        sprite = sprites[code].sprite,
        fadeOut = 30,
        duration = 5000,
        officer = requesting_officer or "N/A"
    }
    TriggerServerEvent("em_group_alerts:send_alert", "Law Enforcement", data)

end)