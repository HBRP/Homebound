
local base_service_url = ""
local service_header   = {}
service_header["Content-Type"] = "application/json"

local function Http(method, endpoint, data, callback)

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