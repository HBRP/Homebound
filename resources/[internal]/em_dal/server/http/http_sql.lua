local function GetQuerySerialized(query, data)

    local query_obj = {}
    query_obj["query"] = query
    query_obj["data"]  = data
    return json.encode(query_obj)

end

function ExecuteQuery(query, data, callback)

    local query_obj = GetQuerySerialized(query, data)
    HttpPost("/ExecuteQuery", query_obj, callback)

end

function ExecuteFetch(query, data, callback)

    local query_obj = GetQuerySerialized(query, data)
    HttpPost("/ExecuteFetch", query_obj, callback)

end