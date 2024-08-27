

local QBCore = exports['qb-core']:GetCoreObject()
Config = Config or {} -- Provjera postojanja Config-a

-- Registracija automobila
RegisterNetEvent('spawngokart', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.Functions.RemoveMoney('cash', Config.Vehicle.price) then
        TriggerClientEvent('spawngokartClient', src)
        TriggerClientEvent('QBCore:Notify', src, 'Platili ste $' .. Config.Vehicle.price .. ' za korištenje vozila.', 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Nemate dovoljno novca!', 'error')
    end
end)
