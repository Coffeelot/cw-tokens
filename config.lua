Config = {}

Config.Debug = false
Config.UseBuyTokens = false
Config.Inventory = 'qb' -- qb or ox
Config.Phone = 'qb' -- qb for qb, re for renewed phone
Config.CryptoType = 'moc' -- only relevant for renewed phone!


Config.Items = {
    empty = 'cw_token_empty',
    filled = 'cw_token',
    suffix = '-buy-token'
}

Config.PaymentType = 'crypto'

Config.Tokens = {
    -- Raidjobs
    ['raidmeth'] = {
        value = 'raidmeth',
        label = 'Meth raid job',
        price = 4,
    },
    ['raidcocaine'] = {
        value = 'raidcocaine',
        label = 'Cocaine raid job',
        price = 6,
    },
    ['raidweed'] = {
        value = 'raidweed',
        label = 'Weed raid job',
        price = 1,
    },
    ['raidart'] = {
        value = 'raidart',
        label = 'Art raid job',
        price = 7,
    },
    -- boost
    ['boostelegyr'] = {
        value = 'boostelegyr',
        label = 'Elegy Retro boost job',
        price = 3,
    },
    ['boostsultanrs'] = {
        value = 'boostsultanrs',
        label = 'Sultan RS boost job',
        price = 8,
    },
    ['boostbanshee'] = {
        value = 'boostbanshee',
        label = 'Banshee 900R boost job',
        price = 7,
    },
    ['boostvoodoo'] = {
        value = 'boostvoodoo',
        label = 'voodoo Custom boost job',
        price = 1
    },
    -- trade
    ['tradeUzi'] = {
        value = 'tradeUzi',
        label = 'Uzi token',
        price = 0.2
    },
    ['tradeMilRifle'] = {
        value = 'tradeMilRifle',
        label = 'Military rifle',
        price = 0.9
    },
    ['tradePistol'] = {
        value = 'tradePistol',
        label = 'Pistol',
        price = 0.1
    },
    ['tradeSawedOff'] = {
        value = 'tradeSawedOff',
        label = 'Sawed off',
        price = 0.3
    },
    ['tradeMolotov'] = {
        value = 'tradeMolotov',
        label = 'Molotov',
        price = 0.4
    },
    ['tradeDoubleBarrel'] = {
        value = 'tradeDoubleBarrel',
        label = 'Double Barrel Sawed off',
        price = 0.2
    },
    ['tradeWeedNutrition'] = {
        value = 'tradeWeedNutrition',
        label = 'Weed Nutrition',
        price = 0.1
    },
    ['tradeWeedWhiteWidow'] = {
        value = 'tradeWeedWhiteWidow',
        label = 'White Widow Seeds',
        price = 0.22
    },
    ['tradeWeedSkunk'] = {
        value = 'tradeWeedSkunk',
        label = 'Skunk Seeds',
        price = 0.1
    },
    ['tradeWeedPurpleHaze'] = {
        value = 'tradeWeedPurpleHaze',
        label = 'Purple Haze Seeds',
        price = 0.4
    },
    ['tradeWeedOG'] = {
        value = 'tradeWeedOG',
        label = 'OG Kush Seeds',
        price = 0.31
    },
    ['tradeWeedAmnesia'] = {
        value = 'tradeWeedAmnesia',
        label = 'Amnesia Seeds',
        price = 0.31
    },
    ['tradeMeth'] = {
        value = 'tradeMeth',
        label = 'Meth',
        price = 0.52
    },
    ['tradeCrack'] = {
        value = 'tradeCrack',
        label = 'Crack',
        price = 0.9
    },
}

Config.UseTrader = true

-- Trader
Config.Trader = {
    name = 'tokensGuy',
    model = 'ig_lifeinvad_01',
    tradeName = 'Tokens',
    coords = vector4(-1056.92, -247.32, 43.49, 42.99),
    animation = 'PROP_HUMAN_SEAT_CHAIR_DRINK',
}