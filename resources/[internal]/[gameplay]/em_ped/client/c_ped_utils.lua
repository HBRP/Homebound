
local function is_ped_in_line_of_sight(ped, other_ped)

    if is_ped_an_animal(other_ped) then
        return false
    end

    if IsPedAPlayer(other_ped) then
        return false
    end

    if IsEntityDead(other_ped) then
        return false
    end

    if not HasEntityClearLosToEntityInFront(other_ped, ped) then
        return false
    end

    return true

end

function does_any_ped_see_ped(ped)

    local ped_coords = GetEntityCoords(ped)
    local other_coords = nil

    for other_ped in exports["em_dal"]:enumerate_peds() do

        other_coords = GetEntityCoords(other_ped)
        if #(other_coords - ped_coords) < 30.0 then

            if is_ped_in_line_of_sight(ped, other_ped) then
                return true
            end

        end

    end

    return false

end

function does_any_ped_see_me()

    return does_any_ped_see_ped(PlayerPedId())

end

function is_ped_an_animal(ped)

    return GetPedType(ped) == 28

end

function get_closest_player()

    local player_ped = PlayerPedId()
    local my_coords = GetEntityCoords(player_ped)
    local player_id = -1
    local closest_player_distance = 100000000
    
    for _, player in ipairs(GetActivePlayers()) do

        if player_ped == GetPlayerPed(player) then
            goto closest_player_continue
        end

        local distance = #(my_coords - GetEntityCoords(GetPlayerPed(player)))
        if distance < closest_player_distance then

            closest_player_distance = distance
            player_id = player

        end
        ::closest_player_continue::

    end
    return {player_id, closest_player_distance}

end