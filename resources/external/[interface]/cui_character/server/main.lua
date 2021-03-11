
RegisterCommand("character", function(source, args, rawCommand)
    if (source > 0) then
        TriggerClientEvent('cui_character:open', source, { 'features', 'style', 'apparel' })
    end
end, true)

RegisterCommand("features", function(source, args, rawCommand)
    if (source > 0) then
        TriggerClientEvent('cui_character:open', source, { 'features' })
    end
end, true)

RegisterCommand("style", function(source, args, rawCommand)
    if (source > 0) then
        TriggerClientEvent('cui_character:open', source, { 'style' })
    end
end, true)

RegisterCommand("apparel", function(source, args, rawCommand)
    if (source > 0) then
        TriggerClientEvent('cui_character:open', source, { 'apparel' })
    end
end, true)