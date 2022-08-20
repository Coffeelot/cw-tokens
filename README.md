# Token system 🔑
This script is used to add tokens that adds entrance to specific jobs and purchases.

# Developed by Coffeelot and Wuggie
[More scripts by us](https://github.com/stars/Coffeelot/lists/cw-scripts)  👈\
[Support, updates and script previews](https://discord.gg/FJY4mtjaKr) 👈

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