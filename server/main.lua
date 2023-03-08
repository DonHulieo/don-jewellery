local QBCore = exports['qb-core']:GetCoreObject()

local TimeOuts = {
  [1] = false,
  [2] = false,
  [3] = false
}

local CachedPoliceAmount = {}
local Flags = {}

-------------------------------- FUNCTIONS --------------------------------

local function randumNum(min, max)
  math.randomseed(os.time())
  return math.floor(math.random() * (max - min) + min)
end

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
    }
  )
  TriggerEvent('qb-log:server:CreateLog', 'jewelery', 'Player Banned', 'red',
  string.format('%s was banned by %s for %s', GetPlayerName(id), 'qb-jewelery', reason), true)
  DropPlayer(id, 'You were permanently banned by the server for: Exploiting')
end

-------------------------------- EVENTS --------------------------------

RegisterServerEvent('don-jewellery:server:RemoveDoorItem', function()
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  local item = Config.DoorItem
  if not Player then return end
  Player.Functions.RemoveItem(item, 1)
end)

RegisterServerEvent('don-jewellery:server:SetVitrineState', function(stateType, state, k)
  if stateType == 'isBusy' and type(state) == 'boolean' and Config.Locations[k] then
    Config.Locations[k][stateType] = state
    TriggerClientEvent('don-jewellery:client:SetVitrineState', -1, stateType, state, k)
  end
end)

RegisterServerEvent('don-jewellery:server:StoreHit', function(storeIndex, bool)
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  if not Player then return end
  TriggerClientEvent('don-jewellery:client:StoreHit', -1, storeIndex, bool)
  if storeIndex == 'all' then Config.Stores[1].hacked = bool end
  for i = 1, #Config.Stores do
    if storeIndex == 'all' then
      Config.Stores[i].hit = bool
    else
      if i == storeIndex then
        Config.Stores[storeIndex].hit = bool
      end
    end
  end
end)

RegisterServerEvent('don-jewellery:server:ToggleDoorlocks', function(store, locked, allStores)
  local src = source
  if not allStores then
    TriggerClientEvent('qb-doorlock:client:setState', -1, src, Config.Stores[store]['Doors'].main, locked, src, false, false)
  else
    for i = 1, #Config.Stores do
      TriggerClientEvent('qb-doorlock:client:setState', -1, src, Config.Stores[i]['Doors'].main, locked, src, false, false)
      TriggerClientEvent('qb-doorlock:client:setState', -1, src, Config.Stores[i]['Doors'].sec, locked, src, false, false)
    end
  end
end)

RegisterServerEvent('don-jewellery:server:VitrineReward', function(vitrineIndex)
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  local cheating = false
  if not Config.Locations[vitrineIndex] or Config.Locations[vitrineIndex].isOpened then 
    exploitBan(src, 'Trying to trigger an exploitable event \"don-jewellery:server:VitrineReward\"') 
    return 
  end
  if not CachedPoliceAmount[src] then DropPlayer(src, 'Exploiting') return end

  local plrPed = GetPlayerPed(src)
  local plrCoords = GetEntityCoords(plrPed)
  local vitrineCoords = Config.Locations[vitrineIndex].coords
  if CachedPoliceAmount[src] >= Config.RequiredCops then
    if plrPed then
      local dist = #(plrCoords - vitrineCoords)
      if dist <= 25.0 then
        Config.Locations[vitrineIndex].isOpened = true
        Config.Locations[vitrineIndex].isBusy = false
        TriggerClientEvent('don-jewellery:client:SetVitrineState', -1, 'isOpened', true, vitrineIndex)
        TriggerClientEvent('don-jewellery:client:SetVitrineState', -1, 'isBusy', false, vitrineIndex)

        local reward = Config.VitrineRewards[randumNum(1, #Config.VitrineRewards)]
        local amount = randumNum(reward['Amounts'].min, reward['Amounts'].max)
        if Player.Functions.AddItem(reward.item, amount) then
          TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[reward.item], 'add')
        else
          TriggerClientEvent('QBCore:Notify', src, Lang:t('error.to_much'), 'error')
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
    if Flags[license] then
      Flags[license] = Flags[license] + 1
    else
      Flags[license] = 1
    end
    if Flags[license] >= 3 then
      exploitBan('Getting flagged many times from exploiting the \"don-jewellery:server:VitrineReward\" event')
    else
      DropPlayer(src, 'Exploiting')
    end
  end
end)

RegisterServerEvent('don-jewellery:server:SetTimeout', function(vitrine)
  local store = 0
  if vitrine >= 1 and vitrine <= 20 then
    store = 1
  elseif vitrine >= 21 and vitrine <= 26 then
    store = 2
  elseif vitrine >= 27 and vitrine <= 32 then
    store = 3
  end
  if not TimeOuts[store] then
    TimeOuts[store] = true
    TriggerEvent('qb-scoreboard:server:SetActivityBusy', 'jewellery', true)
    CreateThread(function()
      Wait(Config.Timeout)
      Config.Stores[1].hacked = false
      for i = 1, #Config.Stores do
        Config.Stores[i].hit = false
      end
      TriggerClientEvent('don-jewellery:client:StoreHit', -1, 'all', false)
      for i = 1, #Config.Locations do
        Config.Locations[i].isOpened = false
        TriggerClientEvent('don-jewellery:client:SetVitrineState', -1, 'isOpened', false, i)
        TriggerClientEvent('don-jewellery:client:SetAlertState', -1, false)
        TriggerEvent('qb-scoreboard:server:SetActivityBusy', 'jewellery', false)
      end
      TimeOuts[store] = false
    end)
  end
end)

-------------------------------- CALLBACKS --------------------------------

QBCore.Functions.CreateCallback('don-jewellery:server:GetCops', function(source, cb)
  local src = source
	local amount = 0
  for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
    if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
      amount = amount + 1
    end
  end
  CachedPoliceAmount[src] = amount
  cb(amount)
end)

QBCore.Functions.CreateCallback('don-jewellery:server:GetJewelleryState', function(_, cb)
  local data = {Locations = Config.Locations, Hacks = Config.Stores}
	cb(data)
end)