
local interaction_type = {

    OBJECT = 1,
    POINT  = 2

}

local unique_id = 1
local controls  = {}

local function set_registers(refresh_loop, text_func, control_pressed_func, loop_time, interaction)

    local nearby_points = {}
    local is_nearby_points = false
    local draw_text_id = -1
    local nearby_point = false

    local point_id = unique_id
    unique_id = unique_id + 1

    local interaction_function = nil
    if interaction == interaction_type.OBJECT then

        interaction_function = function()

            local hit, coords, entity = table.unpack(exports["em_fw"]:ray_cast_game_play_camera(10.0))
            if not hit then
                goto object_continue
            end

            local successful, hash = pcall(GetEntityModel, entity)
            if not successful then
                goto object_continue
            end

            for i = 1, #nearby_points do

                if nearby_points[i].prop_hash == hash then

                    nearby_point = true
                    if not exports["cd_drawtextui"]:is_in_queue(draw_text_id) then
                        draw_text_id = exports["cd_drawtextui"]:show_text(text_func(nearby_points[i]))
                    end
                    controls[point_id] = {func = control_pressed_func, point = nearby_points[i]}

                end

            end
            ::object_continue::

        end

    else

        interaction_function = function()

            local ped_coords = GetEntityCoords(PlayerPedId())
            for i = 1, #nearby_points do

                local nearby_coords = vector3(nearby_points[i].x, nearby_points[i].y, nearby_points[i].z)
                if #(ped_coords - nearby_coords) < 2 then

                    nearby_point = true
                    if not exports["cd_drawtextui"]:is_in_queue(draw_text_id) then
                        draw_text_id = exports["cd_drawtextui"]:show_text(text_func(nearby_points[i]))
                    end
                    controls[point_id] = {func = control_pressed_func, point = nearby_points[i]}

                end

            end

        end

    end

    local nearby_loop = function()

        while is_nearby_points do
            Citizen.Wait(500)
            interaction_function()
            if not nearby_point then

                controls[point_id] = nil
                exports["cd_drawtextui"]:hide_text(draw_text_id)
                draw_text_id = -1
                Citizen.Wait(1000)

            end
            nearby_point = false
        end

    end

    local refresh_nearby_points = function(points)

        nearby_points = points or {}
        local old_is_nearby_points = is_nearby_points

        is_nearby_points = #nearby_points > 0

        if not old_is_nearby_points and is_nearby_points then
            Citizen.CreateThread(nearby_loop)
        end
        
    end

    Citizen.CreateThread(function()

        while true do
            refresh_loop(refresh_nearby_points)
            Citizen.Wait(loop_time)
        end

    end)

end

function register_raycast_points(refresh_loop, text_func, control_pressed_func, loop_time)

    set_registers(refresh_loop, text_func, control_pressed_func, loop_time or 5000, interaction_type.OBJECT)

end

function register_points(refresh_loop, text_func, control_pressed_func, loop_time)

    set_registers(refresh_loop, text_func, control_pressed_func, loop_time or 5000, interaction_type.POINT)

end

RegisterCommand('interact', function()

    for k, v in pairs(controls) do
        v.func(v.point)
    end

end, false)

RegisterKeyMapping('interact', 'Interact with point', 'keyboard', 'e')