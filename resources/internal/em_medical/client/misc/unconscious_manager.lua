

function Respawn(inplace)
    
    SetPlayerInvincible(PlayerId(), false)
	local oX,oY,oZ = table.unpack(GetEntityCoords(ped))
	if not inplace then
        oX, oY, oZ = -259.41, 6319.14, 32.44
        heal_player()
        rest_stats()
    else
        reset_stats()
		TriggerEvent("alerts:add", {255, 255, 255}, {40, 183, 40}, "System", "You have been revived! Go forth and do great things!")
    end
    SetEntityCoords(ped, oX, oY, oZ)
    ClearPedTasksImmediately(ped)

end

local function unconscious_loop()

    local total_seconds = 0
    local seconds = 0
    local minutes = 0
    local respawn_timer_finished = false
    local died_at_time = GetGameTimer()

    while true do

        local current_time = GetGameTimer()
        if is_player_unconscious() then
            --DisableAllActions()
			if(current_time < died_at_time + REVIVE_WAIT_PERIOD) then
                total_seconds = math.floor((died_at_time + REVIVE_WAIT_PERIOD - current_time) / 1000)
                minutes = math.floor(total_seconds / 60)
                seconds = math.floor(total_seconds % 60)
				draw_txt("You can call Local EMS in ~r~" .. minutes .. " ~w~min ~r~" .. seconds .. " ~w~sec", 2, {255, 255, 255}, 0.5, 0.315, 0.882)
				respawn_timer_finished = false
			else
				respawn_timer_finished = true
            end
            
            if respawn_timer_finished and IsControlPressed(0, 46) and MStillHoldControlAccepted then
				local StrMsg = string.format('Calling Local EMS %s', math.floor((PLAYER_RESPAWN_HOLD_TIME + current_time - MStillHoldControlAccepted) / 10))
				draw_txt(StrMsg, 2, {255, 255, 255}, 0.5, 0.4, 0.882)
                if (current_time >= MStillHoldControlAccepted) then
                    
                    ClearPedTasksImmediately(ped)
                    Respawn(false)
                    break

				end

			elseif respawn_timer_finished then
				draw_txt("~g~E~w~ to call Local EMS", 2, {255, 255, 255}, 0.5, 0.4, 0.882)
				MStillHoldControlAccepted = current_time + PLAYER_RESPAWN_HOLD_TIME
			end

        else
            break
        end
        Wait(5)

    end

end

function start_unconscious_loop()

    Citizen.CreateThread(unconscious_loop)

end