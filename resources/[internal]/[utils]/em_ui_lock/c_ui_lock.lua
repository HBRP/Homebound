
local current_lock_id = 0
local currently_locked = false

function try_ui_lock()

	if currently_locked then
		return 0
	end
	currently_locked = true
	current_lock_id  = current_lock_id + 1
	return current_lock_id

end

function try_ui_lock_cb(callback)

	if currently_locked then
		return 0
	end
	currently_locked = true
	current_lock_id  = current_lock_id + 1
	callback(current_lock_id)

end

function try_ui_unlock(lock_id)

	if lock_id == current_lock_id and currently_locked then
		currently_locked = false
	end

end