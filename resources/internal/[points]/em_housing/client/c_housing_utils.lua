
local created_objects = {}

local function load_model(hash)

    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(5)
    end

end

local function create_shell(house)

    local hash = GetHashKey(house.housing_shell_name)
    load_model(hash)

    local obj = CreateObject(hash, house.spawn_x, house.spawn_y, house.spawn_z, false, true, false)
    FreezeEntityPosition(obj, true)
    table.insert(created_objects, obj)

end

local function create_objects(house, objects)

    for i = 1, #objects do

        load_model(objects[i].prop_hash)

        local x = house.spawn_x + objects[i].x_offset
        local y = house.spawn_y + objects[i].y_offset
        local z = house.spawn_z + objects[i].z_offset

        local obj = CreateObject(objects[i].prop_hash, x, y, z, false, true, false)
        SetEntityHeading(obj, objects[i].heading_offset)
        FreezeEntityPosition(obj, objects[i].freeze_object)

        table.insert(created_objects, obj)

    end

end

function spawn_house(callback, house)

    exports["em_fw"]:get_house_async(function(house_data)

        create_shell(house_data.house)
        create_objects(house_data.house, house_data.house_objects)
        print("Created objects. Calling back now.")
        callback()

    end, house.house_id)

end

function despawn_house()

    for i = 1, #created_objects do
        DeleteObject(created_objects[i])
    end
    created_objects = {}

end