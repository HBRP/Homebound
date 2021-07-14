

RegisterServerEvent("em_drag:drag_request")
AddEventHandler("em_drag:drag_request", function(other_server_id)

	TriggerClientEvent("em_drag:drag_request", other_server_id, source)

end)

RegisterServerEvent("em_drag:drag_response")
AddEventHandler("em_drag:drag_response", function(initial_requesting_source, getting_dragged)

	TriggerClientEvent("em_drag:drag_response", initial_requesting_source, source, getting_dragged)

end)