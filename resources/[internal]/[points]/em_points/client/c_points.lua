
local unique_id = 1
local controls  = {}

local Point = {}
Point.__index = Point

function Point:new(refresh_loop, interaction_func, text_func, control_pressed_func, loop_time, delay)

    local obj = {}
    setmetatable(obj, Point)

    obj.refresh_loop         = refresh_loop
    obj.interaction_func     = interaction_func
    obj.text_func            = text_func
    obj.control_pressed_func = control_pressed_func
    obj.loop_time            = loop_time or 5000
    obj.delay = delay or 500

    obj.nearby_points = {}
    obj.is_nearby_points = false
    obj.draw_text_id = -1
    obj.nearby_point = false

    obj.point_id = unique_id
    unique_id = unique_id + 1

    return obj

end

function Point:nearby_loop()

    while self.is_nearby_points do

        Citizen.Wait(self.delay)
        self.interaction_func(self)
        if not self.nearby_point then

            controls[self.point_id] = nil
            exports["cd_drawtextui"]:hide_text(self.draw_text_id)
            self.draw_text_id = -1
            Citizen.Wait(self.delay * 2)

        end
        self.nearby_point = false

    end

end

function Point:refresh_points(points)

    self.nearby_points = points or {}
    local old_is_nearby_points = self.is_nearby_points

    self.is_nearby_points = #self.nearby_points > 0

    if not old_is_nearby_points and self.is_nearby_points then

        Citizen.CreateThread(function() self:nearby_loop() end)

    end

end

function Point:start_loop()

    Citizen.CreateThread(function()

        while true do

            self.refresh_loop(function(points) self:refresh_points(points) end)
            Citizen.Wait(self.loop_time)

        end

    end)

end


function register_raycast_points(refresh_loop, text_func, control_pressed_func, loop_time)

    local last_hash = nil
    local interaction_func = function(obj)

        local hit, coords, entity = table.unpack(exports["em_dal"]:ray_cast_game_play_camera(10.0))
        if not hit then
            goto object_continue
        end

        if entity == 0 or GetEntityType(entity) == 0 then
            goto object_continue
        end

        local successful, hash = pcall(GetEntityModel, entity)
        if not successful then
            goto object_continue
        end

        for i = 1, #obj.nearby_points do

            if obj.nearby_points[i].prop_hash == hash then

                if not exports["cd_drawtextui"]:is_in_queue(obj.draw_text_id) then
                    obj.draw_text_id = exports["cd_drawtextui"]:show_text(obj.text_func(obj.nearby_points[i]))
                end
                controls[obj.point_id] = {func = obj.control_pressed_func, point = obj.nearby_points[i], entity = entity}
                obj.nearby_point = hash == last_hash
                last_hash = hash

            end

        end
        ::object_continue::

    end

    local obj = Point:new(refresh_loop, interaction_func, text_func, control_pressed_func, loop_time)
    obj:start_loop()

end

function register_door_points(refresh_loop, text_func, control_pressed_func, loop_time)

    local last_hash = nil
    local interaction_func = function(obj)

        local player_coords = GetEntityCoords(PlayerPedId())
        for i = 1, #obj.nearby_points do

            local doors = obj.nearby_points[i].doors
            for j = 1, #doors do
                
                local object = GetClosestObjectOfType(vector3(table.unpack(doors[j].coords)), 0.15, doors[j].prop_hash, false, false, false)

                if object ~= 0 and #(player_coords - GetEntityCoords(object)) <= obj.nearby_points[i].max_unlock_distance then

                    if obj.nearby_points[i].can_unlock_door then

                        if not exports["cd_drawtextui"]:is_in_queue(obj.draw_text_id) then
                            obj.draw_text_id = exports["cd_drawtextui"]:show_text(obj.text_func(obj.nearby_points[i]))
                        end
                        controls[obj.point_id] = {func = obj.control_pressed_func, point = obj.nearby_points[i]}
                        obj.nearby_point = doors[j].prop_hash == last_hash
                        last_hash = doors[j].prop_hash
                        return
                        
                    end

                end

            end

        end

    end

    local obj = Point:new(refresh_loop, interaction_func, text_func, control_pressed_func, loop_time)
    obj:start_loop()

end

function register_points(refresh_loop, text_func, control_pressed_func, loop_time)

    local interaction_func = function(obj)

        local ped_coords = GetEntityCoords(PlayerPedId())
        for i = 1, #obj.nearby_points do

            local nearby_coords = vector3(obj.nearby_points[i].x, obj.nearby_points[i].y, obj.nearby_points[i].z)
            if #(ped_coords - nearby_coords) < 1.0 then

                obj.nearby_point = true
                if not exports["cd_drawtextui"]:is_in_queue(obj.draw_text_id) then
                    obj.draw_text_id = exports["cd_drawtextui"]:show_text(obj.text_func(obj.nearby_points[i]))
                end
                controls[obj.point_id] = {func = obj.control_pressed_func, point = obj.nearby_points[i]}
            end

        end

    end

    local obj = Point:new(refresh_loop, interaction_func, text_func, control_pressed_func, loop_time)
    obj:start_loop()


end

RegisterCommand('interact', function()

    for k, v in pairs(controls) do
        v.func(v.point, v.entity)
    end

end, false)

RegisterKeyMapping('interact', 'Interact with point', 'keyboard', 'e')