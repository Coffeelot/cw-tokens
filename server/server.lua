local QBCore = exports['qb-core']:GetCoreObject()
local useDebug = Config.Debug

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

local function getQBItem(item)
    local qbItem = QBCore.Shared.Items[item]
    if qbItem then
        return qbItem
    else
        print('Someone forgot to add the item')
    end
end

local function getItems(src, item)
    local Player = QBCore.Functions.GetPlayer(src)
    if Config.Inventory == 'qb' then
        return Player.Functions.GetItemsByName(item)
    elseif Config.Inventory == 'ox' then
        return exports.ox_inventory:GetItem(src, item)
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

local function removeItem(item, slot, source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Config.Inventory == 'qb' then
        Player.Functions.RemoveItem(item, 1, slot)
        TriggerClientEvent('inventory:client:ItemBox', source, getQBItem(item), "remove")
    elseif Config.Inventory == 'ox' then
        exports.ox_inventory:RemoveItem(source, item, 1, nil, slot)
    end
end

local function addItem(item, info, source)
    if Config.Inventory == 'qb' then
    	local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.AddItem(item, 1, nil, info)
        TriggerClientEvent('inventory:client:ItemBox', source, getQBItem(item), "add")
    elseif Config.Inventory == 'ox' then
        exports.ox_inventory:AddItem(source, item, 1, info)
    end
end

local function getTokens(value)
    local result = {}

    if tokens then
        for _, item in ipairs(tokens) do
            result[item.info.value] = item.info.value 
        end
    end
    cb(result)
end

local function getItemSlot(src, value)
    if Config.Inventory == 'qb' then
        local Player = QBCore.Functions.GetPlayer(src)
        local tokens = Player.Functions.GetItemsByName(Config.Items.filled)
        local slot = nil
        if tokens then
            for _, item in ipairs(tokens) do
                if useDebug then
                   print(item.info.value)
                end
                if item.info.value == value then
                    return item.slot
                end
            end
        else
            return false
        end
    elseif Config.Inventory == 'ox' then
        local result = exports.ox_inventory:Search(src, 'slots', Config.Items.filled, { value = value})
        if useDebug then
           print('fetched slot:', dump(result[1].slot))
        end
        if #result > 0 then
            return result[1].slot
        else
            return false
        end
    end
end

local function removeMoney(src, amount, type)
    if Config.Phone == 'qb' then
	    local Player = QBCore.Functions.GetPlayer(src)
        if type == nil then -- If we dont specify the crypto type for this token we default
            type = Config.PaymentType
        end
        Player.Functions.RemoveMoney(type, amount)
    elseif Config.Phone == 're' then
        if type == nil then -- If we dont specify the crypto type for this token we default
            type = Config.CryptoType
        end
        return exports['qb-phone']:RemoveCrypto(src, type, amount)
    end
end

local function hasEnoughMoney(src, amount, type)
    if Config.Phone == 'qb' then
	    local Player = QBCore.Functions.GetPlayer(src)
        return Player.PlayerData.money[Config.PaymentType] >= amount
    elseif Config.Phone == 're' then
        if type == nil then -- If we dont specify the crypto type for this token we default
            type = Config.CryptoType
        end
        return exports['qb-phone']:hasEnough(src, type, amount)
    end
end

-- Fill Token
local function fillToken(source, value, trade)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local itemFrom = Config.Items.empty
    local hasItem = getItems(src, Config.Items.empty)
    if hasItem then
        if trade then
	        Player.Functions.RemoveMoney(Config.PaymentType, Config.Tokens[value].price)
        end

        removeItem(itemFrom, nil, source)
        local item, info = createToken(value)
        addItem(item, info, source)
    else
        TriggerClientEvent('QBCore:Notify', src, "You got no empty tokens", 'error')
    end
end

-- ADD TOKEN
RegisterServerEvent('cw-tokens:server:GiveToken', function(value)
    local src = source

    local item, info = createToken(value)
    addItem(item, info, src)
end)

RegisterServerEvent('cw-tokens:server:GiveBuyToken', function(value)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local buyToken = value..Config.Items.suffix
    local item, info = createToken(buyToken)

    addItem(item, info, src)
end)



-- TAKE TOKEN
RegisterNetEvent('cw-tokens:server:TakeToken', function(src, value)
    if useDebug then
       print('in cw tokens', value, src)
    end
    local item = Config.Items.filled
    local ped = QBCore.Functions.GetPlayer(src)
    local id = QBCore.Functions.GetPlayer(src).PlayerData.citizenid

    local slot = getItemSlot(src, value)

    if slot then
        removeItem(item, slot, src)
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

    if hasEnoughMoney(src, Config.Tokens[value].price, Config.Tokens[value].CryptoType) then
        removeMoney(src, Config.Tokens[value].price, Config.Tokens[value].CryptoType)
        fillToken(src, value)
	else
        TriggerClientEvent('animations:client:EmoteCommandStart', src, {"damn"})
		TriggerClientEvent('QBCore:Notify', src, "Not enough crypto", 'error')
	end
end)

RegisterNetEvent('cw-tokens:server:DigitalTradeToken', function(value, price)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    if hasEnoughMoney(src, price, Config.Tokens[value].CryptoType) then
		removeMoney(src, price, Config.Tokens[value].CryptoType)
        fillToken(src, value)
	else
		TriggerClientEvent('QBCore:Notify', src, "Not enough crypto", 'error')
	end

end)

RegisterNetEvent('cw-tokens:server:SwapToken', function(value)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)

    if hasEnoughMoney(src, Config.Tokens[value].price, Config.Tokens[value].CryptoType) then
		removeMoney(src, price, Config.Tokens[value].CryptoType)
        local buytoken = value..Config.Items.suffix
        TriggerEvent('cw-tokens:server:TakeToken', src, buytoken)
        local item, info = createToken(value)
        addItem(item, info, src)
	else
        TriggerClientEvent('animations:client:EmoteCommandStart', src, {"damn"})
		TriggerClientEvent('QBCore:Notify', src, "Not enough crypto", 'error')
	end
end)

