
local created_objects = {}
local clothing_points = {}

local function load_model(hash)

    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(5)
    end

end

local function create_shell(house)

    local hash = GetHashKey(house.housing_shell_name)
    load_model(hash)

    local obj = CreateObject(hash, house.spawn_x, house.spawn_y, house.spawn_z, false, false, false)
    FreezeEntityPosition(obj, true)
    table.insert(created_objects, obj)

end

local function create_objects(house, objects)

    for i = 1, #objects do

        load_model(objects[i].prop_hash)

        local x = house.spawn_x + objects[i].x_offset
        local y = house.spawn_y + objects[i].y_offset
        local z = house.spawn_z + objects[i].z_offset

        local obj = CreateObject(objects[i].prop_hash, x, y, z, false, false, false)
        SetEntityHeading(obj, objects[i].heading_offset)
        FreezeEntityPosition(obj, objects[i].freeze_object)

        table.insert(created_objects, obj)

    end

end

local function setup_clothing(house, clothing_points)

    for i = 1, #clothing_points do

        clothing_points[i].x = house.spawn_x + clothing_points[i].x_offset
        clothing_points[i].y = house.spawn_y + clothing_points[i].y_offset
        clothing_points[i].z = house.spawn_z + clothing_points[i].z_offset
        clothing_points[i].customization_type_id = 1
        clothing_points[i].customization_name = "Clothing Picker"

    end
    exports["em_customization"]:register_manual_customization_spots(clothing_points)

end

local function setup_storage(house_id, house)

    exports["em_dal"]:trigger_server_callback_async("em_housing:get_motel_storage", function(storage_points)

        for i = 1, #storage_points do

            storage_points[i].x = house.spawn_x + storage_points[i].x_offset
            storage_points[i].y = house.spawn_y + storage_points[i].y_offset
            storage_points[i].z = house.spawn_z + storage_points[i].z_offset

        end
        exports["em_storage"]:register_manual_stashes(storage_points)

    end, house_id)

end

function spawn_house(callback, house)

    exports["em_dal"]:get_house_async(function(house_data)

        create_shell(house_data.house)
        create_objects(house_data.house, house_data.house_objects)
        setup_clothing(house_data.house, house_data.clothing_points)
        setup_storage(house.house_id, house_data.house)
        callback()

    end, house.house_id)

end

function despawn_house()

    for i = 1, #created_objects do
        DeleteObject(created_objects[i])
    end

    exports["em_customization"]:deregister_manual_customization_spots()
    exports["em_storage"]:deregister_manual_stashes()

    created_objects = {}
    clothing_points = {}

end