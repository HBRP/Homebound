
local job = {}
local nearby_job_clock_in = {}


local function nearby_clock_in_loop()

    while true do

        Citizen.Wait(5)

    end

end


local function set_job_result(result)

    job = result

end

local function set_nearby_job_clock_in(result)

    nearby_job_clock_in = result or {}

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