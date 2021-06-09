
local nearby_customization = {}
local manual_customization_points = {}

local customization_type_ids = {

    CLOTHING_SHOP = 1,
    BARBER_SHOP   = 2,
    SURGERY_SHOP  = 3

}

local function open_selected_customization(customization_point)

    if customization_point.customization_type_id == customization_type_ids.CLOTHING_SHOP then
        open_clothing_store()
    elseif customization_point.customization_type_id == customization_type_ids.BARBER_SHOP then
        open_barber_store()
    elseif customization_point.customization_type_id == customization_type_ids.SURGERY_SHOP then
        open_surgery_store()
    end

end

local function customization_loop()

    local nearby_point = false
    local draw_text_id = -1
    while true do

        Citizen.Wait(5)
        ped_coords = GetEntityCoords(PlayerPedId())

        for i = 1, #nearby_customization do

            if GetDistanceBetweenCoords(ped_coords.x, ped_coords.y, ped_coords.z, nearby_customization[i].x, nearby_customization[i].y, nearby_customization[i].z, true) < 2 then

                nearby_point = true
                if not exports["cd_drawtextui"]:is_in_queue(draw_text_id) then
                    draw_text_id = exports["cd_drawtextui"]:show_text(string.format("Press [E] to open %s.<br> Press [G] to open outfit selector", nearby_customization[i].customization_name))
                end
                if IsControlJustReleased(0, 38) then
                    open_selected_customization(nearby_customization[i])
                elseif IsControlJustReleased(0, 47) then
                    TriggerEvent("cui_wardrobe:open")
                end
            end

        end
        if not nearby_point then
            exports["cd_drawtextui"]:hide_text(draw_text_id)
            Citizen.Wait(500)
        end
        nearby_point = false

    end

end

local function refresh_nearby_customization(result)

    nearby_customization = result
    if nearby_customization == nil then
        nearby_customization = {}
    end

    for i = 1, #manual_customization_points do
        table.insert(nearby_customization, manual_customization_points[i])
    end

end

local function refresh_nearby_customization_loop()

    local player_coords = GetEntityCoords(PlayerPedId())
    while true do

        Citizen.Wait(5000)
        local new_coords = GetEntityCoords(PlayerPedId())
        if #(player_coords - new_coords) > 50.0 then
            player_coords = new_coords
            exports["em_dal"]:get_nearby_customization_points_async(refresh_nearby_customization)
        end
        
    end

end

function register_manual_customization_spots(customization_spots)

    for i = 1, #customization_spots do
        assert(customization_spots[i].customization_type_id ~= nil, "register_manual_customization_spot: Error, did not set customization_type_id")
    end
    manual_customization_points = customization_spots

end

function deregister_manual_customization_spots()

    manual_customization_points = {}

end

function get_character_appearance()

    local skin = exports["em_dal"]:get_skin()
    assert(skin ~= nil, "Skin was not null")
    return skin["character_skin"]

end

function refresh_character_appearance()

    local appearance = get_character_appearance()
    exports['fivem-appearance']:setPlayerAppearance(appearance)

end

Citizen.CreateThread(refresh_nearby_customization_loop)
Citizen.CreateThread(customization_loop)