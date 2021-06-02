

register_server_callback("em_dal:upload_photo", function(source, callback, photo)

	local data = {photo = photo}
	HttpPost("/Photo/Upload", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)