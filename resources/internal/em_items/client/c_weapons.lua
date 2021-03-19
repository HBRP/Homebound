

AddEventHandler('em_fw:inventory_change', function()

    RemoveAllPedWeapons(PlayerPedId(), false)

end)