# don-jewelery
Jewelery Robbery for QBCore with 3 stores, Thermite, VarHack and auto-lock/unlock doors!

# Credits
- [Holiday95](https://github.com/Holidayy95/qb-jewelery) For their fork of qb-jewelery which this is based on, and giving me the idea.
- [QBCore Framework](https://github.com/qbcore-framework) For the orginal qb-jewelery and for inspiring me to code.
- [MrNewb](https://github.com/MrNewb) For showing me how to get the cases to break, absolute legend!

# Dependencies
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-doorlock](https://github.com/qbcore-framework/qb-doorlock)
- [qb-target](https://github.com/qbcore-framework/qb-target)
- [ps-ui](https://github.com/Project-Sloth/ps-ui)

# New Features
- (Not really a "new" feature but) Optimised script, running at 0~0.1ms, only hitting 0.1ms when it locks or unlocks a door after a hack.
- 2 New stores to rob // Grapeseed & Paleto
- Doors now lock depending of the time of day, and store is "unthievable" during opening hours.
- Cases will actually smash after you hit them, and reset after cooldown.
- Thermite the stores fusebox to open the front door at night.
- Hack into Vinewood Vangelico's PC to unlock all Vangelico's for 5 minutes (or whatever you set the cooldown to).

# Preview

- [Don Jewelery](https://youtu.be/t-MO9yvzlx4)

# Store MLO's
All store locations are for GigZ Jewelers' except for the base GTA one. It's a free map, link below:
- [GigZ Jewel Store](https://forum.cfx.re/t/mlo-jewel-store-by-gigz/4857261)
- If you're using these MLO's you'll need to use my updated fxmanifest.lua and interiorproxies.meta in don-jewelery/gigz-jewel-fix/

# Important Config
```
Config.VangelicoHours = { -- Store Hours
    range = {
        open = 6, -- When the doors unlock
        close = 17 -- When they lock for the night (for some reason this is actually 6pm)
    }
} 

Config.Cooldown = 5 * (60 * 2000) -- where x is minutes ie. x * (60 * 2000) \\ For door auto lock function
Config.Timeout = 5 * (60 * 2000) -- where x is minutes ie. x * (60 * 2000) \\ For case smashing cooldown
Config.RequiredCops = 0

Config.Doors = { -- qb-doorlock door IDs
    [1] = { -- City Vangelico's
        ["main"] = "jewelery-citymain",
        ["sec"] = "jewelery-citysec"
    },
    [2] = { -- Grapeseed Vangelico's
        ["main"] = "jewelery-grapemain",
        ["sec"] = "jewelery-grapesec"
    },
    [3] = { -- Paleto Vangelico's
        ["main"] = "jewelery-palmain",
        ["sec"] = "jewelery-palsec"
    }
}

Config.DoorItem = 'thermite' -- Item to remove\check for when placing a charge
Config.ThermiteSettings = {
    time = 60, -- time the hack displays for
    gridsize = 5, -- (5, 6, 7, 8, 9, 10) size of grid by square units, ie. gridsize = 5 is a 5 * 5 (25) square grid
    incorrectBlocks = 10 -- incorrectBlocks = number of incorrect blocks after which the game will fail
}

Config.VarHackSettings = {
    blocks = 2, -- time the hack displays for
    time = 20 -- time the hack displays for
}
```
# Add to qb-doorlock/Configs/
```
Config.DoorList['jewelery-citymain'] = {
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

Config.DoorList['jewelery-citysec'] = {
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

Config.DoorList['jewelery-grapemain'] = {
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

Config.DoorList['jewelery-grapesec'] = {
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

Config.DoorList['jewelery-palmain'] = {
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

Config.DoorList['jewelery-palsec'] = {
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
# Support

This is not a QBCore script nor is it maintained by them, please refer to my discord for any issues! 
- [discord](https://discord.gg/tVA58nbBuk)
