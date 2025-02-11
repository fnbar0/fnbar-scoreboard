local ESX = exports['es_extended']:getSharedObject()
local using = false

local PlayersUsing = {}

function scoreboardActive()
    using = true
    local activePlayers = GetActivePlayers()
    while using do
        local sleep = 500
        if Config.Slowmotion then 
            SetPedMoveRateOverride(cache.ped, 0.3)
        end 
        for _, playerId in ipairs(activePlayers) do
            local ped = GetPlayerPed(playerId)
            local dist = #(GetEntityCoords(cache.ped) - GetEntityCoords(ped))
            local onScreen = IsEntityOnScreen(ped)
            if dist > Config.DrawDistance or not onScreen then
                goto continue
            end
            
            local boneIndex = GetPedBoneIndex(ped, 0x796E)
            local bonePos = GetWorldPositionOfEntityBone(ped, boneIndex)
            local playerServerId = GetPlayerServerId(playerId)
            local playerGroup = Player(playerServerId).state.group

            if not Player(playerServerId).state.admintag then
                playerGroup = 'user'
            end 
            local title = Config.GroupSettings[playerGroup] and Config.GroupSettings[playerGroup].title or playerGroup
            local color = Config.GroupSettings[playerGroup] and Config.GroupSettings[playerGroup].color or {r = 255, g = 255, b = 255, a = 255}

            if Config.CustomTags[Player(playerServerId).state.license] and Player(playerServerId).state.admintag then
                title = Config.CustomTags[Player(playerServerId).state.license].title
                color = Config.CustomTags[Player(playerServerId).state.license].color
            end 

            sleep = 0
            Draw3DText(bonePos.x, bonePos.y, bonePos.z + 0.8, title, 4, color)
            Draw3DText(bonePos.x, bonePos.y, bonePos.z + 0.5, playerServerId, 4, MumbleIsPlayerTalking(playerId) and {r = 11, g = 112, b = 242, a = 255} or {r = 255, g = 255, b = 255, a = 255})
            ::continue::
        end
        Wait(sleep) 
    end
end 


function updateScoreboard(target, value)
    if not target or not value then return end
    Wait(50)
    SendNUIMessage({
        type = 'update',
        data = {
            target = target,
            value = value
        }
    })
end

function Draw3DText(x, y, z, text, font, color)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local camCoords = GetFinalRenderedCamCoord()
    local distance = #(vec3(x, y, z) - camCoords)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

	if onScreen then
		SetTextScale(1.0 * scale, 1.55 * scale)
		SetTextFont(font)
		SetTextProportional(1)
		SetTextColour(color.r, color.g, color.b, color.a)
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end

Citizen.CreateThread(function()
    while true do 
        local sleep = 500
        for k, v in pairs(PlayersUsing) do
            local player = GetPlayerFromServerId(k)
            if player == cache.playerId then
                PlayersUsing[k] = nil
                goto continue
            end
            if player then
                local ped = GetPlayerPed(player)
                local boneIndex = GetPedBoneIndex(ped, 0x796E)
                local bonePos = GetWorldPositionOfEntityBone(ped, boneIndex)
                local onScreen = IsEntityOnScreen(ped)
                if #(GetEntityCoords(cache.ped) - bonePos) > Config.DrawDistance or not onScreen then
                    goto continue
                end
                sleep = 0
                Draw3DText(bonePos.x, bonePos.y, bonePos.z + 0.3, Config.UsingText, 6, {r = 11, g = 112, b = 242, a = 255})
            end
            ::continue::
        end 
        Wait(sleep)
    end     
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    updateScoreboard('currentjob', job.label)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    updateScoreboard('currentjob', xPlayer.job.label)
    updateScoreboard('total', GlobalState.playerCount)
    updateScoreboard('jobs', GlobalState.scoreboardJobsCounter)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    Wait(500)
    updateScoreboard('currentjob', ESX.GetPlayerData().job.label)
    updateScoreboard('total', GlobalState.playerCount)
    updateScoreboard('jobs', GlobalState.scoreboardJobsCounter)
end)

AddStateBagChangeHandler('playerCount', 'global', function(bagName, key, value) 
    updateScoreboard('total', value)
end)

AddStateBagChangeHandler('scoreboardJobsCounter', 'global', function(bagName, key, value) 
    updateScoreboard('jobs', value)
end)

AddStateBagChangeHandler('scoreboardPlayersUsing', 'global', function(bagName, key, value) 
    PlayersUsing = value
end)


RegisterCommand('+scoreboard', function()
    SendNUIMessage({
        type = 'show'
    })
    TriggerServerEvent('fnbar-scoreboard:togglePlayerUsing')
    Citizen.CreateThread(scoreboardActive)
end)

RegisterCommand('-scoreboard', function()
    SendNUIMessage({
        type = 'hide'
    })
    TriggerServerEvent('fnbar-scoreboard:togglePlayerUsing')
    using = false
end)

RegisterKeyMapping('+scoreboard', 'Open Scoreboard', 'keyboard', 'Z')

AddEventHandler('fnbar-updatecolors', function(colors) -- https://github.com/fnbar0/fnbar-hud
    SendNUIMessage({ updatedColors = colors })
end)
