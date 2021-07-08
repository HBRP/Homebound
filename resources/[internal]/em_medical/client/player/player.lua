
PLAYER = {
    BLOOD_PRESSURE = {systolic = 100, diastolic = 75},
    BLOOD_LEVEL = 5000, -- in ml
    MISC_LEVELS = {
        FOOD   = PLAYER_MAX_LEVEL.FOOD,
        WATER  = PLAYER_MAX_LEVEL.WATER,
        STRESS = 0
    },
    WOUNDS = {},
    SHORTERM_EFFECTS = {},
    PERMANENT_EFFECTS = {}
}

PLAYER_MODIFIERS = {
    PAIN_LEVEL = 0,
    STIMULANT_LEVEL = 0,
    DEPRESSANTS_LEVEL = 0
}

PLAYER_STATS = {
    LAST_HEALTH = 0,
    LAST_ARMOUR = 0,
    LAST_HEALTH_DIFF = 0,
    LAST_ARMOUR_DIFF = 0,
    WAS_PLAYER_DEAD  = false
}

ped = nil

function pain_level_modifier(modifier)

    PLAYER_MODIFIERS.PAIN_LEVEL = PLAYER_MODIFIERS.PAIN_LEVEL + modifier * PLAYER_MODIFIERS.PAIN_LEVEL

end

function pain_level_set(level)

    PLAYER_MODIFIERS.PAIN_LEVEL = level

end


local function get_wound_pain(wound)

    for _, wound_info in pairs(WOUND_TYPES) do
        
        if wound_info.name == wound.name then

            return wound_info.pain_level

        end

    end

    return 0

end

function calculate_pain_level()

    PLAYER_MODIFIERS.PAIN_LEVEL = 0
    for _, wounds in pairs(PLAYER.WOUNDS) do
        
        for i = 1, #wounds do

            PLAYER_MODIFIERS.PAIN_LEVEL = PLAYER_MODIFIERS.PAIN_LEVEL + get_wound_pain(wounds[i])

        end

    end

end

function get_pain_level_body_part(body_part)

    local pain_level = 0
    for temp_body_part, wounds in pairs(PLAYER.WOUNDS) do
        
        if temp_body_part == body_part then

            for i = 1, #wounds do
                pain_level = pain_level + get_wound_pain(wounds[i])
            end

        end

    end

    return pain_level

end

local function get_modifier_level(effect_info, modifier_name)

    if effect_info.modifiers == nil then
        return 0
    end

    return effect_info.modifiers[modifier_name] or 0

end

local function apply_stimulant_modifier()


end

local function apply_depressant_modifier()

end

local function apply_sprint_modifier()

    local run_multiplier = PLAYER_MODIFIERS.STIMULANT_LEVEL/20.0 - PLAYER_MODIFIERS.DEPRESSANTS_LEVEL/15.0
    if run_multiplier > 0.49 then
        run_multiplier = 0.49
    end

    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0 + run_multiplier)

end

local function apply_shared_modifier()

    apply_sprint_modifier()

end

function calculate_stimulatant_depressant_level()

    PLAYER_MODIFIERS.STIMULANT_LEVEL = 0
    PLAYER_MODIFIERS.DEPRESSANTS_LEVEL = 0
    for effect_name, _ in pairs(PLAYER.SHORTERM_EFFECTS) do
        
        for __, effect_info in pairs(EFFECTS) do
            
            if effect_name == effect_info.name then

                PLAYER_MODIFIERS.STIMULANT_LEVEL   = PLAYER_MODIFIERS.STIMULANT_LEVEL + get_modifier_level(effect_info, "stimulant")
                PLAYER_MODIFIERS.DEPRESSANTS_LEVEL = PLAYER_MODIFIERS.DEPRESSANTS_LEVEL + get_modifier_level(effect_info, "depressant")

            end

        end

    end

end

function calculate_player_modifiers()

    calculate_pain_level()
    calculate_stimulatant_depressant_level()

