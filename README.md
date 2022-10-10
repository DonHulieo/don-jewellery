# don-jewelery
Jewelery Store heist script with 3 stores for QBCore

# Credits
- [Holiday95](https://github.com/Holidayy95/qb-jewelery) For their fork of qb-jewelery which this is based on, and giving me the idea.

# Dependencies
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-doorlock](https://github.com/qbcore-framework/qb-doorlock)
- [qb-target](https://github.com/qbcore-framework/qb-target)
- [ps-ui](https://github.com/Project-Sloth/ps-ui)

# New Features
- 2 New stores to rob // Grapeseed & Paleto
- Doors now lock depending of the time of day, and store is "unthievable" during opening hours.
- Thermite the stores fusebox to open the front door at night.
- Hack into Vinewood Vangelico's PC to unlock all Vangelico's for 5 minutes (or whatever you set the cooldown to).
- A cooldown for locking the doors again after the hacks.

# Support

This is not a QBCore script nor is it maintained by them, please refer to my discord for any issues! 
- [discord](https://discord.gg/tVA58nbBuk)

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
