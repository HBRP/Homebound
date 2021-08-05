

function has_any_stock_from_category(stock, vehicle_category_id)

    for i = 1, #stock do
        if stock[i].vehicle_category_id == vehicle_category_id then
            return true
        end
    end
    return false

end