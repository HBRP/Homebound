
local animation_flags = {

    ANIM_FLAG_NORMAL = 0,
    ANIM_FLAG_REPEAT = 1,
    ANIM_FLAG_STOP_LAST_FRAME = 2,
    ANIM_FLAG_UPPERBODY = 16,
    ANIM_FLAG_ENABLE_PLAYER_CONTROL = 32,
    ANIM_FLAG_CANCELABLE = 120

}


function play_animation_sync(dict, anim, duration, enum_flags)

    ClearPedTasks(ped)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(5)
    end

    TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 8.0, duration, enum_flags, 1.0, false, false, false)

    Citizen.Wait(duration)
    ClearPedTasks(ped)

end