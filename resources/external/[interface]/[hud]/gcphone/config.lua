Config = {}

-- Script locale (only .Lua)
Config.Locale = 'en'

-- ESX Item requirement
Config.NeedItem = false   -- Does the player need an item to open the phone?
Config.ESXItem  = 'phone' -- Name of the item.

Config.AutoFindFixePhones = true -- Automatically add pay phones as they are found by their models.

Config.FixePhone = {
  -- Mission Row
  ['911'] = { 
    name =  'mission_row', 
    coords = { x = 441.2, y = -979.7, z = 30.58 } 
  },
  
--  ['372-9663'] = {
--    name = _U('phone_booth'),
--    coords = { x = 372.305, y = -966.373, z = 28.413 } 
--  },
}

Config.KeyOpenClose = 288 -- F1
Config.KeyTakeCall  = 38  -- E

Config.UseMumbleVoIP = true -- Use Frazzle's Mumble-VoIP Resource (Recomended!) https://github.com/FrazzIe/mumble-voip
Config.UseSaltyChat  = false

Config.ShowNumberNotification = false -- Show Number or Contact Name when you receive new SMS