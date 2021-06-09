function table_deepcopy(orig)

    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
    
end

function draw_txt(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end

function DisableAllActions()
    --DisableAllControlActions(27)
    DisableControlAction(0, 32) --W
    DisableControlAction(0, 33) --S
    DisableControlAction(0, 34) --A
    DisableControlAction(0, 35) --D
    DisableControlAction(0, 44) --Q
    DisableControlAction(0, 12) --Weaponwheel
    DisableControlAction(0, 13) --Weaponwheel
    DisableControlAction(0, 14) --Weaponwheel
    DisableControlAction(0, 15) --Weaponwheel
    DisableControlAction(0, 16) --Weaponwheel
    DisableControlAction(0, 17) --Weaponwheel
    DisableControlAction(0, 19) --LALT
    DisableControlAction(0, 24) --LMOUSE
    DisableControlAction(0, 25) --RMB
    DisableControlAction(0, 37) --Weaponwheel
    DisableControlAction(0, 47) --G
    DisableControlAction(0, 75) --F
    DisableControlAction(0, 99) --Weaponwheel
    DisableControlAction(0, 100) --Weaponwheel
    DisableControlAction(0, 140) --Attack
    DisableControlAction(0, 141) --Attack
    DisableControlAction(0, 142) --Attack
    DisableControlAction(0, 157) --Weaponwheel
    DisableControlAction(0, 158) --Weaponwheel
    DisableControlAction(0, 159) --Weaponwheel
    DisableControlAction(0, 160) --Weaponwheel
    DisableControlAction(0, 161) --Weaponwheel
    DisableControlAction(0, 162) --Weaponwheel
    DisableControlAction(0, 163) --Weaponwheel
    DisableControlAction(0, 164) --Weaponwheel
    DisableControlAction(0, 165) --Weaponwheel
    DisableControlAction(0, 166) --F5
    DisableControlAction(0, 243) --"` ~"
    DisableControlAction(0, 244) --"M"
    DisableControlAction(0, 257) --Attack
    DisableControlAction(0, 262) --Weaponwheel
    DisableControlAction(0, 263) --Melee attack
    DisableControlAction(0, 264) --Melee attack

    EnableControlAction(0, 245) --Allow Chat
    EnableControlAction(0, 199) --Allow Map
    EnableControlAction(0, 38) --Allow E
    EnableControlAction(0, 46) --Allow E
    EnableControlAction(0, 289) --Allow F2
end