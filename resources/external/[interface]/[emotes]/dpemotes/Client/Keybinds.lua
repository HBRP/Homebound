
local keybinds = {}

AddEventHandler("em_dal:character_loaded", function()

    exports["em_dal"]:get_emote_keybinds(function(result)
        keybinds = result or {}
    end)

end)

local function use_emote(emote_number)

    for i = 1, #keybinds do
        if keybinds[i].emote_number == emote_number then
            EmoteCommandStart(nil, {keybinds[i].emote, 0})
        end
    end

end

RegisterCommand('keybind_emote_6', function() use_emote(6) end, false)
RegisterCommand('keybind_emote_7', function() use_emote(7) end, false)
RegisterCommand('keybind_emote_8', function() use_emote(8) end, false)
RegisterCommand('keybind_emote_9', function() use_emote(9) end, false)
RegisterCommand('keybind_emote_0', function() use_emote(0) end, false)

RegisterKeyMapping('keybind_emote_6', 'keybind_emote_6', 'keyboard', '6')
RegisterKeyMapping('keybind_emote_7', 'keybind_emote_7', 'keyboard', '7')
RegisterKeyMapping('keybind_emote_8', 'keybind_emote_8', 'keyboard', '8')
RegisterKeyMapping('keybind_emote_9', 'keybind_emote_9', 'keyboard', '9')
RegisterKeyMapping('keybind_emote_0', 'keybind_emote_0', 'keyboard', '0')

local function get_emote(emote_number)

    for i = 1, #keybinds do

        if keybinds[i].emote_number == emote_number then

            return keybinds[i].emote

        end

    end
    return ""

end

function EmoteBindsStart()

    EmoteChatMessage(Config.Languages[lang]['currentlyboundemotes'].."\n"
        ..firstToUpper("num5").." = '^2".. get_emote(5) .."^7'\n"
        ..firstToUpper("num6").." = '^2".. get_emote(6) .."^7'\n"
        ..firstToUpper("num7").." = '^2".. get_emote(7) .."^7'\n"
        ..firstToUpper("num8").." = '^2".. get_emote(8) .."^7'\n"
        ..firstToUpper("num9").." = '^2".. get_emote(9) .."^7'\n")

end

local function get_keybind_number(key)

    return tonumber(string.sub(key, 4))

end

local function update_local_keybind(emote_number, emote)

    for i = 1, #keybinds do

        if keybinds[i].emote_number == emote_number then

            keybinds[i].emote = emote
            return

        end

    end
    table.insert(keybinds, {emote_number = emote_number, emote = emote})

end

function EmoteBindStart(source, args, raw)

    if #args > 0 then

        local key = string.lower(args[1])
        local emote = string.lower(args[2])

        if (Config.KeybindKeys[key]) ~= nil then
        	if DP.Emotes[emote] ~= nil then
                exports["em_dal"]:update_emote_keybinds(get_keybind_number(key), emote)
                update_local_keybind(get_keybind_number(key), emote)
        	elseif DP.Dances[emote] ~= nil then
          		exports["em_dal"]:update_emote_keybinds(get_keybind_number(key), emote)
                update_local_keybind(get_keybind_number(key), emote)
        	elseif DP.PropEmotes[emote] ~= nil then
          		exports["em_dal"]:update_emote_keybinds(get_keybind_number(key), emote)
                update_local_keybind(get_keybind_number(key), emote)
        	else
          		EmoteChatMessage("'"..emote.."' "..Config.Languages[lang]['notvalidemote'].."")
        	end
        else
        	EmoteChatMessage("'"..key.."' "..Config.Languages[lang]['notvalidkey'])
        end

    else
        print("invalid")
    end
end