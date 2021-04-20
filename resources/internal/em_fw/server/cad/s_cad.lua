

register_server_callback("em_fw:get_latest_cad_reports", function(source, callback)

    HttpGet("/Cad/Latest/Reports", nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)