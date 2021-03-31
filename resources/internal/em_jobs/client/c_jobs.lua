
local job = {}
local nearby_job_clock_in = {}

local function set_job_result(result)

    job = result
    print(json.encode(job))

end

local function set_nearby_job_clock_in(result)

    nearby_job_clock_in = result or {}

end

local function nearby_clock_in_loop()

    local nearby_point = false
    local draw_text_id = -1
    while true do

        Citizen.Wait(5)
        local ped_coords = GetEntityCoords(PlayerPedId())

        for i = 1, #nearby_job_clock_in do

            if GetDistanceBetweenCoords(ped_coords.x, ped_coords.y, ped_coords.z, nearby_job_clock_in[i].x, nearby_job_clock_in[i].y, nearby_job_clock_in[i].z, true) < 2 then

                nearby_point = true
                if not exports["cd_drawtextui"]:is_in_queue(draw_text_id) then

                    local clock_in_text = "clock in to"
                    if nearby_job_clock_in[i].group_id == job.group_id then
                        clock_in_text = "clock out of"
                    end
                    draw_text_id = exports["cd_drawtextui"]:show_text(string.format("Press [E] to %s the %s", clock_in_text, nearby_job_clock_in[i].group_name))

                end
                if IsControlJustReleased(0, 38) then

                    if not job.clocked_in then
                        exports["em_fw"]:clock_in_async(function(result) 

                            set_job_result(result)
                            exports["cd_drawtextui"]:hide_text(draw_text_id)

                        end, nearby_job_clock_in[i].group_id)
                    else
                        exports["em_fw"]:clock_out_async(function()

                            exports["cd_drawtextui"]:hide_text(draw_text_id)
                            exports["em_fw"]:get_clocked_on_job_async(set_job_result)

                        end)
                    end

                end

            end

        end

        if not nearby_point then
            exports["cd_drawtextui"]:hide_text(draw_text_id)
            Citizen.Wait(500)
        end
        nearby_point = false


    end

end

local function refresh_nearby_clock_in_loop()

    exports["em_fw"]:get_clocked_on_job_async(set_job_result)
    while true do
        exports["em_fw"]:get_nearby_job_clock_in_async(set_nearby_job_clock_in)
        Citizen.Wait(5000)
    end

end

AddEventHandler("em_fw:character_loaded", function()

    Citizen.CreateThread(refresh_nearby_clock_in_loop)
    Citizen.CreateThread(nearby_clock_in_loop)

end)

Citizen.CreateThread(refresh_nearby_clock_in_loop)
Citizen.CreateThread(nearby_clock_in_loop)