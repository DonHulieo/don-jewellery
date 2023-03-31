# don-jewellery

Jewellery Robbery for QBCore with 1 or 3 stores, Thermite, VarHack and auto-lock/unlock doors!

## Credits

- [Holiday95](https://github.com/Holidayy95/qb-jewelery) For their fork of qb-jewellery which this is based on, and giving me the idea.
- [QBCore Framework](https://github.com/qbcore-framework) For the orginal qb-jewellery and for inspiring me to code.
- [MrNewb](https://github.com/MrNewb) For showing me how to get the cases to break, absolute legend!

## Dependencies

- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-target](https://github.com/qbcore-framework/qb-target)
- [ps-ui](https://github.com/Project-Sloth/ps-ui)

### *Optional Dependancies*

- [qb-policejob](https://github.com/qbcore-framework/qb-policejob)
- [cd_dispatch](https://forum.cfx.re/t/paid-codesign-police-dispatch/2007097)
- [ps-dispatch](https://github.com/Project-Sloth/ps-dispatch)
- [qb-doorlock](https://github.com/qbcore-framework/qb-doorlock)
- [ox_doorlock](https://github.com/overextended/ox_doorlock)
- [cd_doorlock](https://forum.cfx.re/t/paid-codesign-door-lock/5005862)
- [mz-skills](https://github.com/MrZainRP/mz-skills)

## New Features

- (Not really a "new" feature but) Optimised script, running at 0~0.1ms, only hitting 0.1ms when it locks or unlocks a door after a hack.
- 2 New stores to rob // Grapeseed & Paleto
- Config option for just the base GTA Vangelico's Jewellers or all 3.
- Config option for base qb police alerts or ps-dispatch.
- Doors now lock depending of the time of day, and store is "unthievable" during opening hours.
- Police alerts for thermite have a higher chance when closer to business close or open.
- Police alerts for smashing the cases can be disabled by hacking the main Vangelico's PC.
- Cases will actually smash after you hit them, and reset after cooldown.
- Thermite the stores fusebox to open the front door at night.
- Hack into Vinewood Vangelico's PC to unlock all Vangelico's for 5 minutes (or whatever you set the cooldown to).

## Previews

- [Don Jewellery](https://youtu.be/t-MO9yvzlx4)
- [Cases](https://streamable.com/5xcg40)
- [Dispatch Pt 1](https://streamable.com/3lspsx)
- [Dispatch Pt 2](https://streamable.com/c9zs9z)

## Translations

- Please open an issue for translations, I'll add them in a following update.

## Store MLO's

All store locations are for GigZ Jewelers' except for the base GTA one. It's a free map, link below:

- [GigZ Jewel Store](https://forum.cfx.re/t/mlo-jewel-store-by-gigz/4857261)
- **MAKE SURE TO INSTALL THE HEIST VERSION**
- If you're using these MLO's, place interiorproxies.meta in the gigz_jewel_free_heist folder and edit it's fxmanifest to the following:

```lua
files {"interiorproxies.meta"}
    
data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxies.meta'
```

- You'll also need to add the following code to qb-policejob/config.lua in Config.SecurityCameras after line 100 or after index 34 (Vangelico's Jewelers CAM#4);

```lua
[35] = {label = "Vangelico's Grapeseed CAM#1", coords = vector3(1645.27, 4886.01, 44.7), r = {x = -35.0, y = 0.0, z = -141.82}, canRotate = true, isOnline = true},
[36] = {label = "Vangelico's Paleto CAM#1", coords = vector3(-374.46, 6045.52, 34.05), r = {x = -35.0, y = 0.0, z = -105.09}, canRotate = true, isOnline = true},
```

- **It's important these cameras keep the same index as above and if you alter it, you should know what your doing.**

### If you're using the config option for one store, and don't plan to use all three

- Don't install the store MLO's or the gigz-jewel-fix to your server.
- Don't add the door locks for Grapeseed or Paleto to the qb-doorlocks configs file.
- Don't add the new Cam ID's to qb-policejob.
- Set Config.OneStore = true.

## Setup Logs

Head over to qb-smallresources/server/logs.lua and add this underneath your last log

```lua
['donjewellery'] = '',
```

Once you've added that go over to your logs server and create a channel, create a webhook and then place it inbetween the ''.
If you do not know how to create a webhook follow this guide [Creating Webhooks](https://www.youtube.com/watch?v=fKksxz2Gdnc).

## Important Config

### 1. Intial Setup

#### 1.1. Store Times

```lua
Config.VangelicoHours = { -- Store Hours
    range = {
        open = 6, -- When the doors unlock
        close = 18 -- When they lock for the night
    },
    alertnight = {
        start = 18, -- The start of higher chance alerts in the evening
        fin = 20 -- The end of higher chance alerts in the evening
    },
    alertmorn = {
        start = 4, -- The start of higher chance alerts in the morning
        fin = 6 -- The end of higher chance alerts in the morning
    }
}
```

- The range is the time the store is open, and the alert times are the times the police will have a higher chance of getting an alert.
- By setting open and close to 0, the store will always be locked and robbable.

#### 1.2. Variables

```lua
Config.OneStore = false -- Set to true if using just the main Vangelico's Jewellers
Config.Cooldown = 5 * (60 * 2000) -- where x is minutes ie. x * (60 * 2000) \\ For door auto lock function
Config.Timeout = 5 * (60 * 2000) -- where x is minutes ie. x * (60 * 2000) \\ For case smashing cooldown
Config.AutoLock = true -- Set to false if you don't want the doors to auto lock/lock at all
Config.RequiredCops = 3
Config.Dispatch = 'ps' --[[ 'ps' for ps-dispatch, 'qb' for base qb-policejob alerts, 'cd' for cd_dispatch ]]--
```

- The cooldown is the time (in minutes) the doors will auto lock after a hack.
- The timeout is the time (in minutes) the cases will reset after smashing.
- If `Config.AutoLock` is set to false, the doors will always be unlocked.
- The required cops is the amount of cops online required for the store to be "thievable".
- Set `Config.Dispatch` to; 'ps' for ps-dispatch, 'qb' for base qb-policejob alerts, 'cd' for cd_dispatch.

#### 1.3. Door Locks

```lua

Config.DoorLock = 'qb' --[[ Doorlock System ]]--

Config.Stores = {
  [1] = { -- City Vangelico's
    label = 'Vangelico\'s Jewellers',
    coords = vector3(-630.5, -237.13, 38.08),
    ['Doors'] = {
      main = 'jewellery-citymain',
      sec = 'jewellery-citysec'
    },
    ...
  },
  [2] = { -- Grapeseed Vangelico's
    label = 'Vangelico\'s Jewellers',
    coords = vector3(1649.78, 4882.32, 42.16),
    ['Doors'] = {
      main = 'jewellery-grapemain',
      sec = 'jewellery-grapesec'
    },
    ...
  },
  [3] = { -- Paleto Vangelico's
    label = 'Vangelico\'s Jewellers',
    coords = vector3(-378.45, 6047.68, 32.69),
    ['Doors'] = {
      main = 'jewellery-palmain',
      sec = 'jewellery-palsec'
    },
    ...
  }
}
```

- Set to `qb` for qb-doorlock  
- // Create a file named `jewellery_stores` in qb-doorlock/config/ and copy the Door Config from the README into it.

- Set to `ox` for ox_doorlock
- // Uncomment '@ox_lib/init.lua' from the fxmanifest.lua, create a file named `jewellery_stores` in ox_doorlock/config/ and copy the Door Config from the README into it.

- Set to `cd` for cd_doorlock
- // Create a Group named `Jewellery Stores` through the in-game menu and add the copy the Door Config from the README into it.
- Ensure the names of the doors correspond to the names of the doors below.

#### 1.5. Hacks

```lua
Config.DoorItem = 'thermite' -- Item to remove\check for when placing a charge
Config.ThermiteSettings = {
  time = 60, -- time the hack displays for
  gridsize = 5, -- (5, 6, 7, 8, 9, 10) size of grid by square units, ie. gridsize = 5 is a 5 * 5 (25) square grid
  incorrectBlocks = 10 -- incorrectBlocks = number of incorrect blocks after which the game will fail
}

Config.HackItem = 'phone' -- Item to remove\check for when hacking
Config.VarHackSettings = {
  blocks = 2, -- time the hack displays for
  time = 20 -- time the hack displays for
}
```

- The door item is the item you want to remove from the player when placing a charge.
- The thermite settings are the settings for the thermite hack.
- The hack item is the item you want to *check* for when hacking.
- The var hack settings are the settings for the variable hack.

#### 1.6. Skills

```lua
Config.Skills = {
  enabled = false, -- Enable Skills
  system = 'mz-skills', 
  ['Thermite'] = {
    skill = 'Heist Reputation', -- Skill to Use
    ['Limits'] = {
      xp = 800 -- XP Required to do the Task
    },
    ['Rewards'] = {
      xp = 10, -- XP to give on success
      multi = 1.5 -- Multiplier Based on Players Level
    }
  },
  ...
}
```

- Set `Config.Skills.enabled` to true to enable skills.
- Set `Config.Skills.system` to the name of the skills system you are using.
- Set `Config.Skills.[Task].skill` to the name of the skill you want to use.
- Set `Config.Skills.[Task].Limits.xp` to the amount of xp required to do the task.
- Set `Config.Skills.[Task].Rewards.xp` to the amount of xp you want to give on success.
- Set `Config.Skills.[Task].Rewards.multi` to the multiplier based on the players level/ current xp.

### 2. Door Configs

- Make a copy of the door config below and place it inside `qb-doorlocks/configs/` in it's own .lua file.

- **If using ox_doorlock, the file must be named `jewellery_stores` and can be placed in the convert folder.**

```lua
Config.DoorList['jewellery-citymain'] = {
    doorType = 'double',
    locked = true,
    cantUnlock = true,
    doorLabel = 'main',
    distance = 2,
    doors = {
        {objName = 9467943, objYaw = 306.00003051758, objCoords = vec3(-630.426514, -238.437546, 38.206532)},
        {objName = 1425919976, objYaw = 306.00003051758, objCoords = vec3(-631.955383, -236.333267, 38.206532)}
    },
    doorRate = 1.0,
}

Config.DoorList['jewellery-citysec'] = {
    objYaw = 36.000022888184,
    doorRate = 1.0,
    locked = true,
    fixText = false,
    pickable = true,
    authorizedJobs = { ['police'] = 0 },
    needsAllItems = false,
    objCoords = vec3(-629.133850, -230.151703, 38.206585),
    distance = 1.5,
    doorType = 'door',
    objName = 1335309163,
}

Config.DoorList['jewellery-grapemain'] = {
    doorType = 'double',
    locked = true,
    cantUnlock = true,
    doorLabel = 'main',
    distance = 2,
    doors = {
        {objName = 9467943, objYaw = 98.17839050293, objCoords = vec3(1653.285522, 4884.148438, 42.309845)},
        {objName = 1425919976, objYaw = 98.17839050293, objCoords = vec3(1653.655518, 4881.573730, 42.309845)}
    },
    doorRate = 1.0,
}

Config.DoorList['jewellery-grapesec'] = {
    pickable = true,
    objCoords = vec3(1648.274902, 4877.423340, 42.309898),
    objName = 1335309163,
    doorRate = 1.0,
    distance = 1,
    authorizedJobs = { ['police'] = 0 },
    doorType = 'door',
    objYaw = 188.17839050293,
    fixText = false,
    doorLabel = 'sec',
    locked = true,
}

Config.DoorList['jewellery-palmain'] = {
    doorType = 'double',
    locked = true,
    cantUnlock = true,
    doorLabel = 'main',
    distance = 2,
    doors = {
        {objName = 1425919976, objYaw = 314.90930175781, objCoords = vec3(-383.837921, 6044.059082, 31.658920)},
        {objName = 9467943, objYaw = 314.90930175781, objCoords = vec3(-382.001617, 6042.216797, 31.658920)}
    },
    doorRate = 1.0,
}

Config.DoorList['jewellery-palsec'] = {
    doorType = 'door',
    locked = true,
    doorRate = 1.0,
    pickable = true,
    distance = 1.5,
    objYaw = 44.909275054932,
    fixText = false,
    authorizedJobs = { ['police'] = 0 },
    objCoords = vec3(-382.007721, 6050.603027, 31.658974),
    objName = 1335309163,
}
```

## OX Doorlock 

- If using ox_doorlock, and the door configs above cause errors in this heist, set `Config.DoorLock.Extraname` to the main name of the door in your database.

- Highlighted below is an example of what name in the database you should set `Config.DoorLock.Extraname` to.

<div style="display: flex; flex-direction: row; flex-wrap: wrap; justify-content: space-between; align-items: center; align-content: center;">
    <div style="display: flex; flex-direction: column; align-items: center; margin: 10px;">
        <img src="https://cdn.discordapp.com/attachments/1024287310424047716/1085926698815590461/Jewellery_Stores_for_Readme.PNG.jpg" style="width: 200px; height: 200px; object-fit: cover; border-radius: 10px;">
        <p style="margin: 0; font-size: 20px; font-weight: bold;">OX Door Configs in Database</p>
    </div>
</div>

## CD Doorlock Images

How your doorlocks should look on [cd_doorlock](https://forum.cfx.re/t/paid-codesign-door-lock/5005862) after implementing them!

<div style="display: flex; flex-direction: row; flex-wrap: wrap; justify-content: space-between; align-items: center; align-content: center;">
    <div style="display: flex; flex-direction: column; align-items: center; margin: 10px;">
        <img src="https://cdn.discordapp.com/attachments/898673216116109324/1084338161628495923/image.png" style="width: 200px; height: 200px; object-fit: cover; border-radius: 10px;">
        <p style="margin: 0; font-size: 20px; font-weight: bold;">City Main Door</p>
    </div>
    <div style="display: flex; flex-direction: column; align-items: center; margin: 10px;">
        <img src="https://cdn.discordapp.com/attachments/898673216116109324/1084338217219797052/image.png" style="width: 200px; height: 200px; object-fit: cover; border-radius: 10px;">
        <p style="margin: 0; font-size: 20px; font-weight: bold;">City Second Door</p>
    </div>
    <div style="display: flex; flex-direction: column; align-items: center; margin: 10px;">
        <img src="https://cdn.discordapp.com/attachments/898673216116109324/1084338278506971197/image.png" style="width: 200px; height: 200px; object-fit: cover; border-radius: 10px;">
        <p style="margin: 0; font-size: 20px; font-weight: bold;">Grapeseed Main Door</p>
    </div>
    <div style="display: flex; flex-direction: column; align-items: center; margin: 10px;">
        <img src="https://cdn.discordapp.com/attachments/898673216116109324/1084338329706840144/image.png" style="width: 200px; height: 200px; object-fit: cover; border-radius: 10px;">
        <p style="margin: 0; font-size: 20px; font-weight: bold;">Grapeseed Second Door</p>
    </div>
    <div style="display: flex; flex-direction: column; align-items: center; margin: 10px;">
        <img src="https://cdn.discordapp.com/attachments/898673216116109324/1084341564446343168/image.png" style="width: 200px; height: 200px; object-fit: cover; border-radius: 10px;">
        <p style="margin: 0; font-size: 20px; font-weight: bold;">Paleto Main Door</p>
    </div>
    <div style="display: flex; flex-direction: column; align-items: center; margin: 10px;">
        <img src="https://cdn.discordapp.com/attachments/898673216116109324/1084338478663348224/image.png" style="width: 200px; height: 200px; object-fit: cover; border-radius: 10px;">
        <p style="margin: 0; font-size: 20px; font-weight: bold;">Paleto Second Door</p>
    </div>
</div>

## Support

This is not a QBCore script nor is it maintained by them, please refer to my discord for any issues!

- [discord](https://discord.gg/tVA58nbBuk)
