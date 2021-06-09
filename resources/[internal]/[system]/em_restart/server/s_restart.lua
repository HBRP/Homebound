
local resources = {

    'fivem-appearance',
    'cui_wardrobe',
    'em_customization',
    'em_stores',
    'em_housing'

}

Citizen.CreateThread(function()

    Citizen.Wait(5000)
    for i = 1, #resources do
        ExecuteCommand(string.format("stop %s", resources[i]))
        Citizen.Wait(100)
    end
    for i = 1, #resources do
        ExecuteCommand(string.format("start %s", resources[i]))
        Citizen.Wait(100)
    end

end)