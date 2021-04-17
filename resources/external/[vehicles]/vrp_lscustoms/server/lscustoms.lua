--[[
vRP Los Santos Customs V1.2
Credits - MythicalBro and マーモット#2533 for the vRP version and some bug fixes
/////License/////
Do not reupload/re release any part of this script without my permission
]]

RegisterServerEvent('getGarageInfo')
AddEventHandler('getGarageInfo', function()
	TriggerClientEvent('lockGarage',-1,tbl)
end)

AddEventHandler('playerDropped', function()
	for i,g in pairs(tbl) do
		if g.player then
			if source == g.player then
				g.locked = false
				g.player = nil
				TriggerClientEvent('lockGarage',-1,tbl)
			end
		end
	end
end)

RegisterServerEvent("LSC:buttonSelected")
AddEventHandler("LSC:buttonSelected", function(name, button)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		TriggerClientEvent("LSC:buttonSelected", source, name, button, vRP.tryFullPayment(vRP.getUserId(source), button.price or 0)) -- money
	end
end)

RegisterServerEvent("LSC:finished")
AddEventHandler("LSC:finished", function(veh)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.execute("vRP/update_vehicle_modifications", {user_id = user_id, vehicle = veh.model, modifications = json.encode({color = veh.color, extraColor = veh.extracolor, neon = veh.neon, neonColor = veh.neoncolor, xenonColor = veh.xenoncolor, smokeColor = veh.smokecolor, wheelType = veh.wheeltype, bulletProofTyres = veh.bulletProofTyres, windowTint = veh.windowtint, plateIndex = veh.plateindex, mods = veh.mods})})
	end
end)

RegisterServerEvent("LSC:applyModifications")
AddEventHandler("LSC:applyModifications", function (model, vehicle)
	local source = source
	local user_id = vRP.getUserId(source)
	if model and vehicle and user_id then
		local rows = vRP.query("vRP/get_vehicle_modifications", {user_id = user_id, vehicle = model})
		if #rows > 0 then
			local modifications = json.decode(rows[1].modifications)
			if modifications then
				TriggerClientEvent("LSC:applyModifications", source, vehicle, modifications)
			end
		end
	end
end)
