local QBCore = exports['qb-core']:GetCoreObject()
local firstAlarm = false
local secondAlarm = false
local smashing = false

local cityHit = false 
local grapeHit = false
local palHit = false
local storeHit = false
local doorHacked = false
local doorLocked = false

-- Functions

local function loadParticle()
	if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
		RequestNamedPtfxAsset("scr_jewelheist")
    end
    while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
		Wait(0)
    end
    SetPtfxAssetNextCall("scr_jewelheist")
end

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(3)
    end
end

local function isStoreHit()
    if cityHit or grapeHit or palHit then
        return true
    end
    return false 
end

local function isStoreHacked()
    if doorHacked then
        return true
    end
    return false 
end

local function lockDoors(k) -- Locks Vangelico's front doors
    TriggerEvent('qb-doorlock:client:setState', source, Config.Doors[k].main, true, src, false, false)
    TriggerServerEvent('qb-doorlock:server:updateState', Config.Doors[k].main, true, false, false, true)
end

local function unlockDoors(k) -- Unocks Vangelico's front doors
    TriggerEvent('qb-doorlock:client:setState', source, Config.Doors[k].main, false, src, false, false)
    TriggerServerEvent('qb-doorlock:server:updateState', Config.Doors[k].main, false, false, false, true)
end

local function lockAll() -- Locks all Vangelico's doors
    for k, v in pairs(Config.Doors) do
        TriggerEvent('qb-doorlock:client:setState', source, v.main, true, src, false, false)
        TriggerEvent('qb-doorlock:client:setState', source, v.sec, true, src, false, false)
        if doorHacked then 
            TriggerServerEvent('qb-doorlock:server:updateState', v.main, true, false, false, true)
            TriggerServerEvent('qb-doorlock:server:updateState', v.sec, true, false, false, true)
        end
    end
    doorLocked = true
end

local function unlockAll() -- Unlocks all Vangelico's doors
    for k, v in pairs(Config.Doors) do
        TriggerEvent('qb-doorlock:client:setState', source, v.main, false, src, false, false)
        TriggerEvent('qb-doorlock:client:setState', source, v.sec, false, src, false, false)
        if doorHacked then
            TriggerServerEvent('qb-doorlock:server:updateState', v.main, false, false, false, true) 
            TriggerServerEvent('qb-doorlock:server:updateState', v.sec, false, false, false, true)
        end
    end
    doorLocked = false
end

local function CheckRobberyTime()
    local start = Config.VangelicoHours.range.open
    local ends = Config.VangelicoHours.range.close-1
    local hour = GetClockHours()
    local minute = GetClockMinutes()
    local shopHour = false
    if start > ends then
        if hour == start then
            shopHour = true
        elseif hour == 0 then
            shopHour = true
        elseif hour <= ends then
            shopHour = true
        else
            shopHour = false
        end
    else
        if start <= hour and ends >= hour then
            shopHour = true
        else
            shopHour = false
        end
    end
    return shopHour
end

local function CheckAlertTimeNight()
    local start = Config.VangelicoHours.alertnight.start
    local ends = Config.VangelicoHours.alertnight.fin-1
    local hour = GetClockHours()
    local minute = GetClockMinutes()
    local alertHour = false
    if start > ends then
        if hour == start then
            alertHour = true
        elseif hour == 0 then
            alertHour = true
        elseif hour <= ends then
            alertHour = true
        else
            alertHour = false
        end
    else
        if start <= hour and ends >= hour then
            alertHour = true
        else
            alertHour = false
        end
    end
    return alertHour
end

local function CheckAlertTimeMorn()
    local start = Config.VangelicoHours.alertmorn.start
    local ends = Config.VangelicoHours.alertmorn.fin-1
    local hour = GetClockHours()
    local minute = GetClockMinutes()
    local alertHour = false
    if start > ends then
        if hour == start then
            alertHour = true
        elseif hour == 0 then
            alertHour = true
        elseif hour <= ends then
            alertHour = true
        else
            alertHour = false
        end
    else
        if start <= hour and ends >= hour then
            alertHour = true
        else
            alertHour = false
        end
    end
    return alertHour
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

local function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
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
    elseif k == 7 or k >= 18 and k <=20 then
        camID = 32
    elseif k >= 12 and k <= 17 then
        camID = 33
    elseif k >= 8 and k <= 11 then
        camID = 34
    elseif k >=21 and k <= 26 then
        camID = 35
    elseif k >= 27 and k <= 32 then
        camID = 36
    end
    return camID
