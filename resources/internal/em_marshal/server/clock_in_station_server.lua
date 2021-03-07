ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("clock_in_toggle")
AddEventHandler("clock_in_toggle", function()

    local source = source
    local xPlayer = ESX.GetPlayerFromId(source) 
    local job = xPlayer.getJob()
    if string.match(job.name, "off") then


        local job_name = string.sub(job.name, 4)
        xPlayer.setJob(string.sub(job.name, 4), job.grade - 5)
        TriggerClientEvent(job_name .. "_clock_in", source)
        TriggerClientEvent("mythic_notify:client:SendAlert", source, {type = "inform", text = job_name .. " - Clocked on", length = "5000"})

    else

        local job_name = job.name
        xPlayer.setJob("off"..job.name, job.grade + 5)
        TriggerClientEvent(job_name .. "_clock_off", source)
        TriggerClientEvent("mythic_notify:client:SendAlert", source, {type = "inform", text = job_name .. " - Clocked off", length = "5000"})

    end
    
end)