local ESX = exports['es_extended']:getSharedObject()
local PlayersUsing = {}
local scoreboardJobsCounter = {
    ['mechanic'] = 0,
    ['police'] = 0,
    ['ambulance'] = 0
}

function changeJobValue(job, action)
    for k, v in pairs(scoreboardJobsCounter) do
        if k == job.name then
            scoreboardJobsCounter[k] = scoreboardJobsCounter[k] + (action == 'add' and 1 or -1)
        end 
    end
    GlobalState.scoreboardJobsCounter = scoreboardJobsCounter
end 

function jobsCounter()
    for k, xPlayer in pairs(ESX.GetExtendedPlayers()) do
        changeJobValue(xPlayer.job, 'add')
        Player(xPlayer.source).state.admintag = true
    end
    GlobalState.scoreboardJobsCounter = scoreboardJobsCounter
end 

RegisterCommand('ToggleAdmintag', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.group ~= 'user' or Config.CustomTags[xPlayer.license] then 
        Player(source).state.admintag = not Player(source).state.admintag
    end 
end)

AddEventHandler('esx:setJob', function(player, job, lastJob)
    changeJobValue(job, 'add')
    changeJobValue(lastJob, 'remove')
end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    Player(source).state.admintag = true
    changeJobValue(xPlayer.job, 'add')
end)

AddEventHandler('esx:playerDropped', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    changeJobValue(xPlayer.job, 'remove')
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    Wait(300)
    local players = GetPlayers()
    jobsCounter()
end)

RegisterNetEvent('fnbar-scoreboard:togglePlayerUsing')
AddEventHandler('fnbar-scoreboard:togglePlayerUsing', function()
    local playerSource = source 
    if PlayersUsing[playerSource] then
        PlayersUsing[playerSource] = nil
    else
        PlayersUsing[playerSource] = true
    end
    GlobalState.scoreboardPlayersUsing = PlayersUsing
end)
