
AddEventHandler("animal_cutting", function(prop, entity)

    if not exports["em_items"]:does_character_have_knife() then
        exports["t-notify"]:Alert({style="error", message="You need to have a knife"})
        return
    end

    if not IsEntityDead(entity) then
        exports["t-notify"]:Alert({style="error", message="Animal isn't dead!"})
        return
    end

    exports["t-notify"]:Alert({style="info", message="Skinned Animal"})
    exports["em_fw"]:trigger_proximity_event("em_hunting:delete_entity", 100.0, NetworkGetNetworkIdFromEntity(entity))

end)

RegisterNetEvent("em_hunting:delete_entity")
AddEventHandler("em_hunting:delete_entity", function(entity_network_id)

    local entity = NetworkGetEntityFromNetworkId(entity_network_id)
    DeleteEntity(entity)

end)