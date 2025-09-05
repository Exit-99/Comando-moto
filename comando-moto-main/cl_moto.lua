ESX = exports["es_extended"]:getSharedObject()

local isDead = false
local spawnedVehicle = nil
local playerPed = PlayerPedId()
local coords = GetEntityCoords(playerPed)
local heading = GetEntityHeading(playerPed)

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function()
    isDead = true
    if spawnedVehicle then
        DeleteVehicle(spawnedVehicle)
        spawnedVehicle = nil
    end
end)

AddEventHandler('playerSpawned', function()
    isDead = false
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if spawnedVehicle then
            if not IsPedInVehicle(playerPed, spawnedVehicle, false) then
                DeleteVehicle(spawnedVehicle)
                spawnedVehicle = nil
            end
        end
    end
end)

RegisterCommand('moto', function()
    
    if isDead then
        ESX.ShowNotification("Non puoi spawnare una moto da morto!")
        return
    end

    if IsPedInAnyVehicle(playerPed, false) then
        ESX.ShowNotification("Sei già su un veicolo!")
        return
    end

    ESX.Game.SpawnVehicle('bf400', coords, heading, function(vehicle)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        spawnedVehicle = vehicle
    end)

end, false)
