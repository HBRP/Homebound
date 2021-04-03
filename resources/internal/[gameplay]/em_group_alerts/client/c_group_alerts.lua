
local sprites = {
    "10-32" = {color = 39, sprite = 156}
}

AddEventHandler("em_group_alerts:send_dispatch", function(group_alert_name, code, title, priority, requesting_officer)

    local coords = GetEntityCoords(PlayerPedId())
    local street_name, crossing_road = GetStreetNameAtCoord(coords.x, coords.y, coords.z)

    local street = GetStreetNameFromHashKey(street_name)
    if crossing_road ~= 0 then
        street = string.format("%s | %s", street, GetStreetNameFromHashKey(crossing_road))
    end

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
        officer = requesting_officer or ""
    }
    TriggerServerEvent("em_group_alerts:send_alert", "Law Enforcement", data)

end)