
RegisterServerEvent('gb-rental:attemptPurchase')
AddEventHandler('gb-rental:attemptPurchase', function(car,price)
	local xPlayer = ESX.GetPlayerFromId(source)
    local cash = xPlayer.getMoney()
    if cash >= price then
        xPlayer.removeMoney(price)
        TriggerClientEvent('gb-rental:vehiclespawn', source, car)

        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = car..'has been rented for €' .. price .. ', return it in order to receive 50% of the total costs.'})

    else
        TriggerClientEvent('gb-rental:attemptvehiclespawnfail', source)
    end
end)

RegisterServerEvent('gb-rental:giverentalpaperServer')
AddEventHandler('gb-rental:giverentalpaperServer', function(model, plateText)
    exports.ox_inventory:AddItem(source, 'rentalpapers', 1, {description = 'Model: '..model..' Licenseplate: '..plateText})
    --Model : "..tostring(model).." | Plate : "..tostring(plate)..
end)

RegisterServerEvent('gb-rental:removerentalpaperServer')
AddEventHandler('gb-rental:removerentalpaperServer', function(plateText, model)
    deltext = {'Model: '..model..' Licenseplate: '..plateText}
    exports.ox_inventory:RemoveItem(source, 'rentalpapers', 1)

end)

RegisterServerEvent('gb-rental:server:payreturn')
AddEventHandler('gb-rental:server:payreturn', function(model)
    local xPlayer = ESX.GetPlayerFromId(source)
    for k,v in pairs(Config.vehicleList) do 
        if string.lower(v.model) == model then
            local payment = v.price / 2
            xPlayer.addMoney(payment)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You have returned your rented vehicle and received €' ..payment..' in return.'})

        end
    end
end)

ESX.RegisterServerCallback('gb-rental:server:hasrentalpapers', function(source, cb)
    local Item = exports.ox_inventory:Search(source, 'slots', 'rentalpapers')
    if Item ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterUsableItem('rentalpapers', function(source)
    local papers = exports.ox_inventory:Search(source, 'slots', 'rentalpapers')
    for _, v in pairs(papers) do
        papers = v
        --print(json.encode(v.metadata))
    end
    local info = json.encode(papers.metadata)
    print(info)
    TriggerClientEvent('gb-rental:papercheck', source, info)
    
end)
