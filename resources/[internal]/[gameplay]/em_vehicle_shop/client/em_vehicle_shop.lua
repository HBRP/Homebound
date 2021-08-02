
local categories ={
	'muscle',
    'compacts',
    'vans',
    'sedans',
    'suvs',
    'sports classics',
    'offroad',
    'coupes',
    'sports',
    'super',
    'motorcycles',
    'bicycles'
}

local function open_vehicle_shop_menu()

	local menu = MenuV:CreateMenu('Vehicles', 'Select Category', 'topleft', 0, 0, 255, 'size-125', 'default', 'menuv', 'teleporter', 'native')
	menu:ClearItems()

	for i = 1, #categories do

		local category_menu = MenuV:CreateMenu(categories[i], 'Pull out vehicle', 'topleft', 0, 0, 255)
		local button = menu:AddButton({label = categories[i], value = category_menu})

		category_menu:On('open', function(m)
			m:AddButton({label = 'temp', value = function() end})
		end)

	end


end

exports["em_context"]:register_context("PDM Vehicle Floor", function()

    print("here")
    return {
        dialog = "Pull out vehicle",
        callback = open_vehicle_shop_menu
    }

end)