
local use_steam_id_for_ballot_checking = true

local function ballot_already_cast_steamid(steam_id, voting_id)

    local results = MySQL.Sync.fetchAll(    
    [[
        SELECT * FROM voting_options vo
        INNER JOIN voting_ballots vb ON vb.VotingOptionId = vo.VotingOptionId
        WHERE
                    vo.VotingId = @VotingId
            AND vb.SteamId   = @SteamId
    ]], {["@VotingId"] = voting_id, ["@SteamId"] = steam_id})
    return #results > 0

end

local function ballot_already_cast_characterid(character_id, voting_id)

    local results = MySQL.Sync.fetchAll(    
    [[
        SELECT * FROM voting_options vo
        INNER JOIN voting_ballots vb ON vb.VotingOptionId = vo.VotingOptionId
        WHERE
                    vo.VotingId = @VotingId
            AND vb.SteamId   = @CharacterId
    ]], {["@VotingId"] = voting_id, ["@CharacterId"] = character_id})
    return #results > 0

end

local function ballot_already_cast(character_id, steam_id, voting_id)

    if use_steam_id_for_ballot_checking then
        return ballot_already_cast_steamid(steam_id, voting_id)
    else
        return ballot_already_cast_characterid(character_id, voting_id)
    end

end

local function cast_ballot(voting_id, voting_option_id) 


    local source = source
    local player = exports["arp"]:GetTheirIdentifiers(source)

    local character_id = player.UserID
    local steam_id     = player.SteamID

    if ballot_already_cast(character_id, steam_id, voting_id) then
        TriggerClientEvent("mythic_notify:client:SendAlert", source, {type = "error", text = "You have already casted a ballot!", length = "5000"})
        return
    end

    MySQL.ready(function()
        MySQL.Async.execute(
        [[
            INSERT INTO voting_ballots (CharacterId, SteamId, VotingOptionId) VALUES (@CharacterId, @SteamId, @VotingOptionId)
        ]], {["@CharacterId"] = character_id, ["@SteamId"] = steam_id, ["@VotingOptionId"] = voting_option_id}, function()
            TriggerClientEvent("mythic_notify:client:SendAlert", source, {type = "inform", text = "You have voted!", length = "5000"})
        end)
    end)

end

RegisterNetEvent('voting_cast_ballot')
AddEventHandler('voting_cast_ballot', cast_ballot)

local function get_voting_options()

    local source = source
    MySQL.ready(function()
        MySQL.Async.fetchAll(
            [[
                SELECT v.VotingId as voting_id, VotingName as voting_name, vo.VotingOptionId as voting_option_id, vo.VotingOption as voting_option FROM voting v
                INNER JOIN voting_options vo ON vo.VotingId = v.VotingId
                WHERE NOW() BETWEEN v.StartTime AND v.EndTime
            ]], {},
        function (result)
            TriggerClientEvent("voting_options_response", source, result)
        end)
    end)

end

RegisterNetEvent('voting_get_voting_options')
AddEventHandler('voting_get_voting_options', get_voting_options)

