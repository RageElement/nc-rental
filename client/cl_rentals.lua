RegisterNetEvent("nc-rentals:vehiclelist")
AddEventHandler("nc-rentals:vehiclelist", function(data)  
  local menu = {
    {
        header = "Rent-A-Car"
    }
  }
  for i = 1, #Config.vehicleList do
    table.insert(menu,  
      {
        header = Config.vehicleList[i].name,
        context = "$"..Config.vehicleList[i].price,
        server = true,
        image = Config.vehicleList[i].image,
        event = "nc-rentals:attemptPurchase",
        args = {Config.vehicleList[i].model, Config.vehicleList[i].price, data.location}
      }
    )
  end
  TriggerEvent('nh-context:createMenu', menu)
end)

RegisterNetEvent("nc-rentals:returnvehicle")
AddEventHandler("nc-rentals:returnvehicle", function()
  local car = GetVehiclePedIsIn(PlayerPedId(),true)

  if car ~= 0 then
    local plate = GetVehicleNumberPlateText(car)
    local vehname = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(car)))
    local hash = GetEntityModel(car)
    local model = GetDisplayNameFromVehicleModel(hash)

    ESX.TriggerServerCallback('nc-rentals:server:hasrentalpapers', function(HasItem)
      if HasItem then
        if Config.Keys == "cd_garage" then
          TriggerEvent('cd_garage:RemoveKeys', plate)
        elseif Config.Keys == 'other' then
          --Add your own code here.
        end
        TriggerServerEvent('nc-rentals:removerentalpaperServer', plate, model)
        TriggerServerEvent('nc-rentals:server:payreturn',vehname)
        ESX.Game.DeleteVehicle(car)
        DeleteEntity(car)
      else
        ESX.ShowNotification('I cannot take a vehicle without proper papers.')
      end
    end, plate)
  else
    ESX.ShowNotification('I don\'t see any rented vehicle, make sure its nearby.')
  end
end)

RegisterNetEvent("nc-rentals:vehiclespawn")
AddEventHandler("nc-rentals:vehiclespawn", function(carmodel, spawnlocation, cb)
  local model = carmodel

  RequestModel(model)
  while not HasModelLoaded(model) do
      Wait(0)
  end
  SetModelAsNoLongerNeeded(model)

  local veh = CreateVehicle(model, spawnlocation, true, false)
  Wait(100)
  SetEntityAsMissionEntity(veh, true, true)
  SetModelAsNoLongerNeeded(model)
  SetVehicleOnGroundProperly(veh)
  SetVehicleNumberPlateText(veh, "RXTN"..tostring(math.random(1000, 9999)))

  local plateText = GetVehicleNumberPlateText(veh)
  TriggerServerEvent("nc-rentals:giverentalpaperServer",model ,plateText)

  if Config.AutoGiveKeys then
    if Config.Keys == "cd_garage" then
      TriggerEvent('cd_garage:AddKeys', plateText)
    elseif Config.Keys == "t1ger_keys" then
      local veh_name = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
      exports['t1ger_keys']:GiveTemporaryKeys(plateText, veh_name, 'Rental')
    elseif Config.Keys == 'other' then
      --Add your own code here.
    end
  end

  local timeout = 10
  while not NetworkDoesEntityExistWithNetworkId(veh) and timeout > 0 do
      timeout = timeout - 1
      Wait(1000)
  end
end)



RegisterNetEvent('nc-rentals:papercheck')
AddEventHandler('nc-rentals:papercheck', function()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local vin = GetVehicleNumberPlateText(plyVeh)
    local isRental = vin ~= nil and string.sub(vin, 1, 4) == "RXTN"

    if isRental then
      ESX.TriggerServerCallback('nc-rentals:server:hasrentalpapers', function(HasItem)
        if HasItem then
          if Config.Keys == "cd_garage" then
            TriggerEvent('cd_garage:AddKeys', vin)
          elseif Config.Keys == "t1ger_keys" then
            local veh_name = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(plyVeh)))
            exports['t1ger_keys']:GiveTemporaryKeys(vin, veh_name, 'Rental')
          elseif Config.Keys == 'other' then
            --Add your own code here.
          end
          ESX.ShowNotification('You received the vehicle keys.')
        end
      end, vin)
    else
      ESX.ShowNotification('This rental does not exist.')
    end
end)

CreateThread(function()
  exports['qtarget']:AddCircleZone("nc-rental-legion", vector3(109.0720, -1089.7605, 28.3033), 0.5, {
    name="nc-rental-legion",
    heading=306.7711,
    debugPoly=false,
    minZ= 27.3033,
    maxZ= 29.3033
    }, {
      options = {
          {
            event = "nc-rentals:vehiclelist",
            icon = "fas fa-comments-dollar",
            label = "Rent vehicle",
            location = vector4(110.9995, -1081.4813, 28.6714, 339.0954)
          },
          {
            event = "nc-rentals:returnvehicle",
            icon = "fas fa-receipt",
            label = "Return Vehicle"
          },
        },
      distance = 2.5
    }
  )
  exports['qtarget']:AddCircleZone("nc-rental-airport", vector3(-832.3906, -2348.7542, 14.5706), 0.5, {
    name="nc-rental-airport",
    heading=278.2155,
    debugPoly=false,
    minZ= 13.5706,
    maxZ= 15.5706
    }, {
        options = {
          {
            event = "nc-rentals:vehiclelist",
            icon = "fas fa-comments-dollar",
            label = "Rent vehicle",
            location = vector4(-823.6814, -2343.1284, 14.5706, 153.0381)
          },
          {
            event = "nc-rentals:returnvehicle",
            icon = "fas fa-receipt",
            label = "Return Vehicle"
          },
        },
      distance = 2.5
    }
  )
end)