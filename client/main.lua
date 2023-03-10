local QBCore = exports['qb-core']:GetCoreObject()

local firstAlarm, secondAlarm, smashing, locked  = false, false, false, false

-------------------------------- FUNCTIONS --------------------------------

local function loadPtfx(name)
	if HasNamedPtfxAssetLoaded(name) then UseParticleFxAsset(name) return end
  RequestNamedPtfxAsset(name)
  repeat Wait(0) until HasNamedPtfxAssetLoaded(name)
  UseParticleFxAsset(name)
end

local function loadAnimDict(dict)
  if HasAnimDictLoaded(dict) then return end
  RequestAnimDict(dict)
  repeat Wait(0) until HasAnimDictLoaded(dict)
end

local function randomNum(min, max)
  math.randomseed(GetGameTimer())
  local num = math.random() * (max - min) + min
  if num % 1 >= 0.5 and math.ceil(num) <= max then
    return math.ceil(num)
  end
  return math.floor(num)
end

local function isStoreHit(vitrine, isStore)
  local hit = false
  if not vitrine then goto all end
  if isStore then goto store end
  if vitrine >= 1 and vitrine <= 20 then
    store = 1
  elseif vitrine >= 21 and vitrine <= 26 then
    store = 2
  elseif vitrine >= 27 and vitrine <= 32 then
    store = 3
  end
  if Config.Stores[store].hit then
    return true
  else
    return false
  end
  ::all::
  for i = 1, #Config.Stores do
    local v = Config.Stores[i]
    if v.hit then 
      hit = true 
    end
  end
  if hit then return true else return false end
  ::store::
  if Config.Stores[vitrine].hit then return true end
  return false
end

local function isStoreHacked()
  if Config.Stores[1].hacked then
    return true
  end
  return false 
end

local function createBlips()
  if not Config.OneStore then
    for k, v in pairs(Config.Stores) do
      local Dealer = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
      SetBlipSprite (Dealer, 617)
      SetBlipDisplay(Dealer, 4)
      SetBlipScale  (Dealer, 0.7)
      SetBlipAsShortRange(Dealer, true)
      SetBlipColour(Dealer, 3)
      AddTextEntry(v.label, v.label)
      BeginTextCommandSetBlipName(v.label)
      EndTextCommandSetBlipName(Dealer)
    end
  else
    local Dealer = AddBlipForCoord(Config.Stores[1].coords.x, Config.Stores[1].coords.y, Config.Stores[1].coords.z)
    SetBlipSprite (Dealer, 617)
    SetBlipDisplay(Dealer, 4)
    SetBlipScale  (Dealer, 0.7)
    SetBlipAsShortRange(Dealer, true)
    SetBlipColour(Dealer, 3)
    AddTextEntry(Config.Stores[1].label, Config.Stores[1].label)
    BeginTextCommandSetBlipName(Config.Stores[1].label)
    EndTextCommandSetBlipName(Dealer)
  end
end

local function removeBlips()
  local blip = GetFirstBlipInfoId(617)
  repeat RemoveBlip(blip); blip = GetNextBlipInfoId(617) until not DoesBlipExist(blip)
end

local function checkTime(start, finish)
  finish = finish - 1
  local hour = GetClockHours()
  local minute = GetClockMinutes()
  local isTime = false
  if start > finish then
    if hour == start then
      isTime = true
    elseif hour == 0 then
      isTime = true
    elseif hour <= finish then
      isTime = true
    else
      isTime = false
    end
  else
    if start <= hour and finish >= hour then
      isTime = true
    else
      isTime = false
    end
  end
  return isTime
end

local function validWeapon()
  local ped = PlayerPedId()
  local pedWeapon = GetSelectedPedWeapon(ped)
  for k, _ in pairs(Config.WhitelistedWeapons) do
    if pedWeapon == k then
      return true
    end
  end
  return false
end

local function isWearingHandshoes()
  local ped = PlayerPedId()
  local armIndex = GetPedDrawableVariation(ped, 3)
  local model = GetEntityModel(ped)
  local retval = true
  if model == `mp_m_freemode_01` then
    if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
      retval = false
    end
  else
    if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
      retval = false
    end
  end
  return retval
end

