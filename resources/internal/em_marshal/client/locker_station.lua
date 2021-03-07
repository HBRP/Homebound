local ESX = nil
local lockers = {}
local nearby_lockers = {}

AddEventHandler("kashacters:PlayerSpawned", function ()

    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    
end)

function register_locker(job_name, locker_name, x, y, z)

    table.insert(lockers, {job_name = job_name, grade = nil, locker_name = locker_name, coords = vector3(x, y, z)})

end

function register_locker_for_grade(grade, locker_name, x, y, z)

    table.insert(lockers, {job_name = nil, grade = grade, locker_name = locker_name, coords = vector3(x, y, z)})

end

local function check_for_input(distance, i)

    if distance < 1 and IsControlJustPressed(0, 38) then
        TriggerEvent("esx_inventoryhud:openStash", lockers[i].locker_name, lockers[i].locker_name)
    end

end

local function check_for_correct_job_name(current_job_name, distance, i)

    if current_job_name == lockers[i].job_name then
        table.insert(nearby_lockers, {coords = lockers[i].coords, distance = distance, idx = i})
    end

end

local function check_for_correct_job_grade(current_grade, distance, i)

    if current_grade == lockers[i].grade then
        table.insert(nearby_lockers, {coords = lockers[i].coords, distance = distance, idx = i})
    end

end

local function render_lockers()

    for i = 1, #nearby_lockers do
        DrawMarker(27, nearby_lockers[i].coords, 0, 0, 0, 0, 0, 0, 1.0,  1.0,  1.0, 255, 255, 255, 255, 0, 0, 0, 1)
        check_for_input(nearby_lockers[i].distance, nearby_lockers[i].idx)
    end

end

local function set_nearby_lockers()

    local coords   = GetEntityCoords(PlayerPedId())
    local job      = ESX.GetPlayerData().job
    nearby_lockers = {}

    for i = 1, #lockers do

        local distance = #(lockers[i].coords - coords)
        if distance < 2 then

            if lockers[i].grade == nil then
                check_for_correct_job_name(job.name, distance, i)
            elseif lockers[i].job_name == nil then
                check_for_correct_job_grade(job.grade, distance, i)
            end

        end
        
    end

end

local function render_loop()

    while true do

        Citizen.Wait(5)
        render_lockers()

    end

end

local function distance_loop()

    while true do

        Citizen.Wait(2000)
        set_nearby_lockers()

    end

end

Citizen.CreateThread(function()

    while ESX == nil do
        Citizen.Wait(100)
    end

    Citizen.CreateThread(render_loop)
    Citizen.CreateThread(distance_loop)
    
end)