RegisterNetEvent('cw-tokens:server:DigitalSwapToken', function(value, price)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)

    if hasEnoughMoney(src, Config.Tokens[value].price, Config.Tokens[value].CryptoType) then
		removeMoney(src, price)
        local buytoken = value..Config.Items.suffix
        TriggerEvent('cw-tokens:server:TakeToken', src, buytoken)
        local item, info = createToken(value)
        addItem(item, info, src)
	else
		TriggerClientEvent('QBCore:Notify', src, "Not enough crypto", 'error')
	end
end)

QBCore.Functions.CreateCallback('cw-tokens:server:PlayerHasBuyToken', function(source, cb, value)
    if useDebug then
        print('checking pockets for', value)
    end
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local id = Player.PlayerData.citizenid
    local tokens = getItems(src, Config.Items.filled)
    local result = {}
    local buyTokenValue = value..Config.Items.suffix
    if tokens then
        for _, item in ipairs(tokens) do
            if Config.Inventory == 'qb' then
                if item.info.value == buyTokenValue then
                    cb(true)
                end
            elseif Config.Inventory == 'ox' then
                if item.metadata.value == buyTokenValue then
                    cb(true)
                end
            end 

        end
    end
    cb(false)
end)

local function hasTokenWithValue(src, item, value)
    local Player = QBCore.Functions.GetPlayer(src)
    if Config.Inventory == 'qb' then
        local items =  Player.Functions.GetItemsByName(item)
        local result = {}
        if items then
            for _, item in ipairs(items) do
                if item.info.value == value then return true end
            end
        end
        if items ~= nil then return true end
    elseif Config.Inventory == 'ox' then
        local items = exports.ox_inventory:Search(src, 'count', item, { value = value } )
        return items > 0
    end
end


QBCore.Functions.CreateCallback('cw-tokens:server:PlayerHasTokenWithValue', function(source, cb, value)
    if useDebug then
        print('getting tokens with value', value)
    end
    local src = source
    local result = {}
    local tokens = hasTokenWithValue(src, Config.Items.filled, value)
    if useDebug then
       print('found token?', tokens)
    end
    cb(tokens)
end)

QBCore.Functions.CreateCallback('cw-tokens:server:PlayerHasToken', function(source, cb, value)
    if useDebug then
        print('getting all tokens')
    end
    local src = source
    local ped = QBCore.Functions.GetPlayer(src)
    local id = QBCore.Functions.GetPlayer(src).PlayerData.citizenid
	local Player = QBCore.Functions.GetPlayer(src)
    local tokens = getItems(Config.Items.filled, Player)
    local result = {}
    if tokens then
        for _, item in ipairs(tokens) do
            if Config.Inventory == 'qb' then
                result[item.info.value] = item.info.value
            elseif Config.Inventory == 'ox' then
                result[item.metaData.value] = item.metaData.value
            end
        end
    end
    cb(result)
end)


-- COMMANDS
QBCore.Commands.Add('createtoken', 'give token with value. (Admin Only)',{ { name = 'value', help = 'what value should the token contain' }}, true, function(source, args)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    
    local item, info = createToken(args[1])
    print(item, dump(info))
    addItem(item, info, src)
    end, 'admin')

QBCore.Commands.Add('createbuytoken', 'give a buy token with value. (Admin Only)',{ { name = 'value', help = 'what value should the token contain' }}, true, function(source, args)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    
    local buytoken = args[1]..Config.Items.suffix
    local item, info = createToken(buytoken)
    
    addItem(item, info, src)
end, 'admin')

QBCore.Commands.Add('filltoken', 'exchange empty token to filled with value. (Admin Only)',{ { name = 'value', help = 'what value should the token contain' }}, true, function(source, args)
    local src = source
    fillToken(src, args[1])
end, 'admin')

QBCore.Commands.Add('cwdebugtokens', 'toggle debug for tokens', {}, true, function(source, args)
    useDebug = not useDebug
    print('debug is now:', useDebug)
    TriggerClientEvent('cw-tokens:client:toggleDebug',source, useDebug)
end, 'admin')