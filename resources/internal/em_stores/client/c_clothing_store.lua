

function open_clothing_store()

    local config = {
        ped = false,
        headBlend = false,
        faceFeatures = false,
        headOverlays = false,
        components = true,
        props = true
    }

    TriggerEvent("cd_drawtextui:temp_hide_text")
    exports['fivem-appearance']:startPlayerCustomization(function(appearance)

        if appearance then
            exports["em_fw"]:update_skin(json.encode(appearance))
            TriggerEvent("cui_wardrobe:open")
        end
        TriggerEvent("cd_drawtextui:temp_show_text")
        
    end, config)

end

function open_barber_store()

    local config = {
        ped = false,
        headBlend = false,
        faceFeatures = false,
        headOverlays = true,
        components = false,
        props = false
    }

    TriggerEvent("cd_drawtextui:temp_hide_text")
    exports['fivem-appearance']:startPlayerCustomization(function(appearance)

        if appearance then
            exports["em_fw"]:update_skin(json.encode(appearance))
        end
        TriggerEvent("cd_drawtextui:temp_show_text")

    end, config)

end

function open_surgery_store()

    local config = {
        ped = false,
        headBlend = true,
        faceFeatures = true,
        headOverlays = false,
        components = false,
        props = false
    }

    TriggerEvent("cd_drawtextui:temp_hide_text")
    exports['fivem-appearance']:startPlayerCustomization(function(appearance)

        if appearance then
            exports["em_fw"]:update_skin(json.encode(appearance))
        end
        TriggerEvent("cd_drawtextui:temp_show_text")

    end, config)

end