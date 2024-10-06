QBCore = exports['qb-core']:GetCoreObject()

-- Promote Employee
RegisterNetEvent('police:server:PromoteEmployee', function(employeeId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Employee = QBCore.Functions.GetPlayer(employeeId)

    if Player.job.name == 'police' and Player.job.grade >= 3 then -- Assuming grade 3 or higher can promote
        local newGrade = Employee.job.grade + 1
        if newGrade <= 4 then -- Max grade is 4
            Employee.Functions.SetJob('police', newGrade)
            TriggerClientEvent('QBCore:Notify', src, 'Employee promoted', 'success')
            TriggerClientEvent('QBCore:Notify', employeeId, 'You have been promoted', 'success')
        else
            TriggerClientEvent('QBCore:Notify', src, 'Cannot promote further', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'You do not have permission', 'error')
    end
end)

-- Demote Employee
RegisterNetEvent('police:server:DemoteEmployee', function(employeeId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Employee = QBCore.Functions.GetPlayer(employeeId)

    if Player.job.name == 'police' and Player.job.grade >= 3 then -- Assuming grade 3 or higher can demote
        local newGrade = Employee.job.grade - 1
        if newGrade >= 0 then -- Min grade is 0
            Employee.Functions.SetJob('police', newGrade)
            TriggerClientEvent('QBCore:Notify', src, 'Employee demoted', 'success')
            TriggerClientEvent('QBCore:Notify', employeeId, 'You have been demoted', 'error')
        else
            TriggerClientEvent('QBCore:Notify', src, 'Cannot demote further', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'You do not have permission', 'error')
    end
end)

-- Get Employees
QBCore.Functions.CreateCallback('police:server:GetEmployees', function(source, cb)
    local employees = {}
    for _, player in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(player)
        if Player.job.name == 'police' then
            table.insert(employees, {
                id = Player.PlayerData.source,
                name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
                grade = Player.job.grade
            })
        end
    end
    cb(employees)
end)