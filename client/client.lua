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

-- Client-Side Logic
CreateThread(function()
    while true do
        Wait(0)
        local player = QBCore.Functions.GetPlayerData()
        if player.job.name == 'police' then
            -- Logic for police job (e.g., blips, markers)
        end
    end