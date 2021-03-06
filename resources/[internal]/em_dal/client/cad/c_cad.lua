
function cad_get_charges_async(callback)

    trigger_server_callback_async("em_dal:cad_get_charges", callback)

end

function cad_get_latest_cad_reports_async(callback)

    trigger_server_callback_async("em_dal:cad_get_latest_cad_reports", callback)

end

function cad_search_for_character_async(callback, character_info)

    trigger_server_callback_async("em_dal:cad_perform_character_search", callback, character_info)

end

function cad_get_character_details_async(callback, character_id)

    trigger_server_callback_async("em_dal:cad_get_character_details", callback, character_id)

end

function cad_new_report_async(callback, character_id, title, incident, charges, author, name)

    trigger_server_callback_async("em_dal:cad_new_report", callback, get_character_id(), character_id, title, incident, charges, author, name, incident_date)

end

function cad_get_report_async(callback, cad_report_id)

    trigger_server_callback_async("em_dal:cad_get_report", callback, cad_report_id)

end

function cad_delete_report_async(callback, cad_report_id)

    trigger_server_callback_async("em_dal:cad_delete_report", callback, get_character_id(), cad_report_id)

end

function cad_get_all_warrants_async(callback)

    trigger_server_callback_async("em_dal:cad_get_all_warrants", callback)

end

function cad_search_reports_async(callback, query)

    trigger_server_callback_async("em_dal:cad_search_reports", callback, query)

end

function cad_search_vehicle_async(callback, plate)

    trigger_server_callback_async("em_dal:cad_search_vehicle", callback, plate)

end

function cad_get_vehicle_details_async(callback, character_id, plate)

    trigger_server_callback_async("em_dal:cad_get_vehicle_details", callback, character_id, plate)

end

function cad_update_vehicle(plate, notes, stolen)

    trigger_server_callback_async("em_dal:cad_update_vehicle", nil, get_character_id(), plate, notes, stolen)

end

function cad_update_character_details_async(callback, character_id, changes)

    trigger_server_callback_async("em_dal:cad_update_character_details", callback, get_character_id(), character_id, changes)

end

function cad_update_report_async(callback, cad_report_id, title, incident)

    trigger_server_callback_async("em_dal:cad_update_report", callback, get_character_id(), cad_report_id, title, incident)

end

function cad_new_warrant_async(callback, character_id, report_id, report_title, notes, charges, author, name)

    trigger_server_callback_async("em_dal:cad_new_warrant", callback, get_character_id(), character_id, report_id, report_title, notes, charges, author, name)

end

function cad_delete_warrant_async(callback, cad_warrant_id)

    trigger_server_callback_async("em_dal:cad_delete_warrant", callback, get_character_id(), cad_warrant_id)

end