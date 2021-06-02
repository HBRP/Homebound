
local unique_id = 0
local callbacks = {}

function upload_photo_async(callback, photo)

	trigger_server_callback_async("em_dal:player_session_token", function(session_token)

		local data = 
		{
			id = unique_id, 
			upload_photo = true, 
			session_token = session_token, 
			photo = photo, 
			endpoint = GetConvar("photo_uploader_service", "")
		}

		table.insert(callbacks, {id = unique_id, callback = callback})
		unique_id = unique_id + 1

		SendNUIMessage(data)

	end)

end

RegisterNUICallback("em_dal_photo", function(data, cb)

	for i = 1, #callbacks do

		if callbacks[i].id == data.id then

			callbacks[i].callback(data.link)
			table.remove(callbacks, i)
			break

		end

	end
	cb()

end)