-- Initialize QBCore
QBCore = exports['qb-core']:GetCoreObject()

-- Define Police Job
-- Job Definition
QBCore.Functions.CreateJob('police', {
    label = 'Police',
    defaultDuty = true,
    grades = {
        ['0'] = {
            name = 'Cadet',
            payment = 50
        },
        ['1'] = {
            name = 'Officer',
            payment = 100
        },
        ['2'] = {
            name = 'Sergeant',
            payment = 150
        },
        ['3'] = {
            name = 'Lieutenant',
            payment = 200
        },
        ['4'] = {
            name = 'Chief',
            payment = 250
        }
    }
})

-- Open Boss Menu
RegisterNetEvent('police:client:OpenBossMenu', function(employees)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'openBossMenu',
        employees = employees
    })
end)

-- Close Boss Menu
RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Promote Employee
RegisterNUICallback('promoteEmployee', function(data, cb)
    TriggerServerEvent('police:server:PromoteEmployee', data.employeeId)
    cb('ok')
end)

-- Demote Employee
RegisterNUICallback('demoteEmployee', function(data, cb)
    TriggerServerEvent('police:server:DemoteEmployee', data.employeeId)
    cb('ok')
end)

-- Command to open boss menu
RegisterCommand('openbossmenu', function()
    local player = QBCore.Functions.GetPlayerData()
    if player.job.name == 'police' and player.job.grade >= 3 then -- Assuming grade 3 or higher can access boss menu
        QBCore.Functions.TriggerCallback('police:server:GetEmployees', function(employees)
            TriggerEvent('police:client:OpenBossMenu', employees)
        end)
    else
        QBCore.Functions.Notify('You do not have permission', 'error')
    end
end, false)

-- Register Events
RegisterNetEvent('police:client:OnDuty', function()
    local player = QBCore.Functions.GetPlayerData()
    if player.job.name == 'police' then
        -- Logic for going on duty
        QBCore.Functions.Notify('You are now on duty', 'success')
    end
end)

RegisterNetEvent('police:client:OffDuty', function()
    local player = QBCore.Functions.GetPlayerData()
    if player.job.name == 'police' then
        -- Logic for going off duty
        QBCore.Functions.Notify('You are now off duty', 'error')
    end
end)

-- Add Commands
RegisterCommand('cuff', function(source, args, rawCommand)
    local player = QBCore.Functions.GetPlayerData()
    if player.job.name == 'police' then
        -- Logic for cuffing a player
        QBCore.Functions.Notify('You have cuffed the player', 'success')
    end
end, false)

RegisterCommand('uncuff', function(source, args, rawCommand)
    local player = QBCore.Functions.GetPlayerData()
    if player.job.name == 'police' then
        -- Logic for uncuffing a player
        QBCore.Functions.Notify('You have uncuffed the player', 'success')
    end
end, false)

local blip = nil
local panicButtonCooldown = false

CreateThread(function()
    while true do
        Wait(1000) -- Check every second
        local player = QBCore.Functions.GetPlayerData()
        if player.job.name == 'police' then
            -- Logic for police job (e.g., blips, markers)
            if LEO_GPS('gps_tracker') then -- Replace 'gps_tracker' with your item name
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                if not blip then
                    blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                    SetBlipSprite(blip, 1) -- Change blip sprite as needed
                    SetBlipColour(blip, 3) -- Change blip color as needed
                    SetBlipScale(blip, 1.0)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Officer")
                    EndTextCommandSetBlipName(blip)
                else
                    SetBlipCoords(blip, coords.x, coords.y, coords.z)
                end
            else
                if blip then
                    RemoveBlip(blip)
                    blip = nil
                end
            end
        else
            if blip then
                RemoveBlip(blip)
                blip = nil
            end
        end
    end
end)

RegisterCommand('panic', function()
    if not panicButtonCooldown then
        local player = QBCore.Functions.GetPlayerData()
        if player.job.name == 'police' then
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            TriggerServerEvent('police:server:PanicButton', coords)
            QBCore.Functions.Notify('Panic button activated!', 'error')
            panicButtonCooldown = true
            SetTimeout(60000, function() -- 1 minute cooldown
                panicButtonCooldown = false
            end)
        else
            QBCore.Functions.Notify('You are not a police officer!', 'error')
        end
    else
        QBCore.Functions.Notify('Panic button is on cooldown!', 'error')
    end
end, false)

RegisterNetEvent('police:client:PanicButtonAlert', function(coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 161)
    SetBlipScale(blip, 1.2)
    SetBlipColour(blip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Panic Button")
    EndTextCommandSetBlipName(blip)
    PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
    Wait(60000) -- Blip lasts for 1 minute
    RemoveBlip(blip)
end)

function LEO_GPS(itemName)
    local player = QBCore.Functions.GetPlayerData()
    for _, item in pairs(player.items) do
        if item.name == itemName and item.metadata and item.metadata.turnedOn then
            return true
        end
    end
    return false
end