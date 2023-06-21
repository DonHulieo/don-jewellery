Config = Config or {}

Config.OneStore = true -- Set to true if using just the main Vangelico's Jewellers
Config.Cooldown = 5 * (60 * 2000) -- where x is minutes ie. x * (60 * 2000) \\ For door auto lock function
Config.Timeout = 5 * (60 * 2000) -- where x is minutes ie. x * (60 * 2000) \\ For case smashing cooldown
Config.AutoLock = true -- Set to false if you don't want the doors to auto lock/lock at all
Config.RequiredCops = 0

Config.VangelicoHours = { -- Store Hours
  range = { -- Set both to 0 if you want the store to be robbed 24/7
    open = 6, -- When the doors unlock // Default 6am
    close = 18 -- When they lock for the night // Default 6pm
  },
  alertnight = {
    start = 18, -- The start of higher chance alerts in the evening // Default 6pm
    fin = 20 -- The end of higher chance alerts in the evening // Default 8pm
  },
  alertmorn = {
    start = 4, -- The start of higher chance alerts in the morning // Default 4am
    fin = 6 -- The end of higher chance alerts in the morning // Default 6am
  }
}

Config.Dispatch = 'ps' -- Police Dispatch System 
--[[ 
  Set to 'ps' for police-script 
  Set to 'qb' for base qb-policejob alerts 
  Set to 'cd' for cd_policealerts
]]--

Config.DoorLock = 'qb' -- Doorlock System
if Config.DoorLock == 'ox' then -- Don't touch this
  Config.DoorGroup = 'jewellery_stores' -- Doorlock System Extra Name // For ox_doorlock of the default config provided doesn't work
end
--[[
  Set to 'qb' for qb-doorlock  
  // Create a file named `jewellery_stores` in qb-doorlock/config/ and copy the Door Config from the README into it.
  Set to 'ox' for ox_doorlock 
  // Uncomment '@ox_lib/init.lua' from the fxmanifest.lua, create a file named `jewellery_stores` in ox_doorlock/config/ and copy the Door Config from the README into it.
  Set to 'cd' for cd_doorlock
  // Create a Group named `Jewellery Stores` through the in-game menu and add the copy the Door Config from the README into it. 
  Ensure the names of the doors correspond to the names of the doors below. 
]]--

if Config.OneStore then -- Don't touch this
  Config.HackEffect = 'disableCam' -- Set to 'disableAlarm' to disable police alerts or 'disableCam' to disable cameras
end -- Don't touch this

Config.Stores = {
  [1] = { -- City Vangelico's
    label = 'Vangelico\'s Jewellers',
    coords = vector3(-630.5, -237.13, 38.08),
    ['Doors'] = {
      main = 'jewellery-citymain',
      sec = 'jewellery-citysec'
    },
    ['Thermite'] = {
      -- City Vangelico's \\ Rooftop Thermite --
      coords = vector3(-596.02, -283.7, 50.4),
      h = 300.0,
      minZ = 50.12,
      maxZ = 51.32,
      anim = vector4(-596.02, -283.7, 50.4, 304.5), 
      effect = vector3(-596.02, -283.7, 50.19)
    },
    ['Hack'] = {
      -- City Vangelico's \\ PC Hack  --
      coords = vector3(-631.04, -230.63, 38.06),
      h = 37.0,
      minZ = 37.56,
      maxZ = 38.56,
      anim = vector4(-631.03, -229.55, 39.23, 180.18)
    },
    hit = false, -- Don't touch this
    hacked = false -- Don't touch this
  },
  [2] = { -- Grapeseed Vangelico's
    label = 'Vangelico\'s Jewellers',
    coords = vector3(1649.78, 4882.32, 42.16),
    ['Doors'] = {
      main = 'jewellery-grapemain',
      sec = 'jewellery-grapesec'
    },
    ['Thermite'] = {
      -- Grapeseed Vangelico's \\ Side Alley Thermite --
      coords = vector3(1645.07, 4867.87, 42.03),
      h = 8.0,
      minZ = 41.23,
      maxZ = 42.53,
      anim = vector4(1645.07, 4867.87, 42.03, 16.33), 
      effect = vector3(1645.07, 4867.87, 41.84)
    },
    hit = false -- Don't touch this
  },
  [3] = { -- Paleto Vangelico's
    label = 'Vangelico\'s Jewellers',
    coords = vector3(-378.45, 6047.68, 32.69),
    ['Doors'] = {
      main = 'jewellery-palmain',
      sec = 'jewellery-palsec'
    },
    ['Thermite'] = {
      -- Paleto Vangelico's \\ Rear Alley Thermite --
      coords = vector3(-368.35, 6055.36, 31.5), -- h = 136.27
      h = 135.0,
      minZ = 31.2,
      maxZ = 32.4,
      anim = vector4(-368.35, 6055.36, 31.5, 136.27), 
      effect = vector3(-368.35, 6055.36, 31.31)
    },
    hit = false -- Don't touch this
  }
}

