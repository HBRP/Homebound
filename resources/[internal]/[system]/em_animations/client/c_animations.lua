
local animation_flags = {

    ANIM_FLAG_NORMAL = 0,
    ANIM_FLAG_REPEAT = 1,
    ANIM_FLAG_STOP_LAST_FRAME = 2,
    ANIM_FLAG_UPPERBODY = 16,
    ANIM_FLAG_ENABLE_PLAYER_CONTROL = 32,
    ANIM_FLAG_CANCELABLE = 120

}


function play_animation_sync(dict, anim, duration, enum_flags)

    local ped = PlayerPedId()

    ClearPedTasks(ped)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(5)
    end

    TaskPlayAnim(ped, dict, anim, 2.0, 2.0, duration, enum_flags, 0, false, false, false)

    Citizen.Wait(duration)
    ClearPedTasks(ped)

end

function play_animation_cont(dict, anim, enum_flags)

    local ped = PlayerPedId()

    ClearPedTasks(ped)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(5)
    end

    TaskPlayAnim(ped, dict, anim, 2.0, 2.0, -1, enum_flags, 0, false, false, false)

end