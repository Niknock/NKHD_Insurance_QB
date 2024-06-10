QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(Config.Marker.x, Config.Marker.y, Config.Marker.z)

    SetBlipSprite(blip, 380)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 17)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Insurance')
    EndTextCommandSetBlipName(blip)

    local marker = vector3(Config.Marker.x, Config.Marker.y, Config.Marker.z)
    while true do
        Citizen.Wait(0)
        DrawMarker(1, marker.x, marker.y, marker.z - 1, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 255, 255, 255, 200, 0, 0, 0, 0)
    end
end)

RegisterNetEvent('nkhd:triggerinsureVehicle')
AddEventHandler('nkhd:triggerinsureVehicle', function(args)
    print('Test')
    TriggerServerEvent('nkhd:insureVehicle', args)
end)

RegisterNetEvent('showInsuranceMenu')
AddEventHandler('showInsuranceMenu', function()
    local elements = {}
    QBCore.Functions.TriggerCallback('getOwnedVehicles', function(ownedVehicles)
        for _, vehicle in ipairs(ownedVehicles) do
            local insuranceLabel = {}
            if vehicle.insured == true then
                insuranceLabel = 'Insured'
            elseif vehicle.insured == false then
                insuranceLabel = 'Not Insured'
            elseif vehicle.insured ~= 1 or vehicle.insured ~= 0 then
                insuranceLabel = vehicle.insured
            end
            table.insert(elements, {
                title = string.format("%s (%s)", vehicle.plate, insuranceLabel),
                description = "Click to toggle insurance",
                args = { plate = vehicle.plate },
                event = 'nkhd:triggerinsureVehicle',
            })
        end

        lib.registerContext({
            id = 'insurance_menu',
            title = 'Insurance',
            options = elements
        })
        lib.showContext('insurance_menu')
    end)
end)

RegisterNetEvent('nkhd:removemoneyclient')
AddEventHandler('nkhd:removemoneyclient', function()
    TriggerServerEvent('nkhd:removemoney', source)
end)

RegisterNetEvent('nkhd:notifinssuc')
AddEventHandler('nkhd:notifinssuc', function()
    ShowNotification('Vehicle Insured')
end)

Citizen.CreateThread(function()
    local inRange = false
    while true do
        inRange = false
        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)
        local targetCoords = vector3(Config.Marker.x, Config.Marker.y, Config.Marker.z)
        local distance = #(myCoords - targetCoords)
        if distance < 1.5 then
            inRange = true
            QBCore.Functions.DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z, 'Press [E] to open insurance menu')
            if IsControlJustPressed(0, 38) then
                inRange = false
                TriggerEvent('showInsuranceMenu')
            end
        end
        Citizen.Wait(0)
    end
end)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end
