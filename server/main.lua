local QBCore = exports['qb-core']:GetCoreObject()
local timeOut = false

local cachedPoliceAmount = {}
local flags = {}

-- Callback

QBCore.Functions.CreateCallback('don-jewellery:server:getCops', function(source, cb)
	local amount = 0
    for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    cachedPoliceAmount[source] = amount
    cb(amount)
end)

QBCore.Functions.CreateCallback('don-jewellery:server:getVitrineState', function(_, cb)
	cb(Config.Locations)
end)

-- Functions

local function exploitBan(id, reason)
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)',
        {
            GetPlayerName(id),
            QBCore.Functions.GetIdentifier(id, 'license'),
            QBCore.Functions.GetIdentifier(id, 'discord'),
            QBCore.Functions.GetIdentifier(id, 'ip'),
            reason,
            2147483647,
            'qb-jewelery'
        })
    TriggerEvent('qb-log:server:CreateLog', 'jewelery', 'Player Banned', 'red',
        string.format('%s was banned by %s for %s', GetPlayerName(id), 'qb-jewelery', reason), true)
    DropPlayer(id, 'You were permanently banned by the server for: Exploiting')
end

-- Events

RegisterNetEvent('don-jewellery:server:RemoveDoorItem', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local item = Config.DoorItem
    if not Player then return end
    Player.Functions.RemoveItem(item, 1)
end)

RegisterNetEvent('don-jewellery:server:setVitrineState', function(stateType, state, k)
    if stateType == "isBusy" and type(state) == "boolean" and Config.Locations[k] then
        Config.Locations[k][stateType] = state
        TriggerClientEvent('don-jewellery:client:setVitrineState', -1, stateType, state, k)
    end
end)

RegisterNetEvent('don-jewellery:server:StoreHit')
AddEventHandler('don-jewellery:server:StoreHit', function(k, bool)
    TriggerClientEvent('don-jewellery:client:StoreHit', -1, k, bool)
end)

RegisterNetEvent('don-jewellery:server:vitrineReward', function(vitrineIndex)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local otherchance = math.random(1, 4)
    local odd = math.random(1, 4)
    local cheating = false

    if Config.Locations[vitrineIndex] == nil or Config.Locations[vitrineIndex].isOpened ~= false then
        exploitBan(src, "Trying to trigger an exploitable event \"don-jewellery:server:vitrineReward\"")
        return
    end
    if cachedPoliceAmount[source] == nil then
        DropPlayer(src, "Exploiting")
        return
    end

    local plrPed = GetPlayerPed(src)
    local plrCoords = GetEntityCoords(plrPed)
    local vitrineCoords = Config.Locations[vitrineIndex].coords

    if cachedPoliceAmount[source] >= Config.RequiredCops then
        if plrPed then
            local dist = #(plrCoords - vitrineCoords)
            if dist <= 25.0 then
                Config.Locations[vitrineIndex]["isOpened"] = true
                Config.Locations[vitrineIndex]["isBusy"] = false
                TriggerClientEvent('don-jewellery:client:setVitrineState', -1, "isOpened", true, vitrineIndex)
                TriggerClientEvent('don-jewellery:client:setVitrineState', -1, "isBusy", false, vitrineIndex)

                if otherchance == odd then
                    local item = math.random(1, #Config.VitrineRewards)
                    local amount = math.random(Config.VitrineRewards[item]["amount"]["min"], Config.VitrineRewards[item]["amount"]["max"])
                    if Player.Functions.AddItem(Config.VitrineRewards[item]["item"], amount) then
                        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.VitrineRewards[item]["item"]], 'add')
                    else
                        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.to_much'), 'error')
                    end
                else
                    local amount = math.random(2, 4)
                    if Player.Functions.AddItem("10kgoldchain", amount) then
                        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["10kgoldchain"], 'add')
                    else
                        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.to_much'), 'error')
                    end
                end
            else
                cheating = true
            end
        end
    else
        cheating = true
    end

    if cheating then
        local license = Player.PlayerData.license
        if flags[license] then
            flags[license] = flags[license] + 1
        else
            flags[license] = 1
        end
        if flags[license] >= 3 then
            exploitBan("Getting flagged many times from exploiting the \"don-jewellery:server:vitrineReward\" event")
        else
            DropPlayer(src, "Exploiting")
        end
    end
end)

RegisterNetEvent('don-jewellery:server:setTimeout', function()
    if not timeOut then
        timeOut = true
        TriggerEvent('qb-scoreboard:server:SetActivityBusy', "jewellery", true)
        Citizen.CreateThread(function()
            Citizen.Wait(Config.Timeout)

            for k, _ in pairs(Config.Locations) do
                Config.Locations[k]["isOpened"] = false
                TriggerClientEvent('don-jewellery:client:setVitrineState', -1, 'isOpened', false, k)
                TriggerClientEvent('don-jewellery:client:setAlertState', -1, false)
                TriggerEvent('qb-scoreboard:server:SetActivityBusy', "jewellery", false)
            end
            timeOut = false
        end)
    end
end)
