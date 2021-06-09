RegisterNetEvent('cd_drawtextui:ShowUI')
AddEventHandler('cd_drawtextui:ShowUI', function(action, text)
	SendNUIMessage({
		action = action,
		text = text,
	})
end)

RegisterNetEvent('cd_drawtextui:HideUI')
AddEventHandler('cd_drawtextui:HideUI', function()
	SendNUIMessage({
		action = 'hide'
	})
end)

local unique_id  = 0
local active_id  = 0
local active_ids = {}

local hide_interface = false

function show_text(text)

    unique_id = unique_id + 1
    table.insert(active_ids, {id = unique_id, text = text, hide_time = GetGameTimer() + 3000})
    return unique_id 

end

function hide_text(id)

    for i = 1, #active_ids do
        if active_ids[i].id == id then
            table.remove(active_ids, i)
            break
        end
    end

end

function is_in_queue(id)

    for i = 1, #active_ids do
        if active_ids[i].id == id then
            return true
        end
    end
    return false

end

function clear_queue()

    active_ids = {}
    active_id  = 0
    SendNUIMessage({
        action = 'hide'
    })

end

local function hide_everything()

    SendNUIMessage({
        action = 'hide'
    })
    active_id = 0

end

local function show_next_text_in_queue()

    local timer = GetGameTimer()
    for i = 1, #active_ids do

        if timer < active_ids[i].hide_time then

            SendNUIMessage({action = "show", text = active_ids[i].text})
            active_id = active_ids[i].id
            return

        end

    end
    hide_everything()

end

Citizen.CreateThread(function()

    while true do

        Citizen.Wait(100)
        if hide_interface then
            goto continue
        end

        if #active_ids == 0 and active_id ~= 0 then
            hide_everything()
        elseif #active_ids > 0 then
            show_next_text_in_queue()
        end
        ::continue::

    end

end)

local function temp_hide_text()

    hide_interface = true
    SendNUIMessage({
        action = 'hide'
    })

end

local function temp_show_text()

    hide_interface = false
    if #active_ids > 0 then
        show_next_text_in_queue()
    end

end

AddEventHandler("closed_inventory", temp_show_text)
AddEventHandler("opened_inventory", temp_hide_text)
AddEventHandler("cd_drawtextui:temp_hide_text", temp_hide_text)
AddEventHandler("cd_drawtextui:temp_show_text", temp_show_text)