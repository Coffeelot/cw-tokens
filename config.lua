Config = {}

Config.Debug = false
Config.UseBuyTokens = false

Config.Items = {
    empty = 'cw_token_empty',
    filled = 'cw_token',
    suffix = '-buy-token'
}


Config.Tokens = {
    -- Raidjobs
    ['raidmeth'] = {
        value = 'raidmeth',
        label = 'Meth raid job',
        price = 12000,
    },
    ['raidcocaine'] = {
        value = 'raidcocaine',
        label = 'Cocaine raid job',
        price = 20000,
    },
    ['raidweed'] = {
        value = 'raidweed',
        label = 'Weed raid job',
        price = 1000,
    },
    ['raidart'] = {
        value = 'raidart',
        label = 'Art raid job',
        price = 35000,
    },
    -- boost
    ['boostelegyr'] = {
        value = 'boostelegyr',
        label = 'Elegy Retro boost job',
        price = 10000,
    },
    ['boostsultanrs'] = {
        value = 'boostsultanrs',
        label = 'Sultan RS boost job',
        price = 9000,
    },
    ['boostbanshee'] = {
        value = 'boostbanshee',
        label = 'Banshee 900R boost job',
        price = 11000,
    },
    ['boostvoodoo'] = {
        value = 'boostvoodoo',
        label = 'voodoo Custom boost job',
        price = 1000
    },
    -- trade
    ['tradeUzi'] = {
        value = 'tradeUzi',
        label = 'Uzi token',
        price = 5000
    },
    ['tradeMilRifle'] = {
        value = 'tradeMilRifle',
        label = 'Military rifle',
        price = 30000
    },
}

Config.UseTrader = true
-- Trade
local CansToMeth = {
    tradeName = 'CansToMeth',
    tradeLabel = 'Trade cans to meth',
    fromItem = 'plastic', -- change this to "can" when we get the cans into the server
    fromAmount = 35, -- balance this ocne we get cans in.
    toItem = 'meth',
    toAmount = 1
}
-- Trader
Config.Trader = {
    name = 'tokensGuy',
    model = 'ig_lifeinvad_01',
    tradeName = 'Tokens',
    coords = vector4(-1056.92, -247.32, 43.49, 42.99),
    animation = 'PROP_HUMAN_SEAT_CHAIR_DRINK',
}