end

local function smashVitrine(k)
    QBCore.Functions.TriggerCallback('don-jewellery:server:getCops', function(cops)
        if not CheckRobberyTime() then
            if not Config.Locations[k]["isOpened"] then
                if cops >= Config.RequiredCops then
                    if isStoreHit() or isStoreHacked() then
                        local animDict = "missheist_jewel"
                        local animName = "smash_case"
                        local ped = PlayerPedId()
                        local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.6, 0)
                        local pedWeapon = GetSelectedPedWeapon(ped)
                        if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
                            TriggerServerEvent("evidence:server:CreateFingerDrop", plyCoords)
                        elseif math.random(1, 100) <= 5 and IsWearingHandshoes() then
                            TriggerServerEvent("evidence:server:CreateFingerDrop", plyCoords)
                            QBCore.Functions.Notify(Lang:t('error.fingerprints'), "error")
                        end
                        smashing = true
                        QBCore.Functions.Progressbar("smash_vitrine", Lang:t('info.progressbar'), Config.WhitelistedWeapons[pedWeapon]["timeOut"], false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {}, {}, {}, function() -- Done
                            TriggerServerEvent('don-jewellery:server:vitrineReward', k)
                            TriggerServerEvent('don-jewellery:server:setTimeout')
                                if not secondAlarm and not isStoreHacked() then 
                                    if not Config.PSDispatch then
                                        TriggerServerEvent('police:server:policeAlert', 'Robbery in progress')
                                    else
                                        exports['ps-dispatch']:VangelicoRobbery(getCamID(k))
                                    end
                                    secondAlarm = true
                                    firstAlarm = false
                                end
                            smashing = false
                            TaskPlayAnim(ped, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
                        end, function() -- Cancel
                            TriggerServerEvent('don-jewellery:server:setVitrineState', "isBusy", false, k)
                            smashing = false
                            TaskPlayAnim(ped, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
                        end)
                        TriggerServerEvent('don-jewellery:server:setVitrineState', "isBusy", true, k)

                        CreateThread(function()
                            while smashing do
                                loadAnimDict(animDict)
                                TaskPlayAnim(ped, animDict, animName, 3.0, 3.0, -1, 2, 0, 0, 0, 0 )
                                Wait(500)
                                TriggerServerEvent("InteractSound_SV:PlayOnSource", "breaking_vitrine_glass", 0.25)
                                loadParticle()
                                StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", plyCoords.x, plyCoords.y, plyCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                                Wait(5500)
                            end
                        end)
                    else
                        QBCore.Functions.Notify('Looks like the stores security is still active..', 'error')
                    end
                else
                    QBCore.Functions.Notify(Lang:t('error.minimum_police', {value = Config.RequiredCops}), 'error')
                end
            else
                QBCore.Functions.Notify('Looks like you\'ve already emptied this case..', 'error')
            end
        else
            QBCore.Functions.Notify(Lang:t('error.stores_open'), 'error')
        end
    end)
end

local function thermiteHack(k)
    local AlertChance = math.random(1, 100)
    if CheckAlertTimeMorn() or CheckAlertTimeNight() then
        AlertChance = math.random(1, 50)
    else
        AlertChance = AlertChance
    end

    if AlertChance <= 10 then
        if not Config.PSDispatch then
            TriggerServerEvent('police:server:policeAlert', 'Suspicious Activity')
        else
            exports['ps-dispatch']:SuspiciousActivity()
        end
        firstAlarm = true
    end

    QBCore.Functions.TriggerCallback('don-jewellery:server:getCops', function(cops)
        if not CheckRobberyTime() then
            if cops >= Config.RequiredCops then
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                local printChance = math.random(1, 100)
                local Dist = #(coords - Config.Thermite[k].coords)
                if Dist <= 1.5 then
                    if QBCore.Functions.HasItem("thermite") then
                        if printChance <= 80 and not IsWearingHandshoes() then
                            TriggerServerEvent("evidence:server:CreateFingerDrop", coords)
                        elseif printChance <= 5 and IsWearingHandshoes() then
                            TriggerServerEvent("evidence:server:CreateFingerDrop", coords)
                            QBCore.Functions.Notify(Lang:t('error.fingerprints'), "error")
                        end
                        SetEntityHeading(ped, Config.Thermite[k].h)
                        exports['ps-ui']:Thermite(function(success) -- success
                            if success then
                                TriggerServerEvent('don-jewellery:server:StoreHit', k, true)    
                                QBCore.Functions.Notify("Placing Charge...", 'success', 4500)
                                local loc = Config.Thermite[k].anim
                                local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(ped)))
                                local bagscene = NetworkCreateSynchronisedScene(loc.x, loc.y, loc.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
                                local bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), loc.x, loc.y, loc.z,  true,  true, false)
                                SetEntityCollision(bag, false, true)
                                NetworkAddPedToSynchronisedScene(ped, bagscene, 'anim@heists@ornate_bank@thermal_charge', 'thermal_charge', 1.5, -4.0, 1, 16, 1148846080, 0)
                                NetworkAddEntityToSynchronisedScene(bag, bagscene, 'anim@heists@ornate_bank@thermal_charge', 'bag_thermal_charge', 4.0, -8.0, 1)
                                NetworkStartSynchronisedScene(bagscene)
                                Wait(1500)
                                local x, y, z = table.unpack(GetEntityCoords(ped))
                                local thermal_charge = CreateObject(GetHashKey('hei_prop_heist_thermite'), x, y, z + 0.2,  true,  true, true)
                            
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
                                RequestNamedPtfxAsset('scr_ornate_heist')
                                while not HasNamedPtfxAssetLoaded('scr_ornate_heist') do
                                    Wait(1)
                                end
                                
                                local termcoords = GetEntityCoords(thermal_charge)
                                ptfx = vector3(termcoords.x, termcoords.y + 1.0, termcoords.z)

                                SetPtfxAssetNextCall('scr_ornate_heist')
                                local effect = StartParticleFxLoopedAtCoord('scr_heist_ornate_thermal_burn', ptfx, 0, 0, 0, 0x3F800000, 0, 0, 0, 0)
                                Wait(3000)
                                StopParticleFxLooped(effect, 0)
                                DeleteObject(thermal_charge)
                                TriggerEvent('don-jewellery:client:HackSuccess', k)
                                if not firstAlarm and AlertChance <= 25 then
                                    if not Config.PSDispatch then
                                        TriggerServerEvent('police:server:policeAlert', 'Explosion Reported')
                                    else
                                        exports["ps-dispatch"]:Explosion()
                                    end
                                    firstAlarm = true
                                end
                            else
                                QBCore.Functions.Notify("You Failure!", 'error', 4500)
                            end
                        end, Config.ThermiteSettings.time, Config.ThermiteSettings.gridsize, Config.ThermiteSettings.incorrectBlocks)
                    else
                        QBCore.Functions.Notify("You don't have the correct items!", 'error')
                    end
                else
                    QBCore.Functions.Notify("You just can't quite reach..", 'error')
                end
            else
                QBCore.Functions.Notify(Lang:t('error.minimum_police', {value = Config.RequiredCops}), 'error')
            end
        else
            QBCore.Functions.Notify(Lang:t('error.stores_open'), 'error')
        end
    end)