Config.DoorItem = 'thermite' -- item to remove\check for when placing a charge
Config.ThermiteSettings = {
  time = 60, -- time the hack displays for \\ half being showing the puzzle and the other solving
  gridsize = 5, -- (5, 6, 7, 8, 9, 10) size of grid by square units, ie. gridsize = 5 is a 5 * 5 (25) square grid
  incorrectBlocks = 10 -- incorrectBlocks = number of incorrect blocks after which the game will fail
}

Config.HackItem = 'phone' -- item to remove\check for when hacking
Config.VarHackSettings = {
  blocks = 2, -- time the hack displays for \\ half being showing the puzzle and the other solving
  time = 20 -- time the hack displays for
}

Config.WhitelistedWeapons = {
  [`weapon_assaultrifle`] = {
    timeOut = 5000
  },
  [`weapon_carbinerifle`] = {
    timeOut = 5000
  },
  [`weapon_pumpshotgun`] = {
    timeOut = 5000
  },
  [`weapon_sawnoffshotgun`] = {
    timeOut = 5000
  },
  [`weapon_compactrifle`] = {
    timeOut = 5000
  },
  [`weapon_autoshotgun`] = {
    timeOut = 5000
  },
  [`weapon_crowbar`] = {
    timeOut = 5000
  },
  [`weapon_pistol`] = {
    timeOut = 5000
  },
  [`weapon_pistol_mk2`] = {
    timeOut = 5000
  },
  [`weapon_combatpistol`] = {
    timeOut = 5000
  },
  [`weapon_appistol`] = {
    timeOut = 5000
  },
  [`weapon_pistol50`] = {
    timeOut = 5000
  }, 
  [`weapon_microsmg`] = {
    timeOut = 5000
  },
}

Config.VitrineRewards = {
  [1] = {
    item = 'rolex',
    ['Amounts'] = {
      min = 1,
      max = 4
    }
  },
  [2] = {
    item = 'diamond_ring',
    ['Amounts'] = {
      min = 1,
      max = 4
    }
  },
  [3] = {
    item = 'goldchain',
    ['Amounts'] = {
      min = 1,
      max = 4
    }
  }
}

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
  ['Hack'] = {
    skill = 'Hacking',
    ['Limits'] = {
      xp = 1600
    },
    ['Rewards'] = {
      xp = 25,
      multi = 2.5
    }
  },
  ['Vitrine'] = {
    skill = 'Heist Reputation',
    ['Limits'] = {
      xp = 0
    },
    ['Rewards'] = {
      xp = 5,
      multi = 1.25
    }
  }
}

