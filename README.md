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