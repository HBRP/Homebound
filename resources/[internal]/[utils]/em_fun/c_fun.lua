local DATA_TYPE = {
	CONTIGUOUS = 1,
	NON_STANDARD = 2
}


Fun = {}
Fun.__index = Fun

function Fun:new(data)

	local obj = {}
	setmetatable(obj, Fun)
	obj.data = data

	obj.data_type = DATA_TYPE.CONTIGUOUS
	for k, v in pairs(data) do
		if type(k) ~= "number" then
			obj.data_type = DATA_TYPE.NON_STANDARD
		end
		break
	end

	return obj

end

function Fun:map(func)

	local data = {}
	for k, v in pairs(self.data) do

		data[k] = func(v)

	end
	return Fun:new(data)

end

function Fun:filter(func)

	local data = {}

	if self.data_type == DATA_TYPE.NON_STANDARD then
		for k, v in pairs(self.data) do

			if func(v) then
				data[k] = v
			end

		end
	else
		for i = 1, #self.data do

			if func(self.data[i]) then
				data[#data + 1] = self.data[i]
			end

		end
	end

	return Fun:new(data)

end

function Fun:into_inner()

	return self.data

end