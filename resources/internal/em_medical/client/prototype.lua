
local function check_all_timed_damage()

    local temp_table = {}
    for i = 1, #WEAPON_HASHES do
        local retval = GetTimeOfLastPedWeaponDamage(ped, WEAPON_HASHES[i][2])
        if GetGameTimer() - retval < 20 then
            table.insert(temp_table, WEAPON_HASHES[i][1])
        end
    end
    if #temp_table > 0 then
        print("timed: " .. json.encode(temp_table))
    end

end

local function check_all_damage()

    local temp_table = {}
    local damage_types = {}
    for weapon_name, weapon_info in pairs(WEAPON_HASHES) do

        local retval = HasEntityBeenDamagedByWeapon(ped, weapon_info.hash, 0)
        if retval then
            table.insert(temp_table, weapon_info)
            table.insert(damage_types, weapon_info.name)
        end

    end

    --if #temp_table > 0 then
    --    print("All damage :" .. json.encode(damage_types))
    --end

    return temp_table

end

local function check_for_weapon_damage()

    local weapons = check_all_damage()
    local _, out_bone = GetPedLastDamageBone(ped)

    for i = 1, #weapons do

        if out_bone ~= 0 then
            apply_weapon_damage(out_bone, weapons[i])
            break
        else
            attempt_to_apply_weapon_type_damage(weapons[i])
            break
        end

    end

end

local function damage_loop()

    if not is_player_unconscious() then
        check_for_weapon_damage()
    end

    ClearEntityLastDamageEntity(ped)
    ClearEntityLastWeaponDamage(ped)

end


local function effects_loop()

    debug_effects()
    calculate_player_modifiers()
    apply_player_modifiers()
    short_term_effects()
    check_to_down_player()

end

local function bandage_loop()

    --calculate_blood_loss()

end

local function start_damage_loop()

    Citizen.CreateThread(function ()
    
        Citizen.Wait(0)
        while true do
    
            ped = PlayerPedId()
            calculate_health_armour()
            damage_loop()
            check_to_run_player_resurrect()
            Citizen.Wait(50)
    
        end
    
    end)

end

local function disable_weapon_insta_kill()

    for i = 1, #WEAPON_HASHES do
        if WEAPON_HASHES[i].weapon_type == WEAPON_TYPES.SHOTGUN_SHELL or WEAPON_HASHES[i].weapon_type == WEAPON_TYPES.SEVERE_SHOTGUN_SHELL then
            SetWeaponDamageModifier(WEAPON_HASHES[i].hash, 0.4)
        end
    end

end

local function start_long_loop()

    Citizen.CreateThread(function() 

        Citizen.Wait(0)
        disable_weapon_insta_kill()
        SetWeaponDamageModifier(0x99B507EA, 0)
        SetPlayerMeleeWeaponDamageModifier(PlayerId(), 0)

        while true do

            check_wound_heal_time()
            bandage_loop()
            effects_loop()
            body_part_cleanup()
            Citizen.Wait(100)

        end
    
    end)

end

start_damage_loop()
start_long_loop()

AddEventHandler('kashacters:PlayerSpawned', function ()
    --start_damage_loop()
    --start_long_loop()
end)

exports["em_commands"]:register_command("test_check_player", function(source, args, raw)

    print(json.encode(PLAYER))
    print(json.encode(PLAYER_MODIFIERS))
    
end, "Print out player health")

exports["em_commands"]:register_command("test_give_adrenaline", function(source, args, raw)

    apply_adrenaline()

end)

exports["em_commands"]:register_command("test_give_knocked_out", function(source, args, raw)

    apply_knocked_out()

end)

exports["em_commands"]:register_command("test_give_shock", function(source, args, raw)

    apply_shock()

end)

exports["test_clear_wounds", function(source, args, raw)

   heal_player() 

end)
    
exports["test_give_meth", function(source, args, raw)

    apply_short_term_effect(EFFECTS.METH)

end)