local function getCamID(k)
  local camID = 0
  if k <= 6 then
    camID = 31
  elseif k == 7 or k >= 18 and k <= 20 then
    camID = 32
  elseif k >= 12 and k <= 17 then
    camID = 33
  elseif k >= 8 and k <= 11 then
    camID = 34
  elseif k >= 21 and k <= 26 then
    camID = 35
  elseif k >= 27 and k <= 32 then
    camID = 36
  end
  return camID
end

local function alertsCD(alertType)
  local data = exports['cd_dispatch']:GetPlayerInfo()
  if alertType == 'robbery' then
    TriggerServerEvent('cd_dispatch:AddNotification', {
      job_table = {'police', }, 
      coords = data.coords,
      title = '10-65 - Jewelery Store Robbery',
      message = 'A '..data.sex..' robbing a Vangelico\'s at '..data.street, 
      flash = 0,
      unique_id = data.unique_id,
      sound = 1,
      blip = {
        sprite = 586, 
        scale = 1.2, 
        colour = 3,
        flashes = true, 
        text = '999 - Jewelery Store Robbery',
        time = 5,
        radius = 0
      }
    })
  elseif alertType == 'suspicous' then
    TriggerServerEvent('cd_dispatch:AddNotification', {
      job_table = {'police', }, 
      coords = data.coords,
      title = '10-67 - Suspicious Activity',
      message = 'Someone has reported a '..data.sex.. ' at '..data.street , 
      flash = 0,
      unique_id = data.unique_id,
      sound = 1,
      blip = {
        sprite = 586, 
        scale = 1.2, 
        colour = 3,
        flashes = true, 
        text = '999 - Suspicious Activity',
        time = 5,
        radius = 0
      }
    })
  elseif alertType == 'explosion' then
    TriggerServerEvent('cd_dispatch:AddNotification', {
      job_table = {'police', }, 
      coords = data.coords,
      title = '10-80 - Explosion',
      message = 'An explosion has been reported at '..data.street, 
      flash = 0,
      unique_id = data.unique_id,
      sound = 1,
      blip = {
        sprite = 586, 
        scale = 1.2, 
        colour = 3,
        flashes = true, 
        text = '999 - Jewelery Store Robbery',
        time = 5,
        radius = 5
      }
    })
  end
end

local function checkSkill(hack)
  local retval = false
  local skill = exports[Config.Skills.system]:GetCurrentSkill(Config.Skills[hack].skill)
  local currXP = skill['Current']
  local reqXP = Config.Skills[hack]['Limits'].xp
  if currXP >= reqXP then
    retval = true
  end
  return retval
end

local function addSkillToPlayer(hack)
  local reward = Config.Skills[hack]['Rewards'].xp
  local multi = Config.Skills[hack]['Rewards'].multi
  local skill = exports[Config.Skills.system]:GetCurrentSkill(Config.Skills[hack].skill)
  local currXP = skill['Current']
  if currXP <= 0 then currXP = 1 end
  local xp = math.floor(reward * multi * (currXP * 0.001))
  if xp < reward then xp = reward end
  exports[Config.Skills.system]:UpdateSkill(Config.Skills[hack].skill, xp)
end

-------------------------------- HANDLERS --------------------------------

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
	QBCore.Functions.TriggerCallback('don-jewellery:server:GetJewelleryState', function(result)
		Config.Vitrines = result.Locations
    Config.Stores = result.Hacks
	end)
  local blip = GetFirstBlipInfoId(617)
  if not DoesBlipExist(blip) then
    createBlips()
  end
end)

AddEventHandler('QBCore:Client:OnPlayerUnload', function()
  for i = 1, #Config.Vitrines do
    if Config.Vitrines[i].isBusy then
      TriggerServerEvent('don-jewellery:server:SetVitrineState', false, i)
    end
  end
  removeBlips()
end)

AddEventHandler('onResourceStart', function(resource)
  if resource ~= GetCurrentResourceName() then return end
  for i = 1, #Config.Vitrines do
    if Config.Vitrines[i].isBusy then
      TriggerServerEvent('don-jewellery:server:SetVitrineState', false, i)
    end
  end
  TriggerServerEvent('don-jewellery:server:StoreHit', 'all', false)
  createBlips()
end)

