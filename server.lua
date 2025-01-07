QBCore = Nil
local QBCore = exports['qb-core']:GetCoreObject()
local cooldowns = {}

RegisterServerEvent('RoboBadulaqueEnCurso')
AddEventHandler('RoboBadulaqueEnCurso', function(pointName)
    local player = source
    local playerId = tostring(player)
    local currentTime = os.time()
    local cooldownTime = 500  -- Cooldown 5 minutes

    if QBCore ~= nil then
        local xPlayer = QBCore.Functions.GetPlayer(player)
        
        if xPlayer ~= nil then
            if cooldowns[playerId] and (currentTime - cooldowns[playerId] < cooldownTime) then
                local remainingTime = cooldownTime - (currentTime - cooldowns[playerId])
                TriggerClientEvent('showNotification', player, "You must wait " .. remainingTime .. " seconds to be able to make a robbery")
                return
            end
            cooldowns[playerId] = currentTime
            local bags = math.random(20302, 70320) -- give black money random
            local info = {}
            TriggerClientEvent('RoboComenzado', player)
            TriggerClientEvent('disablePlayerMovement', player, true)
            TriggerClientEvent('playAnimation', player)
            Citizen.Wait(5000)
            xPlayer.Functions.AddItem('black_money', bags, false, info)
            TriggerClientEvent('RoboConseguido', player, pointName)
            TriggerClientEvent('disablePlayerMovement', player, false)
        else
            print("Error: The player could not be obtained from QBCore.")
        end
    else
        print("Error: QBCore not uploaded.")
    end
end)

local minCopsRequired = true

QBCore.Functions.CreateCallback('CheckPoliceCount', function(source, cb)
    local policeCount = 0
    for _, player in ipairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(player)
        if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
            policeCount = policeCount + 1
        end
    end
    cb(policeCount)
end)

RegisterCommand('robspolice', function(source, args, rawCommand) -- police restraint command
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
        minCopsRequired = not minCopsRequired
        local status = minCopsRequired and "activado" or "desactivado"
        TriggerClientEvent('QBCore:Notify', source, "Restricción de policías para robos " .. status, "success")
    else
        TriggerClientEvent('QBCore:Notify', source, "No tienes permiso para usar este comando.", "error")
    end
end, false)

QBCore.Functions.CreateCallback('CheckMinCopsRequired', function(source, cb)
    cb(minCopsRequired)
end)

-- SIN CÓDIGO DE NUMEROS ALEATORIOS
/*if xPlayer ~= nil then
    if cooldowns[playerId] and (currentTime - cooldowns[playerId] < cooldownTime) then
        local remainingTime = cooldownTime - (currentTime - cooldowns[playerId])
        TriggerClientEvent('showNotification', player, "You must wait " .. remainingTime .. " seconds to be able to make a robbery")
        return
    end
    cooldowns[playerId] = currentTime
    local bags = 65300
    local info = {}
    TriggerClientEvent('RoboComenzado', player)
    TriggerClientEvent('disablePlayerMovement', player, true)
    TriggerClientEvent('playAnimation', player)
    Citizen.Wait(5000)
    xPlayer.Functions.AddItem('black_money', bags, false, info)
    TriggerClientEvent('RoboConseguido', player, pointName)
    TriggerClientEvent('disablePlayerMovement', player, false)*/