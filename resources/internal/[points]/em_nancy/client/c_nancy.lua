
local anim_dict      = "missfam4"
local clipboard_prop = GetHashKey("p_amb_clipboard_01")
local prop = nil

local function load_prop()

    RequestModel(clipboard_prop)

    while not HasModelLoaded(clipboard_prop) do
        Citizen.Wait(25)
    end

    local ped_coords = GetEntityCoords(PlayerPedId())
    prop = CreateObject(clipboard_prop, ped_coords.x, ped_coords.y, ped_coords.z+0.2, true, true, true)
    AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 36029), 0.16, 0.08, 0.1, -130.0, -50.0, 0.0, true, true, false, true, 1, true)

end

local function load_animation()

    RequestAnimDict(anim_dict)

    while not HasAnimDictLoaded(anim_dict) do
        Citizen.Wait(25)
    end

    TaskPlayAnim(PlayerPedId(), anim_dict, "base", 8.0, 8.0, 5000, 2 + 16 + 32, 1.0, 0, 0, 0)

end

local function clean_up()

    DeleteEntity(prop)
    ClearPedTasksImmediately(PlayerPedId())

end

local function handle_animations()

    load_animation()
    load_prop()

    exports["rprogress"]:Custom({
        Async    = false,
        Duration = 5000,
        Label = "Checking in"
    })
    
    clean_up()

end

local function handle_healing(idx)

    local laying_down_dict = "anim@gangops@morgue@table@"
    RequestAnimDict(laying_down_dict)

    while not HasAnimDictLoaded(laying_down_dict) do
        Citizen.Wait(25)
    end

    SetEntityCoords(PlayerPedId(), beds[idx].coords)
    SetEntityHeading(PlayerPedId(), beds[idx].heading - 180.0)
    TaskPlayAnim(PlayerPedId(), laying_down_dict, "body_search", 8.0, 8.0, 10000, 2, 1.0, 0, 0, 0)

    exports["rprogress"]:Custom({
        Async    = false,
        Duration = 30000,
        Label = "Receiving Medical Care"
    })
    ClearPedTasksImmediately(PlayerPedId())
    exports["em_fw"]:trigger_server_callback_async("em_nancy:free_bed", function() end, idx)

end

AddEventHandler("pillbox_nancy", function()


    exports["em_fw"]:trigger_server_callback_async("em_nancy:get_empty_bed", function(idx)

        if idx == 0 then
            exports["t-notify"]:Alert({style = "error", message = "No Free beds"})
            return
        end

        handle_animations()
        handle_healing(idx)

    end)

end)