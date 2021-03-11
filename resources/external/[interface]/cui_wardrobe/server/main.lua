
--[[
if Config.UseAnywhere then
    ESX.RegisterCommand('wardrobe', 'user', function(xPlayer, args, showError)
        xPlayer.triggerEvent('cui_wardrobe:open')
        end, false, {help = 'Open wardrobe.', validate = true, arguments = {}
    })
else
    ESX.RegisterCommand('wardrobe', 'admin', function(xPlayer, args, showError)
        xPlayer.triggerEvent('cui_wardrobe:open')
        end, true, {help = 'Open wardrobe.', validate = true, arguments = {}
    })
end
]]