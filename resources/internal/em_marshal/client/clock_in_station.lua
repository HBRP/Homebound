local ESX = nil
local clock_in_station = {}
local nearby_stations  = {}

AddEventHandler("kashacters:PlayerSpawned", function ()

    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    
end)

function register_clock_in_station(job_name, x, y, z)

    table.insert(clock_in_station, {job_name = job_name, coords = vector3(x, y, z)})

end

local function check_for_input(distance)

    if distance < 1 and IsControlJustPressed(0, 38) then
        TriggerServerEvent("clock_in_toggle")
    end

end

local function set_nearby_stations()

    local coords   = GetEntityCoords(PlayerPedId())
    local job_name = ESX.GetPlayerData().job.name

    nearby_stations = {}
    
    for i = 1, #clock_in_station do
        local distance = #(clock_in_station[i].coords - coords)
        if distance < 2 then
            if job_name == clock_in_station[i].job_name then
                table.insert(nearby_stations, {coords = clock_in_station[i].coords, distance = distance})
            end
        end
    end

end

local function render_stations()

    for i = 1, #nearby_stations do
        DrawMarker(27, nearby_stations[i].coords, 0, 0, 0, 0, 0, 0, 1.0,  1.0,  1.0, 255, 255, 255, 255, 0, 0, 0, 1)
        check_for_input(nearby_stations[i].distance)
    end

end

local function render_loop()

    while true do

        Citizen.Wait(5)
        render_stations()

    end

end

local function distance_loop()

    while true do

        Citizen.Wait(2000)
        set_nearby_stations()

    end

end

Citizen.CreateThread(function()

    Citizen.Wait(0)
    while ESX == nil do
        Citizen.Wait(100)
    end

    Citizen.CreateThread(render_loop)
    Citizen.CreateThread(distance_loop)

end)