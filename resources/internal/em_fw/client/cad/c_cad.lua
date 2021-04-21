
function cad_get_charges_async(callback)

    trigger_server_callback_async("em_fw:cad_get_charges", callback)

end

function cad_get_latest_cad_reports_async(callback)

    trigger_server_callback_async("em_fw:cad_get_latest_cad_reports", callback)

end

function cad_search_for_character_async(callback, character_info)

    trigger_server_callback_async("em_fw:cad_perform_character_search", callback, character_info)

end

function cad_get_character_details_async(callback, character_id)

    trigger_server_callback_async("em_fw:cad_get_character_details", callback, character_id)

end

function cad_new_report_async(callback, character_id, title, incident, charges, author, name)

    trigger_server_callback_async("em_fw:cad_new_report", callback, get_character_id(), character_id, title, incident, charges, author, name, incident_date)

end

function cad_get_report_async(callback, cad_report_id)

    trigger_server_callback_async("em_fw:cad_get_report", callback, cad_report_id)

end