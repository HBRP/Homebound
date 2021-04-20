
function get_charges_async(callback)

    trigger_server_callback_async("em_fw:get_charges", callback)

end

function get_latest_cad_reports_async(callback)

    trigger_server_callback_async("em_fw:get_latest_cad_reports", callback)

end