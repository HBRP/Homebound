
local unique_id = 0
local callbacks = {}

function show_dialog(title, dialog)

    callbacks = {}
    for i = 1, #dialog do

        dialog[i].callback_id = unique_id
        unique_id = unique_id + 1
        table.insert(callbacks, {callback_id = dialog[i].callback_id, callback = dialog[i].callback})

    end
    SendNUIMessage({display = "show_dialog", dialog = dialog, title = title})
    SetNuiFocus(true, true)

end

function hide_dialog()

    SendNUIMessage({display = "hide"})
    SetNuiFocus(false, false)

end

RegisterNUICallback('callback_option', function(data, cb)

    for i = 1, #callbacks do

        if callbacks[i].callback_id == data.callback_id then
            callbacks[i].callback()
            break
        end

    end

    cb("ok")

end)

RegisterNUICallback('hide', function(data, cb)

    hide_dialog()
    cb("ok")

end)