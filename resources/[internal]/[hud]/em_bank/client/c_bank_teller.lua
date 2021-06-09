
robbing_bank_teller = false

local function distance_check_loop(point)

	local point_coords = vector3(point.x, point.y, point.z)
	while robbing_bank_teller do

		Citizen.Wait(500)
		if #(GetEntityCoords(PlayerPedId()) - point_coords) > 15.0 then

			exports["rprogress"]:Stop()
			exports['t-notify']:Alert({style = "error", message = "Too far away from bank teller"})
			robbing_bank_teller = false

		end

	end

end

local function payout_robber(point)

	exports["em_dal"]:trigger_server_callback("em_bank:robbed_bank_teller", function(payout)

		exports['t-notify']:Alert({style = "success", message = string.format("Received $%d", payout), duration = 5000})

	end, point.interaction_point_id)

end

local function begin_bank_teller_robbing(point)

	exports["em_dal"]:trigger_server_callback("em_bank:start_rob_teller", function()

		robbing_bank_teller = true
		exports["rprogress"]:Custom({
		    Async    = true,
		    Duration = 60 * 1000 * 3,
		    Label = "Robbing bank teller",
		    onComplete = function(data, cb)
		        robbing_store = false
		        payout_robber(point)
		    end
		})
		Citizen.CreateThread(function() distance_check_loop(point) end)

	end, point.interaction_point_id)

end

local function rob_bank_teller_dialog(point)

	dialog   = "[Attempt to Rob Teller]"
	response = nil
	callback = nil

	exports["em_dal"]:trigger_server_callback("em_bank:can_rob_bank_teller", function(can_rob)

		if can_rob then

			response = "The bank teller triggers the silent alarm before complying."
			callback = function()

				exports["em_dialog"]:hide_dialog()
				TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "Bank Teller", "Silent alarm triggered by bank teller", 2)
				begin_bank_teller_robbing(point)

			end

		else

			response = '"We just got robbed" - says the bank teller, who then triggers the silent alarm'
			callback = function()

				exports["em_dialog"]:hide_dialog()
				TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "Bank Teller", "Silent alarm triggered once again by bank teller", 2)

			end

		end

	end, point.interaction_point_id)

	return {
		dialog = dialog,
		response = response,
		callback = callback
	}

end

AddEventHandler("bank_teller", function(point)

	exports["rprogress"]:Stop()
	local dialog = {
		{
			dialog = "[Use Bank]",
			callback = function()
				TriggerEvent("em_bank:open_bank")
				exports["em_dialog"]:hide_dialog()
			end
		}
	}
	table.insert(dialog, rob_bank_teller_dialog(point))

	exports["em_dialog"]:show_dialog("Bank Teller", dialog)

end)