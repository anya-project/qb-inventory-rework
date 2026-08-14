--config/vehicles.lua

VehicleStorage = {

    byModel = {
        ['zentorno'] = { -- EXAMPLE
            trunkSlots = 10,
            trunkWeight = 50000,
            gloveboxSlots = 10,
            gloveboxWeight = 50000
        },
        ['tigon'] = {  -- EXAMPLE
            trunkSlots = 10,
            trunkWeight = 50000,
            gloveboxSlots = 5,
            gloveboxWeight = 2000
        },
    },

    default = {
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 35,
        trunkWeight = 100000
    },
    [0] = { -- Compacts
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 30,
        trunkWeight = 100000
    },
    [1] = { -- Sedans
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 40,
        trunkWeight = 100000
    },
    [2] = { -- SUVs
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 50,
        trunkWeight = 100000
    },
    [3] = { -- Coupes
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 35,
        trunkWeight = 90000
    },
    [4] = { -- Muscle
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 30,
        trunkWeight = 90000
    },
    [5] = { -- Sports Classics
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 25,
        trunkWeight = 90000
    },
    [6] = { -- Sports
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 25,
        trunkWeight = 90000
    },
    [7] = { -- Super
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 25,
        trunkWeight = 90000
    },
    [8] = { -- Motorcycles
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 15,
        trunkWeight = 50000
    },
    [9] = { -- Off-road
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 35,
        trunkWeight = 150000
    },
    [10] = { -- Industrial
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 35,
        trunkWeight = 150000
    },
    [11] = { -- Utility
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 35,
        trunkWeight = 150000
    },
    [12] = { -- Vans
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 35,
        trunkWeight = 150000
    },
    [13] = { -- Cycles
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 0,
        trunkWeight = 0
    },
    [14] = { -- Boats
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 50,
        trunkWeight = 100000
    },
    [15] = { -- Helicopters
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 50,
        trunkWeight = 100000
    },
    [16] = { -- Planes
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 50,
        trunkWeight = 100000
    },
    [17] = { -- service
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 35,
        trunkWeight = 150000
    },
    [18] = { -- Emergency
        gloveboxSlots = 4,
        gloveboxWeight = 10000,
        trunkSlots = 12,
        trunkWeight = 150000
    },
    [19] = { -- Military
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 35,
        trunkWeight = 150000
    },
    [20] = { -- Commercial
        gloveboxSlots = 5,
        gloveboxWeight = 100000,
        trunkSlots = 50,
        trunkWeight = 200000
    },
    [21] = { -- trains
        gloveboxSlots = 0,
        gloveboxWeight = 0,
        trunkSlots = 0,
        trunkWeight = 0
    },
    [22] = { -- Commercial
        gloveboxSlots = 5,
        gloveboxWeight = 10000,
        trunkSlots = 50,
        trunkWeight = 200000
    },
}

BackEngineVehicles = {
    [`ninef`] = true,
    [`adder`] = true,
    [`vagner`] = true,
    [`t20`] = true,
    [`infernus`] = true,
    [`zentorno`] = true,
    [`reaper`] = true,
    [`comet2`] = true,
    [`comet3`] = true,
    [`jester`] = true,
    [`jester2`] = true,
    [`cheetah`] = true,
    [`cheetah2`] = true,
    [`prototipo`] = true,
    [`turismor`] = true,
    [`pfister811`] = true,
    [`ardent`] = true,
    [`nero`] = true,
    [`nero2`] = true,
    [`tempesta`] = true,
    [`vacca`] = true,
    [`bullet`] = true,
    [`osiris`] = true,
    [`entityxf`] = true,
    [`turismo2`] = true,
    [`fmj`] = true,
    [`re7b`] = true,
    [`tyrus`] = true,
    [`italigtb`] = true,
    [`italirsx`] = true,
    [`penetrator`] = true,
    [`monroe`] = true,
    [`ninef2`] = true,
    [`stingergt`] = true,
    [`surfer`] = true,
    [`surfer2`] = true,
    [`gp1`] = true,
    [`autarch`] = true,
    [`tyrant`] = true
}

-- Per-vehicle trunk interaction distance override, in meters.
-- Anything not listed here falls back to the 5.0 default in client/vehicles.lua.
TrunkDistances = {
    -- [`zentorno`] = 15.0, -- EXAMPLE
}
