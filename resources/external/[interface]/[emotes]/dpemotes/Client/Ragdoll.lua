local isInRagdoll = false
local ped = nil

local function ragdoll_loop()
    
    while true do
        Citizen.Wait(10)
        if isInRagdoll then
            SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
        end
    end

end

exports["em_commands"]:register_command_no_perms("ragdoll", function(source, args, raw)

    isInRagdoll = not isInRagdoll
    if not isInRagdoll then
        return
    end

    ped = PlayerPedId()
    Citizen.CreateThread(ragdoll_loop)

end, "Toggle Ragdolling")