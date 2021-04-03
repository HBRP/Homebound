
local group_alerts = {}
local group_subscriptions = {}

local unique_alert_id = 1

local function get_group_alert_id(group_alert_name)

    for i = 1, #group_alerts do
        if group_alerts[i].group_alert_name == group_alert_name then
            return group_alerts[i].group_alert_id
        end
    end
    assert(0, string.format("Could not find group_alert_name %s", group_alert_name))

end

local function get_group_ids(group_alert_id)

    local group_ids = {}
    for i = 1, #group_subscriptions do
        if group_subscriptions[i].group_alert_id == group_alert_id then
            table.insert(group_ids, group_subscriptions[i].group_id)
        end
    end

    return group_ids

end

RegisterNetEvent("em_group_alerts:send_alert")
AddEventHandler("em_group_alerts:send_alert", function(group_alert_name, group_alert_info)

    local group_alert_id = get_group_alert_id(group_alert_name)
    local group_ids = get_group_ids(group_alert_id)
    local current_jobs = exports["em_fw"]:get_current_character_jobs()

    group_alert_info.id = unique_alert_id
    unique_alert_id = unique_alert_id + 1
    
    for i = 1, #current_jobs do
        for j = 1, #group_ids do
            if current_jobs[i].job.group_id == group_ids[j] then
                TriggerClientEvent("dispatch:clNotify", current_jobs[i].source, group_alert_info)
            end
        end
    end

end)

Citizen.CreateThread(function()

    Citizen.Wait(0)
    exports["em_fw"]:get_group_alerts(function(result)
        group_alerts = result or {}
    end)
    exports["em_fw"]:get_group_alert_subscriptions(function(result)
        group_subscriptions = result or {}
    end)

end)