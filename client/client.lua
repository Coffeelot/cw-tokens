local QBCore = exports['qb-core']:GetCoreObject() 



local function canInteract(trader) 
    if trader.available then
        if trader.available.from > trader.available.to then
            if GetClockHours() >= trader.available.from or GetClockHours() < trader.available.to then return true else return false end
        else
            if GetClockHours() >= trader.available.from and GetClockHours() < trader.available.to then return true else return false end
        end
    else
        return true
    end
end

--- Create token trader
CreateThread(function()
    if Config.UseTrader then
        if Config.Debug then
           print('Using trader')
        end
        local trader = Config.Trader
        local animation
        if trader.animation then
            animation = trader.animation
        else
            animation = 'WORLD_HUMAN_STAND_IMPATIENT'
        end
    
        local options = {}
        if Config.UseBuyTokens then
            for i,v in pairs(Config.Tokens) do
                local option = { 
                    type = 'client',
                    item = Config.Items.filled,
                    event = 'cw-tokens:client:attemtTradeFromToken',
                    icon = 'fas fa-key',
                    label = v.label..' | $'.. tostring(v.price),
                    value = v.value,
                    canInteract = function()
                        return canInteract(trader)
                    end
                }
                table.insert(options, option)
            end
        else
            for i,v in pairs(Config.Tokens) do
                local option = { 
                    type = 'client',
                    item = Config.Items.empty,
                    event = 'cw-tokens:client:attemtTrade',
                    icon = 'fas fa-key',
                    label = v.label..' | $'.. tostring(v.price),
                    value = v.value,
                    canInteract = function()
                        return canInteract(trader)
                    end
                }
                table.insert(options, option)
            end
        end

        exports['qb-target']:SpawnPed({
            model = trader.model,
            coords = trader.coords,
            minusOne = true,
            freeze = true,
            invincible = true,
            blockevents = true,
            scenario = animation,
            target = {
                options = options,
                distance = 3.0 
            },
            spawnNow = true,
            currentpednumber = 0,
        })
    end   
end)

RegisterNetEvent('cw-tokens:client:attemtTrade', function(data)
    local value = data.value
    local token = Config.Tokens[value]
    if Config.Debug then
       print('Attemting trade with item '..value)
    end
    if token then 
        local qbFromItem = QBCore.Shared.Items[Config.Items.empty]
        if qbFromItem then
            if QBCore.Functions.HasItem(qbFromItem.name) then
                TriggerEvent('animations:client:EmoteCommandStart', {"id"})
                QBCore.Functions.Progressbar("item_check", 'Discussing trade...', 2000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                }, {}, {}, function() -- Done
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    TriggerServerEvent('cw-tokens:server:TradeToken', value)
                end, function()
                    TriggerEvent('animations:client:EmoteCommandStart', {"damn"})
                    QBCore.Functions.Notify('You do not have a '..qbFromItem.label.. ' on you.' , 'error')
                end)
            else
                TriggerEvent('animations:client:EmoteCommandStart', {"damn"})
                QBCore.Functions.Notify('You do not have the items needed', 'error')
            end
        else
            TriggerEvent('animations:client:EmoteCommandStart', {"damn"})
            QBCore.Functions.Notify('Item doesnt exist', 'error')
        end
    else
        TriggerEvent('animations:client:EmoteCommandStart', {"damn"})
        QBCore.Functions.Notify('Trade doesnt exist', 'error')
    end 
end)

local function checkForBuyTokens(value)
    local tokens = nil
    local buytoken = value..Config.Items.suffix
    if Config.Debug then
       print('looking for ', buytoken)
    end
    QBCore.Functions.TriggerCallback('cw-tokens:server:PlayerHasToken', function(result, buytoken)
        tokens = result
    end)
    Wait(100)
    if Config.Debug then
       print('result: ', tokens[buytoken])
    end
    if tokens ~=nil and tokens[buytoken] then return true else return false end
end

RegisterNetEvent('cw-tokens:client:attemtTradeFromToken', function(data)
    local value = data.value
    local token = Config.Tokens[value]
    if Config.Debug then
       print('Attemting trade from token '..value)
    end
    if token then
        if Config.Debug then
            print('Token '..token.value..' exists' )
        end
        
        if checkForBuyTokens(value) then
            if Config.Debug then
               print('Player has the buy token for', value)
            end
            local qbFromItem = QBCore.Shared.Items[Config.Items.filled]
            if qbFromItem then
                if QBCore.Functions.HasItem(qbFromItem.name) then
                    TriggerEvent('animations:client:EmoteCommandStart', {"id"})
                    QBCore.Functions.Progressbar("item_check", 'Discussing trade...', 2000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                    }, {}, {}, function() -- Done
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        TriggerServerEvent('cw-tokens:server:SwapToken', value)
                    end, function()
                        TriggerEvent('animations:client:EmoteCommandStart', {"damn"})
                        QBCore.Functions.Notify('You do not have a '..qbFromItem.label.. ' on you.' , 'error')
                    end)
                else
                    TriggerEvent('animations:client:EmoteCommandStart', {"damn"})
                    QBCore.Functions.Notify('You do not have the items needed', 'error')
                end
            else
                TriggerEvent('animations:client:EmoteCommandStart', {"damn"})
                QBCore.Functions.Notify('Item doesnt exist', 'error')
            end 
        else
            if Config.Debug then
               print('player does NOT have the buy token:', value)
            end
            TriggerEvent('animations:client:EmoteCommandStart', {"shrug"})
            QBCore.Functions.Notify('You do not have the correct token to buy this token', 'error')
        end
    else
        TriggerEvent('animations:client:EmoteCommandStart', {"damn"})
        QBCore.Functions.Notify('Trade doesnt exist', 'error')
    end 
end)