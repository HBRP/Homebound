
local unique_alert_id = 1

RegisterNetEvent("em_group_alerts:send_alert")
AddEventHandler("em_group_alerts:send_alert", function(group_alert_name, group_alert_info)

    local character_jobs = exports["em_dal"]:get_all_characters_with_group_name(group_alert_name)

    group_alert_info.id = unique_alert_id
    unique_alert_id = unique_alert_id + 1
    
    for i = 1, #character_jobs do
        TriggerClientEvent("dispatch:clNotify", character_jobs[i].source, group_alert_info)
    end

end)