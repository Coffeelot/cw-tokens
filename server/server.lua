local QBCore = exports['qb-core']:GetCoreObject()

local function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end

local function createToken(value) 
    local item = Config.Items.filled
    local token = Config.Tokens[value]
    local info = {}
    if token then
        info.value = token.value
        info.label = token.label
    else
        print("The added token does not exist in the Config.Lua")
        info.value = value
    end

    return item, info
end

local function getQBItem(item)
    local qbItem = QBCore.Shared.Items[item]
    if qbItem then
        return qbItem
    else
        print('Someone forgot to add the item')
    end
end

-- Fill Token
local function fillToken(source, value, trade)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local itemFrom = Config.Items.empty
    local itemTo = Config.Items.filled

    local ped = QBCore.Functions.GetPlayer(src)
    local id = ped.PlayerData.citizenid
	local Player = ped
    local tokens = Player.Functions.GetItemsByName(Config.Items.empty)
    local slot = nil
    if #tokens>0 then
        if trade then
	        Player.Functions.RemoveMoney(Config.PaymentType, Config.Tokens[value].price)
        end

        Player.Functions.RemoveItem(itemFrom, 1, slot)
        TriggerClientEvent('inventory:client:ItemBox', src, getQBItem(itemFrom), "remove")
        local item, info = createToken(value)

        Player.Functions.AddItem(item, 1, nil, info)
        TriggerClientEvent('inventory:client:ItemBox', source, getQBItem(item), "add")
    else
        TriggerClientEvent('QBCore:Notify', src, "You got no empty tokens", 'error')
    end
end

-- ADD TOKEN
RegisterServerEvent('cw-tokens:server:GiveToken', function(value)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)

    local item, info = createToken(value)

    Player.Functions.AddItem(item, 1, nil, info)
    TriggerClientEvent('inventory:client:ItemBox', source, getQBItem(item), "add")
end)

RegisterServerEvent('cw-tokens:server:GiveBuyToken', function(value)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local buyToken = value..Config.Items.suffix
    local item, info = createToken(buyToken)

    Player.Functions.AddItem(item, 1, nil, info)
    TriggerClientEvent('inventory:client:ItemBox', source, getQBItem(item), "add")
end)

-- TAKE TOKEN
RegisterNetEvent('cw-tokens:server:TakeToken', function(src, value)
    if Config.Debug then
       print('in cw tokens')
    end
	local Player = QBCore.Functions.GetPlayer(src)
    local item = Config.Items.filled
    local ped = QBCore.Functions.GetPlayer(src)
        local id = QBCore.Functions.GetPlayer(src).PlayerData.citizenid
	local Player = QBCore.Functions.GetPlayer(src)
    local tokens = Player.Functions.GetItemsByName(Config.Items.filled)
    local slot = nil
    if tokens then
        for _, item in ipairs(tokens) do
            if Config.Debug then
               print(item.info.value)
            end
            if item.info.value == value then
                slot = item.slot
            end
        end
    end
    if slot then
        Player.Functions.RemoveItem(item, 1, slot)
        TriggerClientEvent('inventory:client:ItemBox', src, getQBItem(item), "remove")
    else
        TriggerClientEvent('QBCore:Notify', src, "You don't have the relevant token", 'error')
    end
end)

RegisterNetEvent('cw-tokens:server:FillToken', function(value)
    local src = source
    fillToken(src, value)
end)

RegisterNetEvent('cw-tokens:server:TradeToken', function(value)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)

    if Player.PlayerData.money[Config.PaymentType] >= Config.Tokens[value].price then
		Player.Functions.RemoveMoney(Config.PaymentType, Config.Tokens[value].price)
        fillToken(src, value, trade)
	else
        TriggerClientEvent('animations:client:EmoteCommandStart', src, {"damn"})
		TriggerClientEvent('QBCore:Notify', src, "Not enough crypto", 'error')
	end
end)

RegisterNetEvent('cw-tokens:server:DigitalTradeToken', function(value, price)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)

    if Player.PlayerData.money['crypto'] >= price then
		Player.Functions.RemoveMoney('crypto', price)
        fillToken(src, value, trade)
	else
		TriggerClientEvent('QBCore:Notify', src, "Not enough crypto", 'error')
	end

