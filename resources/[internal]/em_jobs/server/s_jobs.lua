
local time_between_each_paychecks = 30 * 60 * 1000

local function send_paychecks()

    local current_jobs = exports["em_dal"]:get_current_character_jobs()
    for i = 1, #current_jobs do

        TriggerClientEvent("t-notify:client:Alert", current_jobs[i].source, {style = "info", message = string.format('Paid $%d', current_jobs[i].job.pay)})
        exports["em_dal"]:direct_deposit(current_jobs[i].character_id, current_jobs[i].job.pay)

    end


end

--[[
Citizen.CreateThread(function()

    while true do

        Citizen.Wait(time_between_each_paychecks)
        send_paychecks()

    end

end)
]]