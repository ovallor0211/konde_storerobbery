QBCore = Nil
local QBCore = exports['qb-core']:GetCoreObject()

local Robpoint = {
    {
        name = "Badulaque", -- theft point
        coords = vector3(378.16, 333.24, 103.57)
    },
    {
        name = "Badulaque",
        coords = vector3(2549.54, 384.87, 108.62)
    },
    {
        name = "Badulaque",
        coords = vector3(28.44, -1339.38, 29.5)
    },
    {
        name = "Badulaque",
        coords = vector3(546.43, 2662.74, 42.16)
    },
    {
        name = "Badulaque",
        coords = vector3(2673.08, 3286.45, 55.24)
    },
}

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, point in ipairs(Robpoint) do
            local distance = GetDistanceBetweenCoords(playerCoords, point.coords, true)
            if distance < 2.5 then
                DrawText3D(point.coords.x, point.coords.y, point.coords.z - 0.3, "~g~E~w~ - Comenzar robo de  " .. point.name)
                if IsControlJustPressed(0, 38) then -- E
                    QBCore.Functions.TriggerCallback('CheckMinCopsRequired', function(minCopsRequired)
                        if minCopsRequired then
                            QBCore.Functions.TriggerCallback('CheckPoliceCount', function(policeCount)
                                if policeCount >= 2 then
                                    TriggerServerEvent('RoboBadulaqueEnCurso', point.name)
                                else
                                    TriggerEvent("QBCore:Notify", "Necesitas al menos 2 policías de servicio para empezar el robo", "error")
                                end
                            end)
                        else
                            TriggerServerEvent('RoboBadulaqueEnCurso', point.name)
                        end
                    end)
                end
                break
            end
        end

        Citizen.Wait(0)
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.02 + factor, 0.03, 33, 33, 33, 68)
end

RegisterNetEvent('RoboConseguido')
AddEventHandler('RoboConseguido', function(pointName)
    TriggerEvent("QBCore:Notify", "Robo de finalizado", "success")
end)
RegisterNetEvent('RoboComenzado')
AddEventHandler('RoboComenzado', function(pointName)
    TriggerEvent("QBCore:Notify", "Has comenzado el robo", "success")
    TriggerEvent("Opto_dispatch:Client:SendVehRob")
end)

local isMovementDisabled = false

RegisterNetEvent('disablePlayerMovement')
AddEventHandler('disablePlayerMovement', function(disable)
    isMovementDisabled = disable
    if disable then
        -- Desactiva todos los controles del jugador
        Citizen.CreateThread(function()
            while isMovementDisabled do
                Citizen.Wait(0)
                DisableControlAction(0, 30, true) -- Disable moving left/right
                DisableControlAction(0, 31, true) -- Disable moving forward/back
                DisableControlAction(0, 32, true) -- Disable moving forward
                DisableControlAction(0, 33, true) -- Disable moving back
                DisableControlAction(0, 34, true) -- Disable moving left
                DisableControlAction(0, 35, true) -- Disable moving right
                DisableControlAction(0, 21, true) -- Disable sprint
                DisableControlAction(0, 22, true) -- Disable jump
            end
        end)
    end
end)

RegisterNetEvent('playAnimation')
AddEventHandler('playAnimation', function()
    local playerPed = PlayerPedId()
    local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
    local animName = "machinic_loop_mechandplayer"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, 5000, 1, 0, false, false, false)
    Citizen.Wait(5000)
    ClearPedTasks(playerPed)
end)
