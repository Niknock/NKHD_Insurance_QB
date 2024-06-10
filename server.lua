local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('getOwnedVehicles', function(source, cb)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local ownedVehicles = {}
    local src = source
    local PlayerData = QBCore.Players[src].PlayerData

    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = @citizenid', {
        ['@citizenid'] = PlayerData.citizenid
    }, function(data)
        for _, v in pairs(data) do
            local vehicle = json.decode(v.vehicle)
            table.insert(ownedVehicles, {
                plate = v.plate,
                insured = v.insured
            })
        end
        cb(ownedVehicles)
    end)
end)

RegisterServerEvent('nkhd:insureVehicle')
AddEventHandler('nkhd:insureVehicle', function(data)
    local source = source
    local plate = data.plate
    MySQL.Async.fetchScalar('SELECT insured FROM player_vehicles  WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(insured)
        if insured ~= nil then
            local newInsuranceStatus = 0
            if Insured == true then
                newInsuranceStatus = 0
            else
                newInsuranceStatus = 1
            end
            MySQL.Async.execute('UPDATE player_vehicles SET insured = @insured WHERE plate = @plate', {
                ['@insured'] = newInsuranceStatus,
                ['@plate'] = plate
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    TriggerClientEvent('nkhd:notifinssuc', source)
                else
                    
                end
            end)
        else
            
        end
    end)
end)

RegisterServerEvent('nkhd:removemoney')
AddEventHandler('nkhd:removemoney', function(source)
    local ox_inventory = exports.ox_inventory

    local items = ox_inventory:Search(source, 'count', {'money'})
    if items and items.money > 250 then
        ox_inventory:RemoveItem(source, 'money', 250)
    else
        print('Not enougth money!')
    end
end)
