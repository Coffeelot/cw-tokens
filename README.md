# Token system 🔑
This script is used to add tokens. These tokens are used in scripts like [cw-trading](https://github.com/Coffeelot/cw-trading), [cw-raidjob](https://github.com/Coffeelot/cw-raidjob) and [cw-boostjob](https://github.com/Coffeelot/cw-boostjob) (and maybe even more) as an optional way to allow players access to these jobs. 

The script has several pre-made tokens that all use the same item. Has support for any cw script that come with `Config.UseTokens` in it's config. These need to be set to `true` to utalize this script!

❗ We suggest you add some way to get empty tokens to you players, maybe as loot in robberies or other heists for example. This is not supplied ❗

You can spawn empty tokens by doing `/giveitem [playerId] cw_token_empty 1`, or filled tokens with `/createtoken raidmeth` (to get token that gives access to meth job from cw-raidjob for example) if you are admin and want to try it out. 

# Developed by Coffeelot and Wuggie
[More scripts by us](https://github.com/stars/Coffeelot/lists/cw-scripts)  👈

**Support, updates and script previews**:

[![Join The discord!](https://cdn.discordapp.com/attachments/977876510620909579/1013102122985857064/discordJoin.png)](https://discord.gg/FJY4mtjaKr )

**All our scripts are and will remain free**. If you want to support what we do, you can buy us a coffee here:

[![Buy Us a Coffee](https://www.buymeacoffee.com/assets/img/guidelines/download-assets-sm-2.svg)](https://www.buymeacoffee.com/cwscriptbois )

# Preview 📽
[![YOUTUBE VIDEO](http://img.youtube.com/vi/X8kbM4mPisk/0.jpg)](https://youtu.be/X8kbM4mPisk)

# Setup 🔧
## The config file
All setup is done through the Config.Lua file. You can add new tokens there following the examples that come with the script. For example:
```
    ['tradeUzi'] = {
        value = 'tradeUzi',
        label = 'Uzi token',
        price = 5000
    },
```
This object gives you access to get an uzi from the trader from from [cw-trading](https://github.com/Coffeelot/cw-trading).
Let's use an example for a new token trade. Let's say you want to add a trader that gives you a sandwich for a token, using cw-trading. First you add another object in the list in cw-tokens, that look like this:
```
    ['tradeSandwich'] = {
        value = 'tradeSandwich',
        label = 'Sandwich token',
        price = 5
    },
```
In cw-trade you add a new trade:
```
local TokenToSandwich = {
    tradeName = 'TokenToSandwich',
    fromItems = {
        { name = 'cw_token', amount = 1 },
    },
    tokenValue= 'tradeSandwich'
    toItems = {
        { name = 'sandwich', amount = 1 }
    },
}
```
Note that `tokenValue` needs to match the value of the token you created in cw-tokens!
Also, don't forget to add the trade to the Config.Trades in the bottom of the cw-trade Config.Lua.


Next you add a trader in cw-traders:
```
local sandwichGuy = {
    name = 'sandwichGuy',
    model = 'csb_ramp_gang',
    tradeLabel = 'Trade token for sandwich',
    tradeName = 'TokenToSandwich',
    coords = vector4(123.49, -1295.33, 29.27, 26.46),
    animation = 'WORLD_HUMAN_JOG_STANDING',
}
```
Don't forget to add this trader in the Config.TokenTraders object at the bottom of the Config.Lua in cw-traders!
Oh, and don't for get to enable tokens for both traders and trades! (It's at the top of their respective Config file.)

Now you can find a guy who takes tokens and gives you sandwiches!

## Tokens For Tokenens 
Let's say you don't want people buying access to jobs and guns all willy-nilly. Then this function is for you!
In the Config.Lua, set Config.UseBuyTokens to `true`. The included token trader will now ONLY accept the trades if you already have a corresponding buy-token (you might want to update the prices if you use this).

How your players get the buy-tokens is all up to you. But here's an example:
Lets say you want to reward players for doing taxi. Open up the qb-taxijob/server/main.lua and add this somewhere (maybe create another chance, like the code for crypto sticks at line ~25)
```
TriggerEvent('cw-tokens:server:GiveBuyToken', src, 'tradeSandwich')

```
This will give the player a token that has the value tradeSandwich-buy-token (the suffix is changeable in the Config.Lua if you don't like it). The player can now go to the token trader and get the Sandwich Trade Token!
## Creating your own 

# Add to qb-core ❗
Items to add to qb-core>shared>items.lua 
```
	-- CW Token
	["cw_token"] =          {["name"] = "cw_token",         ["label"] = "Token (filled)",                  ["weight"] = 1, ["type"] = "item", ["image"] = "cwtoken.png", ["unique"] = true, ["useable"] = false, ['shouldClose'] = false, ["combinable"] = nil, ["description"] = "Contains encrypted data"},
	["cw_token_empty"] =          {["name"] = "cw_token_empty",         ["label"] = "Token",                  ["weight"] = 1, ["type"] = "item", ["image"] = "cwtoken_empty.png", ["unique"] = false, ["useable"] = false, ['shouldClose'] = false, ["combinable"] = nil, ["description"] = "It's a container for encrypted data"},

```

## Making the names show up in to the Inventory 📦
If you want to make the token label show up in QB-Inventory:
Open `app.js` in `qb-inventory`. In the function `FormatItemInfo` you will find several if statements. Head to the bottom of these and add this before the second to last `else` statement (after the `else if` that has `itemData.name == "labkey"`). Then add this between them:
```
else if (itemData.name == "cw_token") {
    $(".item-info-title").html("<p>" + itemData.label + "</p>");
    if (itemData.info.label) {
        $(".item-info-description").html("<p>"+ itemData.info.label + "</p>");
    } else {
        $(".item-info-description").html("<p> Value: " + itemData.info.value + "</p>");
    }
``` 

Also make sure the images are in qb-inventory>html>images