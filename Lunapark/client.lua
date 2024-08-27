-- client.lua

local QBCore = exports['qb-core']:GetCoreObject()
Config = Config or {} -- Provjera postojanja Config-a
local rentalPed = nil -- Spremanje referenci na ped
local rentedVehicle = nil -- Spremanje referenci na iznajmljeno vozilo

-- Funkcija za spawnanje ped-a
function SpawnRentalPed()
    local pedModel = GetHashKey(Config.RentalPed.model)
    RequestModel(pedModel)
    
    while not HasModelLoaded(pedModel) do
        Wait(0)
    end

    rentalPed = CreatePed(4, pedModel, Config.RentalPed.location.x, Config.RentalPed.location.y, Config.RentalPed.location.z - 1.0, Config.RentalPed.location.heading, false, true)
    FreezeEntityPosition(rentalPed, true)
    SetEntityInvincible(rentalPed, true)
    SetBlockingOfNonTemporaryEvents(rentalPed, true)
end

-- Pokreni spawnanje ped-a kada se resurs učita
CreateThread(function()
    SpawnRentalPed()
end)

-- Interakcija s pedom
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local pedCoords = GetEntityCoords(rentalPed)
        local distance = #(playerCoords - pedCoords)

        if distance < 2.0 then
            -- Prikaži tekst za interakciju
            DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 1.0, "[E] Rent gokart - $" .. Config.Vehicle.price)
            
            -- Provjeri je li igrač pritisnuo tipku "E"
            if IsControlJustReleased(0, 38) then -- Tipka "E"
                TriggerServerEvent('spawngokart') -- Pokreni događaj na serveru
            end
        end
    end
end)

-- Funkcija za crtanje 3D teksta
function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

RegisterNetEvent('spawngokartClient', function()
    local vehicleModel = GetHashKey(Config.Vehicle.model)
    local playerPed = PlayerPedId()

    RequestModel(vehicleModel)
    while not HasModelLoaded(vehicleModel) do
        Wait(0)
    end

    -- Kreiraj vozilo na određenoj lokaciji
    rentedVehicle = CreateVehicle(vehicleModel, Config.VehicleSpawnLocation.x, Config.VehicleSpawnLocation.y, Config.VehicleSpawnLocation.z, Config.VehicleSpawnLocation.heading, true, false)
    SetPedIntoVehicle(playerPed, rentedVehicle, -1)  -- Stavi igrača u vozilo
    SetVehicleNumberPlateText(rentedVehicle, Config.Vehicle.plate)
end)

-- Provjeri napuštanje vozila i uklanjanje vozila
CreateThread(function()
    while true do
        Wait(1000) -- Provjeri svakih 1 sekundu
        local playerPed = PlayerPedId()
        if rentedVehicle then
            if not IsPedInVehicle(playerPed, rentedVehicle, false) then
                -- Ako igrač nije u vozilu, ukloni vozilo
                DeleteVehicle(rentedVehicle)
                rentedVehicle = nil -- Resetiraj referencu nakon brisanja
                TriggerEvent('QBCore:Notify', 'Vozilo je uklonjeno jer ste ga napustili.', 'error')
            end
        end
    end
end)