end

function get_wound_hit_modifier()

    local hit_severity = get_hit_severity()

    if hit_severity == DAMAGE_SEVERITY_TYPES.NONE then
        return 0
    elseif hit_severity == DAMAGE_SEVERITY_TYPES.MINOR then
        return 1
    elseif hit_severity == DAMAGE_SEVERITY_TYPES.MEDIUM then
        return 2
    elseif hit_severity == DAMAGE_SEVERITY_TYPES.SEVERE then
        return 3
    elseif hit_severity == DAMAGE_SEVERITY_TYPES.CRITICAL then
        return 5
    end

end

function get_hit_severity()

    if PLAYER_STATS.LAST_HEALTH_DIFF >= 0 then
        return DAMAGE_SEVERITY_TYPES.NONE
    end

    local health_diff = -PLAYER_STATS.LAST_HEALTH_DIFF

    if health_diff <= 15 then
        return DAMAGE_SEVERITY_TYPES.MINOR
    elseif health_diff <= 60 then
        return DAMAGE_SEVERITY_TYPES.MEDIUM
    elseif health_diff <= 100 then
        return DAMAGE_SEVERITY_TYPES.SEVERE
    elseif health_diff <= 200 then
        return DAMAGE_SEVERITY_TYPES.CRITICAL
    end

end

function calculate_health_armour()

    PLAYER_STATS.WAS_PLAYER_DEAD = IsPlayerDead(PlayerId())

    local current_health = GetEntityHealth(ped)
    local current_armour = GetPedArmour(ped)

    PLAYER_STATS.LAST_HEALTH_DIFF = current_health - PLAYER_STATS.LAST_HEALTH
    PLAYER_STATS.LAST_ARMOUR_DIFF = current_armour - PLAYER_STATS.LAST_ARMOUR

    PLAYER_STATS.LAST_HEALTH = current_health
    PLAYER_STATS.LAST_ARMOUR = current_armour

    SetEntityHealth(ped, 200)

end

function apply_player_modifiers()

    apply_stimulant_modifier()
    apply_depressant_modifier()
    apply_shared_modifier()

end

function check_to_down_player() 

    if PLAYER_MODIFIERS.PAIN_LEVEL >= PAIN_THRESHOLD_BEFORE_SHOCK then
        apply_shock()
    end

end

function is_player_unconscious()

    return PLAYER.SHORTERM_EFFECTS["Shock"] ~= nil or PLAYER.SHORTERM_EFFECTS["Unconscious"] ~= nil

end

function check_to_run_player_resurrect()

    if not PLAYER_STATS.WAS_PLAYER_DEAD then
        return 0
    end

    if GetEntitySpeed(ped) > 0.05 then
        return 0
    end

    local rx, ry, rz = table.unpack(GetEntityCoords(ped))
    NetworkResurrectLocalPlayer(rx, ry, rz, 0.0, false, false)
    SetPedToRagdollWithFall(ped, 3000, 3000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

end

function heal_player()

    PLAYER.WOUNDS = {}
    PLAYER.SHORTERM_EFFECTS = {}

    if GetVehiclePedIsIn(ped, false) == 0 then
        ClearPedTasks(ped)
    end

    AnimpostfxStop("FocusIn")
    ClearPedBloodDamage(ped)

    check_to_run_player_resurrect()
    TriggerEvent("em_medical:is_conscious")

end

AddEventHandler("em_dal:character_loaded", function()

    exports["em_dal"]:get_character_health(function(response)

        if response.result.success then
            PLAYER = response.health
        else
            exports["em_dal"]:set_character_health(PLAYER)
        end

        if is_player_unconscious() then
            start_unconscious_loop()
        end

        Citizen.CreateThread(function()

            while true do
                Citizen.Wait(1000*10)
                exports["em_dal"]:set_character_health(PLAYER)
            end

        end)

    end)

end)