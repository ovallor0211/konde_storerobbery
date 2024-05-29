QBCore = Nil
local QBCore = exports['qb-core']:GetCoreObject()
local cooldowns = {}

RegisterServerEvent('RoboBadulaqueEnCurso')
AddEventHandler('RoboBadulaqueEnCurso', function(pointName)
    local player = source
    local playerId = tostring(player)  -- Convertir a cadena para usar como clave en la tabla
    local currentTime = os.time()
    local cooldownTime = 500  -- Cooldown de 5 minutos (300 segundos)

    if QBCore ~= nil then
        local xPlayer = QBCore.Functions.GetPlayer(player)
        
        if xPlayer ~= nil then
            if cooldowns[playerId] and (currentTime - cooldowns[playerId] < cooldownTime) then
                local remainingTime = cooldownTime - (currentTime - cooldowns[playerId])
                TriggerClientEvent('showNotification', player, "Debes esperar " .. remainingTime .. " segundos para poder hacer un robo")
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
            TriggerClientEvent('disablePlayerMovement', player, false)
        else
            print("Error: No se pudo obtener el jugador de QBCore.")
        end
    else
        print("Error: QBCore no está cargado.")
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

RegisterCommand('robspolice', function(source, args, rawCommand)
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
