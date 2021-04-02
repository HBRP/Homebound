

function register_points(refresh_loop, text_func, control_pressed_func)

    local nearby_points = {}
    local is_nearby_points = false

    local nearby_loop = function()

        local nearby_point = false
        local draw_text_id = -1
        while is_nearby_points do

            Citizen.Wait(5)
            local ped_coords = GetEntityCoords(PlayerPedId())
            for i = 1, #nearby_points do

                local nearby_coords = vector3(nearby_points[i].x, nearby_points[i].y, nearby_points[i].z)
                if #(ped_coords - nearby_coords) < 2 then

                    nearby_point = true
                    if not exports["cd_drawtextui"]:is_in_queue(draw_text_id) then
                        draw_text_id = exports["cd_drawtextui"]:show_text(text_func(nearby_points[i]))
                    end
                    if IsControlJustReleased(0, 38) then
                        control_pressed_func(nearby_points[i])
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

    local refresh_nearby_points = function(points)

        nearby_points = points or {}
        local old_is_nearby_points = is_nearby_points

        is_nearby_points = #nearby_points > 0

        if not old_is_nearby_points and is_nearby_points then
            Citizen.CreateThread(nearby_loop)
        end
        
    end

    Citizen.CreateThread(function()

        Citizen.Wait(5000)
        refresh_loop(refresh_nearby_points)

    end)

end