end

local function startHack()
    CreateThread(function()
        local ped = PlayerPedId()
        RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
        while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do
            Citizen.Wait(0)
        end
        tab = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
        AttachEntityToEntity(tab, ped, GetPedBoneIndex(ped, 57005), 0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true)
        TaskPlayAnim(ped, "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
    end)
end

local function stopHack()
    local ped = PlayerPedId()
    StopAnimTask(ped, "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
    DeleteEntity(tab)
end

local function securityHack()
    QBCore.Functions.TriggerCallback('don-jewellery:server:getCops', function(cops)
        if not CheckRobberyTime() then
            if cops >= Config.RequiredCops then
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                for k, v in pairs(Config.Hacks) do
                    local Dist = #(coords - v.coords)
                    if Dist <= 1.5 then
                        if QBCore.Functions.HasItem("phone") then
                            startHack()
                            QBCore.Functions.Notify("connecting to security system...", 'success', 2500)
                            --[[if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
                                TriggerServerEvent("evidence:server:CreateFingerDrop", targetPosition)
                            elseif math.random(1, 100) <= 5 and IsWearingHandshoes() then
                                TriggerServerEvent("evidence:server:CreateFingerDrop", targetPosition)
                            end]]
                            Wait(2500)
                            exports['ps-ui']:VarHack(function(success)
                                if success then
                                    TriggerServerEvent('don-jewellery:server:StoreHit', 'all', true)
                                    Wait(250)
                                    stopHack()
                                    TriggerEvent('don-jewellery:client:HackSuccess')
                                else
                                    QBCore.Functions.Notify("I'll have to try that again..", 'error', 3500)
                                    stopHack()
                                    FreezeEntityPosition(ped, false)
                                    doorHacked = false
                                end
                            end, Config.VarHackSettings.blocks, Config.VarHackSettings.time)
                        else
                            QBCore.Functions.Notify("You don't have the correct items!", 'error')
                        end
                    else
                        QBCore.Functions.Notify("You just can't quite reach..", 'error')
                    end
                end
            else
                QBCore.Functions.Notify(Lang:t('error.minimum_police', {value = Config.RequiredCops}), 'error')
            end
        else
            QBCore.Functions.Notify(Lang:t('error.stores_open'), 'error')
        end
    end)
end

-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	QBCore.Functions.TriggerCallback('don-jewellery:server:getVitrineState', function(result)
		Config.Locations = result
	end)
end)

RegisterNetEvent('don-jewellery:client:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
    if stateType == 'isBusy' and state == true then
        CreateModelSwap(Config.Locations[k]["coords"].x, Config.Locations[k]["coords"].y, Config.Locations[k]["coords"].z, 0.1, Config.Locations[k]['PropStart'], Config.Locations[k]['PropEnd'], false)
    end

    if stateType == 'isOpened' and state == false then
        RemoveModelSwap(Config.Locations[k]["coords"].x, Config.Locations[k]["coords"].y, Config.Locations[k]["coords"].z, 0.1, Config.Locations[k]['PropStart'], Config.Locations[k]['PropEnd'], false)
    end
end)

RegisterNetEvent('don-jewellery:client:StoreHit', function(k, bool)
    if k then
        if k == 1 then
            cityHit = bool
        elseif k == 2 then
            grapeHit = bool
        elseif k == 3 then
            palHit = bool
        elseif k == 'all' then
            doorHacked = bool
            cityHit = bool
            grapeHit = bool
            palHit = bool
        end
    end
end)

RegisterNetEvent('don-jewellery:client:HackSuccess', function(k)
    if isStoreHit() or isStoreHacked() then
        if isStoreHit()  and not isStoreHacked() then
            if not Config.OneStore then
                QBCore.Functions.Notify("Fuses blown! Should be opening soon..", 'success')
                unlockDoors(k)
                Wait(Config.Cooldown)
            else
                local warningTimer = 1 * (60 * 2000)
                local warningTime = warningTimer / (60 * 2000)
                local cooldownTime = Config.Cooldown / (60 * 2000)
                QBCore.Functions.Notify("Fuses blown! The doors should be open for".. cooldownTime .. "minutes..", 'success')
                unlockDoors(k)
                Wait(Config.Cooldown - warningTimer)
                QBCore.Functions.Notify("Hurry Up! The doors will be auto locking in".. warningTime .. "minute(s)..", 'error')
                Wait(warningTimer)
            end
            if not CheckRobberyTime() then
                lockDoors(k)
            end
            TriggerServerEvent('don-jewellery:server:StoreHit', k, false)
        else
            if not Config.OneStore then 
                QBCore.Functions.Notify("Hack successful: All doors unlocked..", 'success')
                unlockAll()
                Wait(Config.Cooldown)
                if not CheckRobberyTime() then
                    lockAll()
                end
                TriggerServerEvent('don-jewellery:server:StoreHit', 'all', false)
            else
                QBCore.Functions.Notify("Hack successful: Security system disabled..", 'success')
            end
        end
        firstAlarm = false
        secondAlarm = false
    end
end)

-- Threads

CreateThread(function()
    if not Config.OneStore then
        for k, v in pairs(Config.JewelleryLocation) do
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
        local Dealer = AddBlipForCoord(Config.JewelleryLocation[1].coords.x, Config.JewelleryLocation[1].coords.y, Config.JewelleryLocation[1].coords.z)
        SetBlipSprite (Dealer, 617)
        SetBlipDisplay(Dealer, 4)
        SetBlipScale  (Dealer, 0.7)
        SetBlipAsShortRange(Dealer, true)
        SetBlipColour(Dealer, 3)
        AddTextEntry(Config.JewelleryLocation[1].label, Config.JewelleryLocation[1].label)
        BeginTextCommandSetBlipName(Config.JewelleryLocation[1].label)
        EndTextCommandSetBlipName(Dealer)
    end
end)

CreateThread(function()
    local loopDone = false
    while true do
        Wait(1000)
        if not CheckRobberyTime() then
            if not isStoreHit() and not doorHacked and not doorLocked then
                Wait(1000)
                lockAll()
                loopDone = false
            end
        else
            if not loopDone then
                Wait(1000)
                unlockAll()
                loopDone = true
            end
        end
    end
end)

CreateThread(function()
    if not Config.OneStore then
        for k, v in pairs(Config.Locations) do
            exports["qb-target"]:AddBoxZone("jewelstore" .. k, v.coords, 1, 1, {
                name = "jewelstore" .. k,
                heading = 40,
                minZ = v.coords.z - 1,
                maxZ = v.coords.z + 1,
                debugPoly = false
            }, {
                options = {
                    {
                        type = "client",
                        icon = "fa fa-hand",
                        label = Lang:t('general.target_label'),
                        action = function()
                            if validWeapon() then
                                smashVitrine(k)
                            else
                                QBCore.Functions.Notify(Lang:t('error.wrong_weapon'), 'error')
                            end
                        end,
                        canInteract = function()
                            if v["isOpened"] or v["isBusy"] then
                                return false
                            end
                            return true
                        end,
                    }
                },
                distance = 1.5
            })
        end
    else
        for i = 1, 20, 1 do
            exports["qb-target"]:AddBoxZone("jewelstore" .. i, Config.Locations[i].coords, 1, 1, {
                name = "jewelstore" .. i,
                heading = 40,
                minZ = Config.Locations[i].coords.z - 1,
                maxZ = Config.Locations[i].coords.z + 1,
                debugPoly = false
            }, {
                options = {
                    {
                        type = "client",
                        icon = "fa fa-hand",
                        label = Lang:t('general.target_label'),
                        action = function()
                            if validWeapon() then
                                smashVitrine(i)
                            else
                                QBCore.Functions.Notify(Lang:t('error.wrong_weapon'), 'error')
                            end
                        end,
                        canInteract = function()
                            if Config.Locations[i]["isOpened"] or Config.Locations[i]["isBusy"] then
                                return false
                            end
                            return true
                        end,
                    }
                },
                distance = 1.5
            })
        end
    end
end)

CreateThread(function()
    if not Config.OneStore then
        for k, v in pairs(Config.Thermite) do
            exports['qb-target']:AddBoxZone("jewelthermite" .. k, v.coords, 0.4, 0.8, {
            name = "jewelthermite" .. k,
            heading = v.h, -- 300.0
            debugPoly = false,
            minZ= v.minZ, -- 50.12
            maxZ= v.maxZ, -- 51.32
            }, {
                options = {
                    {
                    type = "client",
                    icon = 'fas fa-bug',
                    label = 'Blow Fuse Box',
                    item = 'thermite',
                    action = function()
                        thermiteHack(k)
                        end
                    }
                },
                distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
            })
        end
    else
        exports['qb-target']:AddBoxZone("jewelthermite" .. 1, Config.Thermite[1].coords, 0.4, 0.8, {
        name = "jewelthermite" .. 1,
        heading = Config.Thermite[1].h,
        debugPoly = false,
        minZ= Config.Thermite[1].minZ, 
        maxZ= Config.Thermite[1].maxZ, 
        }, {
            options = {
                {
                type = "client",
                icon = 'fas fa-bug',
                label = 'Blow Fuse Box',
                item = 'thermite',
                action = function()
                    thermiteHack(1)
                    end
                }
            },
            distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
        })
    end
end)

CreateThread(function()
    for k, v in pairs(Config.Hacks) do
        exports['qb-target']:AddBoxZone("jewelpc" .. k, v.coords, 0.4, 0.6, {
        name = "jewelpc" .. k,
        heading = v.h, -- 37.0
        debugPoly = false,
        minZ= v.minZ, -- 37.56
        maxZ= v.maxZ, -- 38.56
        }, {
            options = {
                {
                type = "client",
                icon = 'fas fa-bug',
                label = 'Hack Security System',
                item = 'phone',
                action = function()
                    securityHack()
                    end
                }
            },
            distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
        })
    end
end)