end)

RegisterNetEvent('cw-tokens:server:SwapToken', function(value)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)

    if Player.PlayerData.money[Config.PaymentType] >= Config.Tokens[value].price then
		Player.Functions.RemoveMoney(Config.PaymentType, Config.Tokens[value].price)
        local buytoken = value..Config.Items.suffix
        TriggerEvent('cw-tokens:server:TakeToken', src, buytoken)
        local item, info = createToken(value)

        Player.Functions.AddItem(item, 1, nil, info)
        TriggerClientEvent('inventory:client:ItemBox', source, getQBItem(item), "add")
	else
        TriggerClientEvent('animations:client:EmoteCommandStart', src, {"damn"})
		TriggerClientEvent('QBCore:Notify', src, "Not enough crypto", 'error')
	end
end)

RegisterNetEvent('cw-tokens:server:DigitalSwapToken', function(value, price)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)

    if Player.PlayerData.money['crypto'] >= price then
		Player.Functions.RemoveMoney('crypto', price)
        local buytoken = value..Config.Items.suffix
        TriggerEvent('cw-tokens:server:TakeToken', src, buytoken)
        local item, info = createToken(value)

        Player.Functions.AddItem(item, 1, nil, info)
        TriggerClientEvent('inventory:client:ItemBox', source, getQBItem(item), "add")
	else
		TriggerClientEvent('QBCore:Notify', src, "Not enough crypto", 'error')
	end
end)

QBCore.Functions.CreateCallback('cw-tokens:server:PlayerHasBuyToken', function(source, cb, value)
    if Config.Debug then
        print('checking pockets for', value)
    end
    local src = source
    local ped = QBCore.Functions.GetPlayer(src)
    local id = QBCore.Functions.GetPlayer(src).PlayerData.citizenid
	local Player = QBCore.Functions.GetPlayer(src)
    local tokens = Player.Functions.GetItemsByName(Config.Items.filled)
    local result = {}
    local buyTokenValue = value..Config.Items.suffix
    if tokens then
        for _, item in ipairs(tokens) do
            if item.info.value == buyTokenValue then
                cb(true)
            end
        end
    end
    cb(false)
end)

QBCore.Functions.CreateCallback('cw-tokens:server:PlayerHasToken', function(source, cb, value)
    if Config.Debug then
        print('getting all tokens')
    end
    local src = source
    local ped = QBCore.Functions.GetPlayer(src)
    local id = QBCore.Functions.GetPlayer(src).PlayerData.citizenid
	local Player = QBCore.Functions.GetPlayer(src)
    local tokens = Player.Functions.GetItemsByName(Config.Items.filled)
    local result = {}
    if tokens then
        for _, item in ipairs(tokens) do
            result[item.info.value] = item.info.value 
        end
    end
    cb(result)
end)

-- COMMANDS
QBCore.Commands.Add('createtoken', 'give token with value. (Admin Only)',{ { name = 'value', help = 'what value should the token contain' }}, true, function(source, args)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    
    local item, info = createToken(args[1])
    
    Player.Functions.AddItem(item, 1, nil, info)
    TriggerClientEvent('inventory:client:ItemBox', source, getQBItem(item), "add")
end, 'admin')

QBCore.Commands.Add('createbuytoken', 'give a buy token with value. (Admin Only)',{ { name = 'value', help = 'what value should the token contain' }}, true, function(source, args)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    
    local buytoken = args[1]..Config.Items.suffix
    local item, info = createToken(buytoken)
    
    Player.Functions.AddItem(item, 1, nil, info)
    TriggerClientEvent('inventory:client:ItemBox', source, getQBItem(item), "add")
end, 'admin')

QBCore.Commands.Add('filltoken', 'exchange empty token to filled with value. (Admin Only)',{ { name = 'value', help = 'what value should the token contain' }}, true, function(source, args)
    local src = source
    fillToken(src, args[1])
end, 'admin')