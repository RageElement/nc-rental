
RegisterServerEvent('nc-rentals:attemptPurchase')
AddEventHandler('nc-rentals:attemptPurchase', function(car,price,spawnLoc)
	local xPlayer = ESX.GetPlayerFromId(source)
    local cash = xPlayer.getMoney()
    if cash >= price then
        xPlayer.removeMoney(price)
        TriggerClientEvent('nc-rentals:vehiclespawn', source, car, spawnLoc)

        xPlayer.showNotification(car..' rented for $' .. price .. ', return it in order to receive '..Config.PercentageReturn..'% of the total costs.')
    else
        xPlayer.showNotification('Not enough money')
    end
end)

RegisterServerEvent('nc-rentals:giverentalpaperServer')
AddEventHandler('nc-rentals:giverentalpaperServer', function(model, plateText)
	local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem('rentalpapers',1,100.0,{
        ['Model'] = model,
        ['Plate'] = plateText
    })
end)

RegisterServerEvent('nc-rentals:removerentalpaperServer')
AddEventHandler('nc-rentals:removerentalpaperServer', function(plateText, model)
	local xPlayer = ESX.GetPlayerFromId(source)
    local item = exports['mf-inventory']:getInventoryItemWithMetadata(xPlayer.identifier,'rentalpapers','Plate',plateText)

    if item then
        exports['mf-inventory']:removeInventoryItemWithMetadata(xPlayer.identifier,'rentalpapers','Plate',plateText,xPlayer.source)
    end
end)

RegisterServerEvent('nc-rentals:server:payreturn')
AddEventHandler('nc-rentals:server:payreturn', function(model)
    local xPlayer = ESX.GetPlayerFromId(source)
    for k,v in pairs(Config.vehicleList) do 
        if string.lower(v.model) == model then
            local payment = v.price * (Config.PercentageReturn / 100)
            xPlayer.addMoney(payment)
            xPlayer.showNotification('You have returned your rented vehicle and received $' ..payment..' in return.')
        end
    end
end)

ESX.RegisterServerCallback('nc-rentals:server:hasrentalpapers', function(source, cb, plateText, model)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item,slot = exports['mf-inventory']:getInventoryItemWithMetadata(xPlayer.identifier,'rentalpapers','Plate',plateText)
    if item then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterUsableItem('rentalpapers', function(source)
    TriggerClientEvent('nc-rentals:papercheck', source)
end)
