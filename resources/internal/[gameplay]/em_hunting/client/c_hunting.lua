

AddEventHandler("animal_cutting", function(prop, entity)

    if not exports["em_items"]:does_character_have_knife() then
        exports["t-notify"]:Alert({style="error", message="You need to have a knife"})
        return
    end

    print(entity)
    exports["t-notify"]:Alert({style="info", message="Skinned Animal"})
    DeleteEntity(entity)

end)