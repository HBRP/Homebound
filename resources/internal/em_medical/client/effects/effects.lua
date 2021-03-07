RequestAnimDict("missarmenian2")

register_effect_function(EFFECTS.KNOCKED_OUT, "intro", function() 

    DoScreenFadeOut(1000)
    SetPedToRagdollWithFall(ped, PLAYER.SHORTERM_EFFECTS["Knocked Out"].effect_time + 1000, PLAYER.SHORTERM_EFFECTS["Knocked Out"].effect_time + 1000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

end)

register_effect_function(EFFECTS.KNOCKED_OUT, "outro", function() 

    if IsScreenFadedOut() then
        DoScreenFadeIn(1500)
    end

end)

register_effect_function(EFFECTS.BLACK_OUT, "intro", function() 

    DoScreenFadeOut(2000)

end)

register_effect_function(EFFECTS.BLACK_OUT, "outro", function() 

    DoScreenFadeIn(1500)

end)

register_effect_function(EFFECTS.ADRENALINE, "intro", function() 

    PlaySoundFrontend(-1, "FocusIn", "HintCamSounds", 1)
    AnimpostfxPlay("FocusIn", 500, false)

end)

register_effect_function(EFFECTS.ADRENALINE, "loop", function() 

    pain_level_modifier(-0.5)

end)

register_effect_function(EFFECTS.ADRENALINE, "outro", function() 

    apply_short_term_effect(EFFECTS.NO_ADRENALINE)

end)

register_effect_function(EFFECTS.NO_ADRENALINE, "intro", function() 

    PlaySoundFrontend(-1, "FocusOut", "HintCamSounds", 1)
    AnimpostfxStop("FocusIn")
    AnimpostfxPlay("FocusOut", 500, false)

end)

register_effect_function(EFFECTS.NO_ADRENALINE, "loop", function() 

    pain_level_modifier(0.20)

end)

register_effect_function(EFFECTS.SHOCK, "intro", function() 

    start_unconscious_loop()
    SetPedToRagdollWithFall(ped, 3000, 3000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

end)

register_effect_function(EFFECTS.SHOCK, "loop", function() 

    pain_level_set(0)
    if not DoesEntityExist(GetVehiclePedIsIn(ped, false)) and not IsEntityPlayingAnim(ped, "missarmenian2", "corpse_search_exit_ped", 2) then
        TaskPlayAnim(ped, "missarmenian2", "corpse_search_exit_ped", 100.0, -100.0, -1, 2, 1.0, false, false, false)
    end

end)

register_effect_function(EFFECTS.SHOCK, "outro", function() 

    ClearPedTasksImmediately(ped)

end)

register_effect_function(EFFECTS.LIMPING, "intro", function() 



end)

register_effect_function(EFFECTS.LIMPING, "loop", function() 



end)

register_effect_function(EFFECTS.LIMPING, "outro", function() 



end)

register_effect_function(EFFECTS.TAZED, "intro", function() 

    DoScreenFadeOut(2000)
    FreezeEntityPosition(ped, true)

end)


register_effect_function(EFFECTS.TAZED, "loop", function() 


end)

register_effect_function(EFFECTS.TAZED, "outro", function() 

    DoScreenFadeIn(1500)
    FreezeEntityPosition(ped, false)
    
end)