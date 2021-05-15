
local base_service_url = ""
local service_header   = {}
service_header["Content-Type"] = "application/json"

function split(str, sep, plain, max)
    local result, count, first, found, last, word = {}, 1, 1
    if plain then
        sep = sep:gsub('[$%%()*+%-.?%[%]^]', '%%%0')
    end
    sep = '^(.-)' .. sep
    repeat
        found, last, word = str:find(sep, first)
        if q then
            result[count], count, first = word, count + 1, last + 1
        else
            result[count] = str:sub(first)
            break
        end
    until count == max
    return result
end

local function get_endpoint_with_replaced_spaces(endpoint)

    local strings = split(endpoint, " ")
    local new_endpoint = table.concat(strings, "%20")
    return new_endpoint

end

local function Http(method, endpoint, data, callback)

    endpoint = get_endpoint_with_replaced_spaces(endpoint)

    local data = data or ''
    data = json.encode(data)
    PerformHttpRequest(base_service_url .. endpoint, callback, method, data, service_header)

end

function HttpGet(endpoint, data, callback)
    Http('GET', endpoint, data, callback)
end

function HttpPost(endpoint, data, callback)
    Http('POST', endpoint, data, callback)
end

function HttpPut(endpoint, data, callback)
    Http('PUT', endpoint, data, callback)
end

Citizen.CreateThread(function()

    Citizen.Wait(0)
    base_service_url = GetConvar("homebound_service", "")

end)