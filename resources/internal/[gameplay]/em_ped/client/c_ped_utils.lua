
local function can_ped_realistically_see_me(ped)

    if is_ped_an_animal(ped) then
        return false
    end

    if IsPedAPlayer(ped) then
        return false
    end

    if IsEntityDead(ped) then
        return false
    end

    if not HasEntityClearLosToEntityInFront(ped, PlayerPedId()) then
        return false
    end

    return true

end

function does_any_ped_see_me()

    local ped = PlayerPedId()
    local ped_coords = GetEntityCoords(ped)
    local other_coords = nil

    for other_ped in exports["em_fw"]:enumerate_peds() do

        other_coords = GetEntityCoords(other_ped)
        if #(other_coords - ped_coords) < 30.0 then

            if can_ped_realistically_see_me(other_ped) then
                return true
            end

        end

    end

    return false

end

function is_ped_an_animal(ped)

    return GetPedType(ped) == 28

end