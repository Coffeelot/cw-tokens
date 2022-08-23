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
            QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
                if result then
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
            end, qbFromItem.name , token.fromAmount)

        else
            TriggerEvent('animations:client:EmoteCommandStart', {"damn"})
            QBCore.Functions.Notify('Item doesnt exist', 'error')
        end
    else
        TriggerEvent('animations:client:EmoteCommandStart', {"damn"})
        QBCore.Functions.Notify('Trade doesnt exist', 'error')
    end 
end)