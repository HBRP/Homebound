

local item_type_ids = {

    FOOD       = 1,
    LIQUID     = 2,
    WEAPON     = 3,
    AMMO       = 4,
    ATTACHMENT = 5,
    BAG        = 6,
    MISC       = 7

}

function use_item(item_id, item_type_id, storage_item_id)

    if item_type_id == item_type_ids.FOOD then
        eat()
    elseif item_type_id == item_type_ids.LIQUID then
        drink()
    end

end