AddEventHandler('onResourceStop', function(resource)
  if resource ~= GetCurrentResourceName() then return end
  for i = 1, #Config.Vitrines do
    if Config.Vitrines[i].isBusy then
      TriggerServerEvent('don-jewellery:server:SetVitrineState', false, i)
    end
  end
  TriggerServerEvent('don-jewellery:server:StoreHit', 'all', false)
  removeBlips()
end)

AddEventHandler('don-jewellery:client:SmashCase', function(case)
  QBCore.Functions.TriggerCallback('don-jewellery:server:GetCops', function(cops)
    if not checkTime(Config.VangelicoHours.range.open, Config.VangelicoHours.range.close) then
      if not Config.Vitrines[case].isOpened then
        if Config.Skills.enabled then
          if not checkSkill('Vitrine') then
            QBCore.Functions.Notify(Lang:t('error.skill_fail', {value = Config.Skills['Vitrine'].skill}), 'error')
            return
          end
        end
        if cops >= Config.RequiredCops then
          if isStoreHit(case, false) or isStoreHacked() then
            local animDict = 'missheist_jewel'
            local animName = 'smash_case'
            local ped = PlayerPedId()
            local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.6, 0)
            local pedWeapon = GetSelectedPedWeapon(ped)
            if randomNum(1, 100) <= 80 and not isWearingHandshoes() then
              TriggerServerEvent('evidence:server:CreateFingerDrop', plyCoords)
            elseif randomNum(1, 100) <= 5 and isWearingHandshoes() then
              TriggerServerEvent('evidence:server:CreateFingerDrop', plyCoords)
              QBCore.Functions.Notify(Lang:t('error.fingerprints'), 'error')
            end
            smashing = true
            if Config.Skills.enabled then addSkillToPlayer('Vitrine') end
            QBCore.Functions.Progressbar('smash_vitrine', Lang:t('info.smashing_progress'), Config.WhitelistedWeapons[pedWeapon].timeOut, false, true, {
              disableMovement = true,
              disableCarMovement = true,
              disableMouse = false,
              disableCombat = true,
            }, {}, {}, {}, function() -- Done
              TriggerServerEvent('don-jewellery:server:VitrineReward', case)
              TriggerServerEvent('don-jewellery:server:SetTimeout', case)
              if not secondAlarm and not isStoreHacked() then 
                if Config.Dispatch == 'qb' then
                  TriggerServerEvent('police:server:policeAlert', 'Robbery in progress')
                elseif Config.Dispatch == 'ps' then
                  exports['ps-dispatch']:VangelicoRobbery(getCamID(case))
                elseif Config.Dispatch == 'cd' then
                  alertsCD('robbery')
                end
                secondAlarm = true
                firstAlarm = false
              end
              smashing = false
              TaskPlayAnim(ped, animDict, 'exit', 3.0, 3.0, -1, 2, 0, 0, 0, 0)
            end, function() -- Cancel
              TriggerServerEvent('don-jewellery:server:SetVitrineState', 'isBusy', false, case)
              smashing = false
              TaskPlayAnim(ped, animDict, 'exit', 3.0, 3.0, -1, 2, 0, 0, 0, 0)
            end)
            TriggerServerEvent('don-jewellery:server:SetVitrineState', 'isBusy', true, case)

            CreateThread(function()
              while smashing do
                loadAnimDict(animDict)
                TaskPlayAnim(ped, animDict, animName, 8.0, 8.0, -1, 31, 0.0, false, false, false)
                Wait(500)
                TriggerServerEvent('InteractSound_SV:PlayOnSource', 'breaking_vitrine_glass', 0.25)
                loadPtfx('scr_jewelheist')
                StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', plyCoords.x, plyCoords.y, plyCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                Wait(5500)
              end
            end)
          else
            QBCore.Functions.Notify(Lang:t('error.security_active'), 'error')
          end
        else
          QBCore.Functions.Notify(Lang:t('error.minimum_police', {value = Config.RequiredCops}), 'error')
        end
      else
        QBCore.Functions.Notify(Lang:t('error.vitrine_hit'), 'error')
      end
    else
      QBCore.Functions.Notify(Lang:t('error.stores_open'), 'error')
    end
  end)
