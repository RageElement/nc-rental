local pedSpawned = false

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(1000)
          local pedCoords = GetEntityCoords(PlayerPedId()) 
          local spawnCoords = Config.locationthingy
          local dst = #(spawnCoords - pedCoords)
          
          if dst < 100 and pedSpawned == false then
              TriggerEvent('gb-rental:spawnPed',spawnCoords, 343.9986)
              pedSpawned = true
          end
          if dst >= 101  then
              pedSpawned = false
              DeleteEntity(npc)
          end
  end
end)
RegisterNetEvent('gb-rental:spawnPed')
AddEventHandler('gb-rental:spawnPed',function(coords, heading)
    local hash = `a_m_m_eastsa_01`
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        Wait(10)
    end
    while not HasModelLoaded(hash) do 
        Wait(10)
    end

    pedSpawned = true
    npc = CreatePed(5, hash, coords, heading, false, false)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    TaskStartScenarioInPlace(npc, 'WORLD_HUMAN_CLIPBOARD')
    SetModelAsNoLongerNeeded(hash)
    exports.qtarget:AddEntityZone("Rentalped", npc, {
      name="Rentalped",
      debugPoly=false,
      useZ = true,
      }, {
          options = {
              {
                  event = "gb-rental:vehiclelist",
                  icon = "fas fa-circle",
                  label = "Rent vehicle",
              },
              {
                  event = "gb-rental:returnvehicle",
                  icon = "fas fa-circle",
                  label = "Return Vehicle",
              },
          },
          distance = 3.5
    })
end)



RegisterNetEvent("gb-rental:vehiclelist")
AddEventHandler("gb-rental:vehiclelist", function()
  for i = 1, #Config.vehicleList do
    TriggerEvent('nh-context:sendMenu', {
      {
        id = Config.vehicleList[i].model,
        header = Config.vehicleList[i].name,
        txt = "$"..Config.vehicleList[i].price..".00",
        params = {
          event = "gb-rental:attemptvehiclespawn",
          args = {
            id = Config.vehicleList[i].model,
            price = Config.vehicleList[i].price,
          }
        }
      },
    })
  end
end)

RegisterNetEvent("gb-rental:attemptvehiclespawn")
AddEventHandler("gb-rental:attemptvehiclespawn", function(vehicle)
    TriggerServerEvent("gb-rental:attemptPurchase",vehicle.id, vehicle.price)
end)

RegisterNetEvent("gb-rental:attemptvehiclespawnfail")
AddEventHandler("gb-rental:attemptvehiclespawnfail", function()
  exports['mythic_notify']:DoHudText('error', 'Not enough money')
end)


RegisterNetEvent("gb-rental:returnvehicle")
AddEventHandler("gb-rental:returnvehicle", function()
  local car = GetVehiclePedIsIn(PlayerPedId(),true)

  if car ~= 0 then
    local plate = GetVehicleNumberPlateText(car)
    local vehname = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(car)))
    local papers = exports.ox_inventory:Search('slots', 'rentalpapers')
    for _, v in pairs(papers) do
      if string.find(tostring(plate), "GB") and string.find(json.encode(v.metadata), plate) then
        ESX.TriggerServerCallback('gb-rental:server:hasrentalpapers', function(HasItem)
          if HasItem then
            local hash = GetEntityModel(car)
            local model = GetDisplayNameFromVehicleModel(hash)
            TriggerServerEvent('gb-rental:removerentalpaperServer', plate, model)
            TriggerServerEvent('gb-rental:server:payreturn',vehname)
            DeleteVehicle(car)
            DeleteEntity(car)
          else
            exports['mythic_notify']:DoHudText('error', 'I cannot take a vehicle without proper papers.')
          end
        end)
      else
        exports['mythic_notify']:DoHudText('error', 'This is not a rented vehicle.')
      end
    end

  else
    exports['mythic_notify']:DoHudText('error', 'I don\'t see any rented vehicle, make sure its nearby.')
  end
end)

RegisterNetEvent("gb-rental:vehiclespawn")
AddEventHandler("gb-rental:vehiclespawn", function(data, cb)
  local model = data

  RequestModel(model)
  while not HasModelLoaded(model) do
      Citizen.Wait(0)
  end
  SetModelAsNoLongerNeeded(model)

  local veh = CreateVehicle(model, Config.carspawnlocation, true, false)
  Citizen.Wait(100)
  SetEntityAsMissionEntity(veh, true, true)
  SetModelAsNoLongerNeeded(model)
  SetVehicleOnGroundProperly(veh)
  SetVehicleNumberPlateText(veh, "GB"..tostring(math.random(1000, 9999)))


  --CARKEYS EVENT
  local plate = GetVehicleNumberPlateText(veh)
  --TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh), veh)
  TriggerServerEvent('hsn-hotwire:addKeys',plate)

  local plateText = GetVehicleNumberPlateText(veh)
  TriggerServerEvent("gb-rental:giverentalpaperServer",model ,plateText)

  local timeout = 10
  while not NetworkDoesEntityExistWithNetworkId(veh) and timeout > 0 do
      timeout = timeout - 1
      Wait(1000)
  end
end)



RegisterNetEvent('gb-rental:papercheck')
AddEventHandler('gb-rental:papercheck', function(info)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
      data = json.decode(info)
      local vin = GetVehicleNumberPlateText(plyVeh)
      local isRental = vin ~= nil and string.sub(vin, 2, 3) == "GB"
      if isRental then
    --CARKEYS EVENT
        TriggerServerEvent('hsn-hotwire:addKeys', GetVehicleNumberPlateText(plyVeh))
        exports['mythic_notify']:DoHudText('success', 'You received the vehicle keys.')
      else
        exports['mythic_notify']:DoHudText('error', 'This rental does not exist.')
      end
end)
