
local robbed_banks = {}

exports["em_dal"]:register_server_callback("em_bank:can_rob_bank_teller", function(source, callback, interaction_point_id)

	for i = 1, #robbed_banks do

		if robbed_banks[i].interaction_point_id == interaction_point_id then
			callback(false)
			return
		end

	end
	callback(true)

end)

exports["em_dal"]:register_server_callback("em_bank:start_rob_teller", function(source, callback, interaction_point_id)

	for i = 1, #robbed_banks do

		if robbed_banks[i].interaction_point_id == interaction_point_id then
			-- Oddity Detected. Log
			return
		end

	end

	table.insert(robbed_banks, {interaction_point_id = interaction_point_id, next_rob_time = GetGameTimer() + 1000 * 10})
	callback()

end)

exports["em_dal"]:register_server_callback("em_bank:robbed_bank_teller", function(source, callback, interaction_point_id)

	local found_interaction_point_id = false
	for i = 1, #robbed_banks do
		if robbed_banks[i].interaction_point_id == interaction_point_id then
			found_interaction_point_id = true
			break
		end
	end

	if not found_interaction_point_id then
		-- Oddity Detected. Log
	end

    local payout = math.random(400, 800)
    exports["em_items"]:give_item_by_name(source, "cash", payout)
    callback(payout)

end)