Config.Vitrines = {
  [1] = {
    coords = vector3(-626.83, -235.35, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab3_start`,
    propEnd = `des_jewel_cab3_end`
  },
  [2] = {
    coords = vector3(-625.81, -234.7, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab4_start`,
    propEnd = `des_jewel_cab4_end`
  },
  [3] = {
    coords = vector3(-626.95, -233.14, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab_start`,
    propEnd = `des_jewel_cab_end`
  },
  [4] = {
    coords = vector3(-628.0, -233.86, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab_start`,
    propEnd = `des_jewel_cab_end`
  },
  [5] = {
    coords = vector3(-625.7, -237.8, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab3_start`,
    propEnd = `des_jewel_cab3_end`
  },
  [6] = {
    coords = vector3(-626.7, -238.58, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab2_start`,
    propEnd = `des_jewel_cab2_end`
  },
  [7] = {
    coords = vector3(-624.55, -231.06, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab4_start`,
    propEnd = `des_jewel_cab4_end`
  },
  [8] = {
    coords = vector3(-623.13, -232.94, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab_start`,
    propEnd = `des_jewel_cab_end`
  },
  [9] = {
    coords = vector3(-620.29, -234.44, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab_start`,
    propEnd = `des_jewel_cab_end`
  },
  [10] = {
    coords = vector3(-619.15, -233.66, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab3_start`,
    propEnd = `des_jewel_cab3_end`
  },
  [11] = {
    coords = vector3(-620.19, -233.44, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab4_start`,
    propEnd = `des_jewel_cab4_end`
  },
  [12] = {
    coords = vector3(-617.63, -230.58, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab2_start`,
    propEnd = `des_jewel_cab2_end`
  },
  [13] = {
    coords = vector3(-618.33, -229.55, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab3_start`,
    propEnd = `des_jewel_cab3_end`
  },
  [14] = {
    coords = vector3(-619.7, -230.33, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab_start`,
    propEnd = `des_jewel_cab_end`
  },
  [15] = {
    coords = vector3(-620.95, -228.6, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab3_start`,
    propEnd = `des_jewel_cab3_end`
  },
  [16] = {
    coords = vector3(-619.79, -227.6, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab2_start`,
    propEnd = `des_jewel_cab2_end`
  },
  [17] = {
    coords = vector3(-620.42, -226.6, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab_start`,
    propEnd = `des_jewel_cab_end`
  },
  [18] = {
    coords = vector3(-623.94, -227.18, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab4_start`,
    propEnd = `des_jewel_cab4_end`
  },
  [19] = {
    coords = vector3(-624.91, -227.87, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab3_start`,
    propEnd = `des_jewel_cab3_end`
  },
  [20] = {
    coords = vector3(-623.94, -228.05, 38.05),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab2_start`,
    propEnd = `des_jewel_cab2_end`
  },
  [21] = {
    coords = vector3(1646.35, 4879.66, 41.74),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab4_start`,
    propEnd = `des_jewel_cab4_end`
  },
  [22] = {
    coords = vector3(1647.6, 4881.69, 41.75),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab3_start`,
    propEnd = `des_jewel_cab3_end`
  },
  [23] = {
    coords = vector3(1648.79, 4882.52, 41.75),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab_start`,
    propEnd = `des_jewel_cab_end`
  },
  [24] = {
    coords = vector3(1647.5, 4882.33, 41.75),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab2_start`,
    propEnd = `des_jewel_cab2_end`
  },
  [25] = {
    coords = vector3(1648.66, 4886.42, 41.75),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab3_start`,
    propEnd = `des_jewel_cab3_end`
  },
  [26] = {
    coords = vector3(1649.94, 4886.6, 41.75),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab3_start`,
    propEnd = `des_jewel_cab3_end`
  },
  [27] = {
    coords = vector3(-379.13, 6049.96, 31.09),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab4_start`,
    propEnd = `des_jewel_cab4_end`
  },
  [28] = {
    coords = vector3(-378.91, 6047.59, 31.1),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab3_start`,
    propEnd = `des_jewel_cab3_end`
  },
  [29] = {
    coords = vector3(-379.37, 6046.21, 31.1),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab_start`,
    propEnd = `des_jewel_cab_end`
  },
  [30] = {
    coords = vector3(-378.45, 6047.13, 31.1),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab2_start`,
    propEnd = `des_jewel_cab2_end`
  },
  [31] = {
    coords = vector3(-376.94, 6043.16, 31.1),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab3_start`,
    propEnd = `des_jewel_cab3_end`
  },
  [32] = {
    coords = vector3(-377.85, 6042.25, 31.1),
    isOpened = false,
    isBusy = false,
    propStart = `des_jewel_cab3_start`,
    propEnd = `des_jewel_cab3_end`
  }
}

Config.MaleNoHandshoes = {
  [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [18] = true, [26] = true, [52] = true, [53] = true, [54] = true, [55] = true, [56] = true, [57] = true, [58] = true, [59] = true, [60] = true, [61] = true, [62] = true, [112] = true, [113] = true, [114] = true, [118] = true, [125] = true, [132] = true
}

Config.FemaleNoHandshoes = {
  [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [19] = true, [59] = true, [60] = true, [61] = true, [62] = true, [63] = true, [64] = true, [65] = true, [66] = true, [67] = true, [68] = true, [69] = true, [70] = true, [71] = true, [129] = true, [130] = true, [131] = true, [135] = true, [142] = true, [149] = true, [153] = true, [157] = true, [161] = true, [165] = true
}