end)

AddEventHandler('don-jewellery:client:Thermite', function(store)
  local AlertChance = randomNum(1, 100)
  if checkTime(Config.VangelicoHours.alertmorn.start, Config.VangelicoHours.alertmorn.fin) or checkTime(Config.VangelicoHours.alertnight.start, Config.VangelicoHours.alertnight.fin) then
    AlertChance = randomNum(1, 50)
  else
    AlertChance = AlertChance
  end

  if AlertChance <= 10 then
    if Config.Dispatch == 'qb' then
      TriggerServerEvent('police:server:policeAlert', 'Suspicious Activity')
    elseif Config.Dispatch == 'ps' then
      exports['ps-dispatch']:SuspiciousActivity()
    elseif Config.Dispatch == 'cd' then
      alertsCD('suspicious')
    end
    firstAlarm = true
  end

  QBCore.Functions.TriggerCallback('don-jewellery:server:GetCops', function(cops)
    if not checkTime(Config.VangelicoHours.range.open, Config.VangelicoHours.range.close) then
      if Config.Skills.enabled then 
        if not checkSkill('Thermite') then
          QBCore.Functions.Notify(Lang:t('error.skill_fail', {value = Config.Skills['Thermite'].skill}), 'error')
          return
        end
      end
      if cops >= Config.RequiredCops then
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local printChance = randomNum(1, 100)
        local dist = #(coords - Config.Stores[store]['Thermite'].coords)
        if dist <= 1.5 then
          if QBCore.Functions.HasItem(Config.DoorItem) then
            if printChance <= 80 and not isWearingHandshoes() then
              TriggerServerEvent('evidence:server:CreateFingerDrop', coords)
            elseif printChance <= 5 and isWearingHandshoes() then
              TriggerServerEvent('evidence:server:CreateFingerDrop', coords)
              QBCore.Functions.Notify(Lang:t('error.fingerprints'), 'error')
            end
            SetEntityHeading(ped, Config.Stores[store]['Thermite'].h)
            exports['ps-ui']:Thermite(function(success) -- success
              if success then
                TriggerServerEvent('don-jewellery:server:StoreHit', store, true)    
                QBCore.Functions.Notify(Lang:t('success.thermite'), 'success')
                local loc = Config.Stores[store]['Thermite'].anim
                local rot = GetEntityRotation(ped)
                local bagscene = NetworkCreateSynchronisedScene(loc.x, loc.y, loc.z, rot.x, rot.y, rot.z, 2, false, false, 1065353216, 0, 1.3)
                local bag = CreateObject(`hei_p_m_bag_var22_arm_s`, loc.x, loc.y, loc.z,  true,  true, false)
                SetEntityCollision(bag, false, true)
                NetworkAddPedToSynchronisedScene(ped, bagscene, 'anim@heists@ornate_bank@thermal_charge', 'thermal_charge', 1.5, -4.0, 1, 16, 1148846080, 0)
                NetworkAddEntityToSynchronisedScene(bag, bagscene, 'anim@heists@ornate_bank@thermal_charge', 'bag_thermal_charge', 4.0, -8.0, 1)
                NetworkStartSynchronisedScene(bagscene)
                Wait(1500)
                coords = GetEntityCoords(ped)
                local thermal_charge = CreateObject(`hei_prop_heist_thermite`, coords.x, coords.y, coords.z + 0.2,  true,  true, true)
            
                SetEntityCollision(thermal_charge, false, true)
                AttachEntityToEntity(thermal_charge, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
                Wait(4000)
                TriggerServerEvent('don-jewellery:server:RemoveDoorItem')
            
                DetachEntity(thermal_charge, 1, 1)
                FreezeEntityPosition(thermal_charge, true)
                Wait(100)
                DeleteObject(bag)
                ClearPedTasks(ped)
            
                Wait(100)
                if Config.Skills.enabled then addSkillToPlayer('Thermite') end
                loadPtfx('scr_ornate_heist')
                local termcoords = GetEntityCoords(thermal_charge)
                local effect = StartParticleFxLoopedAtCoord('scr_heist_ornate_thermal_burn', termcoords.x, termcoords.y + 1.0, termcoords.z, 0, 0, 0, 0x3F800000, 0, 0, 0, 0)
                Wait(3000)
                StopParticleFxLooped(effect, 0)
                DeleteObject(thermal_charge)
                TriggerEvent('don-jewellery:client:HackSuccess', store)
                if not firstAlarm and AlertChance <= 25 then
                  if Config.Dispatch == 'qb' then
                    TriggerServerEvent('police:server:policeAlert', 'Explosion Reported')
                  elseif Config.Dispatch == 'ps' then
                    exports["ps-dispatch"]:Explosion()
                  elseif Config.Dispatch == 'cd' then
                    alertsCD('explosion')
                  end
                  firstAlarm = true
                end
              else
                QBCore.Functions.Notify(Lang:t('error.fail_therm'), 'error')
              end
            end, Config.ThermiteSettings.time, Config.ThermiteSettings.gridsize, Config.ThermiteSettings.incorrectBlocks)
          else
            QBCore.Functions.Notify(Lang:t('error.wrong_item'), 'error')
          end
        else
          QBCore.Functions.Notify(Lang:t('error.too_far'), 'error')
        end
      else
        QBCore.Functions.Notify(Lang:t('error.minimum_police', {value = Config.RequiredCops}), 'error')
      end
    else
      QBCore.Functions.Notify(Lang:t('error.stores_open'), 'error')
    end
  end)
end)

AddEventHandler('don-jewellery:client:HackSecurity', function()
  QBCore.Functions.TriggerCallback('don-jewellery:server:GetCops', function(cops)
    if not checkTime(Config.VangelicoHours.range.open, Config.VangelicoHours.range.close) then
      if Config.Skills.enabled then
        if not checkSkill('Hack') then
          QBCore.Functions.Notify(Lang:t('error.skill_fail', {value = Config.Skills['Hack'].skill}), 'error')
          return
        end
      end
      if cops >= Config.RequiredCops then
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local dist = #(coords - Config.Stores[1]['Hack'].coords)
        if dist <= 1.5 then
          if QBCore.Functions.HasItem(Config.HackItem) then
            local animDict = 'amb@world_human_seat_wall_tablet@female@base'
            local anim = 'base'
            local hacking = true
            local tab = CreateObject(`prop_cs_tablet`, 0, 0, 0, true, true, true)
            AttachEntityToEntity(tab, ped, GetPedBoneIndex(ped, 57005), 0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true)
            QBCore.Functions.Notify(Lang:t('info.hacking_attempt'), 'primary', 2500)
            CreateThread(function()
              while hacking do
                Wait(0)
                loadAnimDict(animDict)
                if not IsEntityPlayingAnim(ped, animDict, anim, 3) then
                  TaskPlayAnim(ped, animDict, anim, 8.0, -8.0, -1, 50, 0, false, false, false)
                end
              end
            end)
            -- if randomNum(1, 100) <= 80 and not isWearingHandshoes() then
            --     TriggerServerEvent("evidence:server:CreateFingerDrop", targetPosition)
            -- elseif randomNum(1, 100) <= 5 and isWearingHandshoes() then
            --     TriggerServerEvent("evidence:server:CreateFingerDrop", targetPosition)
            -- end
            Wait(2500)
            exports['ps-ui']:VarHack(function(success)
              if success then
                if Config.Skills.enabled then addSkillToPlayer('Hack') end
                hacking = false
                TriggerServerEvent('don-jewellery:server:StoreHit', 'all', true)
                Wait(250)
                StopAnimTask(ped, animDict, anim, 8.0)
                DeleteEntity(tab)
                TriggerEvent('don-jewellery:client:HackSuccess')
              else
                hacking = false
                QBCore.Functions.Notify(Lang:t('error.fail_hack'), 'error')
                StopAnimTask(ped, animDict, anim, 8.0)
                DeleteEntity(tab)
                FreezeEntityPosition(ped, false)
              end
            end, Config.VarHackSettings.blocks, Config.VarHackSettings.time)
          else
            QBCore.Functions.Notify(Lang:t('error.wrong_item'), 'error')
          end
        else
          QBCore.Functions.Notify(Lang:t('error.too_far'), 'error')
        end
      else
        QBCore.Functions.Notify(Lang:t('error.minimum_police', {value = Config.RequiredCops}), 'error')
      end
    else
      QBCore.Functions.Notify(Lang:t('error.stores_open'), 'error')
    end
  end)
end)

AddEventHandler('don-jewellery:client:HackSuccess', function(store)
  if isStoreHit(store, true) or isStoreHacked() then
    if isStoreHit(store, true)  and not isStoreHacked() then
      if not Config.OneStore then
        QBCore.Functions.Notify(Lang:t('success.store_hit_threestore'), 'success')
        if Config.AutoLock then
          TriggerServerEvent('don-jewellery:server:ToggleDoorlocks', store, false, false)
          locked = false
          Wait(Config.Cooldown)
        end
      else
        local warningTimer = 1 * (60 * 2000)
        local warningTime = warningTimer / (60 * 2000)
        local cooldownTime = Config.Cooldown / (60 * 2000)
        QBCore.Functions.Notify(Lang:t('success.store_hit_onestore', {value = math.floor(cooldownTime)}), 'success')
        if Config.AutoLock then TriggerServerEvent('don-jewellery:server:ToggleDoorlocks', store, false, false) end
        locked = false
        Wait(Config.Cooldown - warningTimer)
        QBCore.Functions.Notify(Lang:t('info.one_store_warning', {value = math.floor(warningTime)}), 'primary')
        Wait(warningTimer)
      end
      if Config.AutoLock and not checkTime(Config.VangelicoHours.range.open, Config.VangelicoHours.range.close) then
        TriggerServerEvent('don-jewellery:server:ToggleDoorlocks', store, true, false)
        locked = true
      end
      TriggerServerEvent('don-jewellery:server:StoreHit', store, false)
    else
      if not Config.OneStore then 
        QBCore.Functions.Notify(Lang:t('success.hacked_threestore'), 'success')
        if Config.AutoLock then TriggerServerEvent('don-jewellery:server:ToggleDoorlocks', nil, false, true) end
        locked = false
        Wait(Config.Cooldown)
        if Config.AutoLock and not checkTime(Config.VangelicoHours.range.open, Config.VangelicoHours.range.close) then
          locked = true
          TriggerServerEvent('don-jewellery:server:ToggleDoorlocks', nil, true, true)
        end
        TriggerServerEvent('don-jewellery:server:StoreHit', 'all', false)
      else
        QBCore.Functions.Notify(Lang:t('success.hacked_onestore'), 'success')
      end
    end
    firstAlarm = false
    secondAlarm = false
  end
end)

-------------------------------- EVENTS --------------------------------

RegisterNetEvent('don-jewellery:client:SetVitrineState', function(stateType, state, k)
  Config.Vitrines[k][stateType] = state
  if stateType == 'isBusy' and state == true then
    CreateModelSwap(Config.Vitrines[k].coords, 0.1, Config.Vitrines[k].propStart, Config.Vitrines[k].propEnd, false)
  end

  if stateType == 'isOpened' and state == false then
    RemoveModelSwap(Config.Vitrines[k].coords, 0.1, Config.Vitrines[k].propStart, Config.Vitrines[k].propEnd, false)
  end
end)

RegisterNetEvent('don-jewellery:client:StoreHit', function(storeIndex, isHit)
  if not storeIndex or not isHit then return end
  if storeIndex == 'all' then Config.Stores[1].hacked = isHit end
  for k, _ in pairs(Config.Stores) do
    if storeIndex == 'all' then
      Config.Stores[k].hit = isHit
    else
      if k == storeIndex then
        Config.Stores[storeIndex].hit = isHit
      end
    end
  end
end)

-------------------------------- TARGET --------------------------------

if not Config.OneStore then
  for k, v in pairs(Config.Vitrines) do
    exports['qb-target']:AddBoxZone('jewelstore' .. k, v.coords, 1, 1, {
      name = 'jewelstore' .. k,
      heading = 40,
      minZ = v.coords.z - 1,
      maxZ = v.coords.z + 1,
      debugPoly = false
    }, 
    {
      options = {
        {
          icon = 'fa fa-hand',
          label = Lang:t('general.target_label'),
          action = function()
            if validWeapon() then
              TriggerEvent('don-jewellery:client:SmashCase', k)
            else
              QBCore.Functions.Notify(Lang:t('error.wrong_weapon'), 'error')
            end
          end,
          canInteract = function()
            if v.isOpened or v.isBusy then return false end
            return true
          end,
        }
      },
      distance = 1.5
    })
  end
  for k, v in pairs(Config.Stores) do
    exports['qb-target']:AddBoxZone('jewelthermite' .. k, v['Thermite'].coords, 0.4, 0.8, {
      name = 'jewelthermite' .. k,
      heading = v['Thermite'].h,
      debugPoly = false,
      minZ= v['Thermite'].minZ,
      maxZ= v['Thermite'].maxZ 
    }, 
    {
      options = {
        {
          type = "client",
          icon = 'fas fa-bug',
          label = 'Blow Fuse Box',
          item = 'thermite',
          action = function()
            TriggerEvent('don-jewellery:client:Thermite', k)
          end
        }
      },
      distance = 2.5 -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
    })
  end
else
  for i = 1, 20, 1 do
    exports['qb-target']:AddBoxZone('jewelstore' .. i, Config.Vitrines[i].coords, 1, 1, {
      name = 'jewelstore' .. i,
      heading = 40,
      minZ = Config.Vitrines[i].coords.z - 1,
      maxZ = Config.Vitrines[i].coords.z + 1,
      debugPoly = false
    }, 
    {
      options = {
        {
          icon = 'fa fa-hand',
          label = Lang:t('general.target_label'),
          action = function()
            if GetSelectedPedWeapon(ped) == `WEAPON_UNARMED` then
              QBCore.Functions.Notify(Lang:t('error.unarmed'), 'error')
            else
              if validWeapon() then
                TriggerEvent('don-jewellery:client:SmashCase', i)
              else
                QBCore.Functions.Notify(Lang:t('error.wrong_weapon'), 'error')
              end
            end
          end,
          canInteract = function()
            if Config.Vitrines[i].isOpened or Config.Vitrines[i].isBusy then return false end
            return true
          end,
        }
      },
      distance = 1.5
    })
  end
  exports['qb-target']:AddBoxZone('jewelthermite' .. 1, Config.Stores[1]['Thermite'].coords, 0.4, 0.8, {
    name = 'jewelthermite' .. 1,
    heading = Config.Stores[1]['Thermite'].h,
    debugPoly = false,
    minZ= Config.Stores[1]['Thermite'].minZ, 
    maxZ= Config.Stores[1]['Thermite'].maxZ 
  }, 
  {
    options = {
      {
        icon = 'fas fa-bug',
        label = 'Blow Fuse Box',
        item = Config.DoorItem,
        action = function()
          TriggerEvent('don-jewellery:client:Thermite', 1)
        end
      }
    },
    distance = 2.5 -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
  })
end

exports['qb-target']:AddBoxZone('jewelpc' .. 1, Config.Stores[1]['Hack'].coords, 0.4, 0.6, {
  name = 'jewelpc' .. 1,
  heading = Config.Stores[1]['Hack'].h,
  debugPoly = false,
  minZ= Config.Stores[1]['Hack'].minZ,
  maxZ= Config.Stores[1]['Hack'].maxZ
}, 
{
  options = {
    {
    icon = 'fas fa-bug',
    label = 'Hack Security System',
    item = Config.HackItem,
    action = function()
        TriggerEvent('don-jewellery:client:HackSecurity')
      end
    }
  },
  distance = 2.5 -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
})

-------------------------------- THREADS --------------------------------

CreateThread(function()
  local loopDone = false
  while Config.AutoLock do
    Wait(1000)
    if LocalPlayer.state.isLoggedIn then
      if not checkTime(Config.VangelicoHours.range.open, Config.VangelicoHours.range.close) then
        if (not isStoreHit(nil, false) and not isStoreHacked()) and not locked then
          Wait(1000)
          TriggerServerEvent('don-jewellery:server:ToggleDoorlocks', nil, true, true)
          locked = true
          loopDone = false
        end
      else
        if not loopDone then
          Wait(1000)
          TriggerServerEvent('don-jewellery:server:ToggleDoorlocks', nil, false, true)
          loopDone = true
        end
      end
    end
  end
end)