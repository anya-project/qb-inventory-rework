<!-- Banner / Cover Image -->
<p align="center">
    <img width="300" src="https://i.imgur.com/JaOJmKS.png" />

---

> ⚠️ **Note:** This description is not always up to date.  
> Many new improvements and features have been added, so the information below may not be fully accurate.  
> For the latest and most accurate updates, please join our **[Official Discord](https://discord.gg/HMMYNPEXGY)** — all recent changes and announcements are posted there.

---

## 🌐 Connect with Us

<p align="center">
  <a href="https://discord.gg/HMMYNPEXGY"><img src="https://img.shields.io/badge/Discord-%237289DA.svg?style=for-the-badge&logo=discord&logoColor=white"/></a>
  <a href="https://ko-fi.com/H2H51HUE4X"><img src="https://ko-fi.com/img/githubbutton_sm.svg"/></a>
</p>

## [QB INVENTORY REWORK] a modern, feature-rich, and optimized inventory system for the QBCore Framework.

![Inventory Showcase](https://i.imgur.com/gCWzI8h.png)
![Inventory Showcase](https://i.imgur.com/NUgPvCy.png)

---

## 📜 Description

QB Inventory Rework is a complete replacement for the default QBCore inventory, designed to provide a more immersive and functional experience for players.

---

## ✨ Core Features

- Cash as an item
- New give system
- Rob Player
- Decay system for food & drinks
- Weapon attachment panel
- New 2-panel UI layout
- Toggle blur effect
- Per-player max weight override (via `metadata.maxweight`, for VIP/inventory-upgrade perks)
- Self-hosted UI assets — no external CDN calls (fonts, icons, Vue, etc. are all bundled in `html/lib/`)
- Code modifications for optimization & security

---

[**Join the Official AP Code Discord**](https://discord.gg/HMMYNPEXGY)

## 📦 Dependencies

Ensure you have the following resources installed and running before installing qb-Inventory rework :

- [**qb-core**](https://github.com/qbcore-framework/qb-core)

---

## 🛠️ Installation

Follow these steps **very carefully** to ensure a smooth installation.

### Step 1: Download & Place the Resource

1.  Download this resource's files
2.  Rename qb-inventory-rework to qb-inventory
3.  delete your old inventory and replace with `qb-inventory` rework

### Step 2: Modify `qb-core`

**🚨 IMPORTANT: Always create a backup of any file you are about to edit!**

You need to edit the `qb-core/server/player.lua` file to integrate the money-as-an-item system.

> ⚠️ **Before you copy-paste anything below**: not every `qb-core` build is structured the same way. Open `qb-core/server/player.lua` and check how `AddMoney` / `RemoveMoney` / `SetMoney` / `GetMoney` are actually defined:
>
> - **Vanilla-style** — assigned inside `Player.new(...)` as `self.Functions.AddMoney = function(...) ... end`. Use **Variant A** below.
> - **Class-style** — defined outside as standalone methods with colon syntax: `function Player:AddMoney(moneytype, amount, reason)`, and `self.Functions.AddMoney` is auto-generated later by wrapping the class method. Use **Variant B** below.
>
> Picking the wrong variant will either fail to compile or silently never trigger (because your `qb-core` never calls the function you edited). If you're not sure, search the file for the literal string `self.Functions.AddMoney = function` — if it's there, you're vanilla-style; if instead you find `function Player:AddMoney`, you're class-style.
> Also: if your `qb-core` fork has extra custom logic in these functions (VIP perks, custom logging, etc.), don't blindly delete-and-replace — merge the cash-as-item branch in on top of your existing code instead, the way it's done in the two variants below.

#### A. Replace Money Management Functions

##### Variant A — Vanilla-style (`self.Functions.X = function...`)

Open `qb-core/server/player.lua` and find the following functions:

- `self.Functions.AddMoney`
- `self.Functions.RemoveMoney`
- `self.Functions.SetMoney`
- `self.Functions.GetMoney`

Delete all four of these functions entirely and replace them with the code block below:

```lua
--------------------------EDITED BY APCODE START--------------------------
    function self.Functions.AddMoney(moneytype, amount, reason)
    reason = reason or 'unknown'
    moneytype = moneytype:lower()
    amount = tonumber(amount)
    if amount < 0 then return end
    if not self.PlayerData.money[moneytype] then return false end

    if moneytype == 'cash' and GetResourceState('qb-inventory') ~= 'missing' and exports['qb-inventory']:IsCashAsItem() then
        if exports['qb-inventory']:AddCash(self.PlayerData.source, amount) then
            local newCashAmount = exports['qb-inventory']:GetItemCount(self.PlayerData.source, 'cash') or 0
            self.PlayerData.money.cash = newCashAmount
            if not self.Offline then
                self.Functions.UpdatePlayerData()
                if amount > 100000 then
                    TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'AddMoney (as item)', 'lightgreen', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (cash) added, reason: ' .. reason, true)
                else
                    TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'AddMoney (as item)', 'lightgreen', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (cash) added, reason: ' .. reason)
                end
                TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, false)
                TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'add', reason)
                TriggerEvent('QBCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'add', reason)
            end
            return true
        else
            return false
        end
    end

    self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] + amount
    if not self.Offline then
        self.Functions.UpdatePlayerData()
        if amount > 100000 then
            TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') added, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason, true)
        else
            TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') added, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
        end
        TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, false)
        TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'add', reason)
        TriggerEvent('QBCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'add', reason)
    end
    return true
end

    function self.Functions.RemoveMoney(moneytype, amount, reason)
    reason = reason or 'unknown'
    moneytype = moneytype:lower()
    amount = tonumber(amount)
    if amount < 0 then return end
    if not self.PlayerData.money[moneytype] then return false end

    if moneytype == 'cash' and GetResourceState('qb-inventory') ~= 'missing' and exports['qb-inventory']:IsCashAsItem() then
        if exports['qb-inventory']:RemoveCash(self.PlayerData.source, amount, reason) then
            local newCashAmount = exports['qb-inventory']:GetItemCount(self.PlayerData.source, 'cash') or 0
            self.PlayerData.money.cash = newCashAmount
            if not self.Offline then
                self.Functions.UpdatePlayerData()
                if amount > 100000 then
                    TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'RemoveMoney (as item)', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (cash) removed, reason: ' .. reason, true)
                else
                    TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'RemoveMoney (as item)', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (cash) removed, reason: ' .. reason)
                end
                TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, true)
                TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'remove', reason)
                TriggerEvent('QBCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'remove', reason)
            end
            return true
        else
            return false
        end
    end

    for _, mtype in pairs(QBCore.Config.Money.DontAllowMinus) do
        if mtype == moneytype then
            if (self.PlayerData.money[moneytype] - amount) < 0 then
                return false
            end
        end
    end
    if self.PlayerData.money[moneytype] - amount < QBCore.Config.Money.MinusLimit then
        return false
    end
    self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount
    if not self.Offline then
        self.Functions.UpdatePlayerData()
        if amount > 100000 then
            TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') removed, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason, true)
        else
            TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') removed, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
        end
        TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, true)
        if moneytype == 'bank' then
            TriggerClientEvent('qb-phone:client:RemoveBankMoney', self.PlayerData.source, amount)
        end
        TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'remove', reason)
        TriggerEvent('QBCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'remove', reason)
    end
    return true
end

    function self.Functions.SetMoney(moneytype, amount, reason)
    reason = reason or 'unknown'
    moneytype = moneytype:lower()
    amount = tonumber(amount)
    if amount < 0 then return false end
    if not self.PlayerData.money[moneytype] then return false end

    if moneytype == 'cash' and GetResourceState('qb-inventory') ~= 'missing' and exports['qb-inventory']:IsCashAsItem() then
        local currentCash = exports['qb-inventory']:GetItemCount(self.PlayerData.source, 'cash') or 0
        local difference = amount - currentCash
        local success = false
        if difference > 0 then
            success = exports['qb-inventory']:AddItem(self.PlayerData.source, 'cash', difference, nil, {}, 'setmoney_command')
        elseif difference < 0 then
            success = exports['qb-inventory']:RemoveItem(self.PlayerData.source, 'cash', math.abs(difference), nil, 'setmoney_command')
        else
            success = true
        end
        if success then
            local newTotalCash = exports['qb-inventory']:GetItemCount(self.PlayerData.source, 'cash') or 0
            self.PlayerData.money.cash = newTotalCash
            if not self.Offline then
                self.Functions.UpdatePlayerData()
                local difference = newTotalCash - (currentCash or 0)
                TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'SetMoney (as item)', 'green', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** cash set to $' .. newTotalCash .. ', reason: ' .. reason)
                TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, math.abs(difference), difference < 0)
                TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, newTotalCash, 'set', reason)
                TriggerEvent('QBCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, newTotalCash, 'set', reason)
                TriggerClientEvent('qb-inventory:client:updateCash', self.PlayerData.source, newTotalCash)
            end
        end
        return success
    end

    local difference = amount - self.PlayerData.money[moneytype]
    self.PlayerData.money[moneytype] = amount
    if not self.Offline then
        self.Functions.UpdatePlayerData()
        TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'SetMoney', 'green', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') set, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
        TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, math.abs(difference), difference < 0)
        TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'set', reason)
        TriggerEvent('QBCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'set', reason)
    end
    return true
end

    function self.Functions.GetMoney(moneytype)
    if not moneytype then return false end
    moneytype = moneytype:lower()

    if moneytype == 'cash' and GetResourceState('qb-inventory') ~= 'missing' and exports['qb-inventory']:IsCashAsItem() then
        local cashCount = exports['qb-inventory']:GetItemCount(self.PlayerData.source, 'cash') or 0
        if self.PlayerData.money.cash ~= cashCount then
            self.PlayerData.money.cash = cashCount
        end
        return cashCount
    end

    return self.PlayerData.money[moneytype]
end
-----------------------------EDITED BY APCODE END--------------------------
```

##### Variant B — Class-style (`function Player:AddMoney(...)`)

Some `qb-core` forks define these as real methods on a `Player` class/metatable (colon syntax), with `self.Functions.AddMoney` etc. auto-generated later by wrapping the class method. If that's what you found in the check above, edit the class methods directly instead — do **not** touch `self.Functions` for this variant.

Find `function Player:AddMoney(moneytype, amount, reason)` and insert the cash-as-item branch right after the existing `nil`/negative-amount guard clauses (before the function does its normal balance math). Do the same for `RemoveMoney`, `SetMoney`, and `GetMoney`:

```lua
--------------------------EDITED BY APCODE START--------------------------
function Player:AddMoney(moneytype, amount, reason)
    -- ...keep your existing guard clauses above this line...

    if moneytype == 'cash' and GetResourceState('qb-inventory') ~= 'missing' and exports['qb-inventory']:IsCashAsItem() then
        if not exports['qb-inventory']:AddCash(self.PlayerData.source, amount, reason) then return false end
        self.PlayerData.money.cash = exports['qb-inventory']:GetItemCount(self.PlayerData.source, 'cash') or 0
        if not self.Offline then
            self:UpdateClient('money', self.PlayerData.money)
            TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'AddMoney (as item)', 'lightgreen', '**' .. self.PlayerData.name .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (cash) added, reason: ' .. reason, amount > 100000)
            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, false)
            TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'add', reason)
            TriggerEvent('QBCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'add', reason)
        end
        return true
    end

    -- ...your existing balance-update code continues unchanged below...
end

function Player:RemoveMoney(moneytype, amount, reason)
    -- ...keep your existing guard clauses above this line...

    if moneytype == 'cash' and GetResourceState('qb-inventory') ~= 'missing' and exports['qb-inventory']:IsCashAsItem() then
        if not exports['qb-inventory']:RemoveCash(self.PlayerData.source, amount, reason) then return false end
        self.PlayerData.money.cash = exports['qb-inventory']:GetItemCount(self.PlayerData.source, 'cash') or 0
        if not self.Offline then
            self:UpdateClient('money', self.PlayerData.money)
            TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'RemoveMoney (as item)', 'red', '**' .. self.PlayerData.name .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (cash) removed, reason: ' .. reason, amount > 100000)
            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, true)
            TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'remove', reason)
            TriggerEvent('QBCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'remove', reason)
        end
        return true
    end

    -- ...your existing DontAllowMinus / balance-update code continues unchanged below...
end

function Player:SetMoney(moneytype, amount, reason)
    -- ...keep your existing guard clauses above this line...

    if moneytype == 'cash' and GetResourceState('qb-inventory') ~= 'missing' and exports['qb-inventory']:IsCashAsItem() then
        local currentCash = exports['qb-inventory']:GetItemCount(self.PlayerData.source, 'cash') or 0
        local difference  = amount - currentCash
        local success     = true
        if difference > 0 then
            success = exports['qb-inventory']:AddItem(self.PlayerData.source, 'cash', difference, nil, {}, 'setmoney_command')
        elseif difference < 0 then
            success = exports['qb-inventory']:RemoveItem(self.PlayerData.source, 'cash', math.abs(difference), nil, 'setmoney_command')
        end
        if not success then return false end
        local newTotalCash = exports['qb-inventory']:GetItemCount(self.PlayerData.source, 'cash') or 0
        self.PlayerData.money.cash = newTotalCash
        if not self.Offline then
            self:UpdateClient('money', self.PlayerData.money)
            TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'SetMoney (as item)', 'green', '**' .. self.PlayerData.name .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** cash set to $' .. newTotalCash .. ', reason: ' .. reason)
            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, math.abs(difference), difference < 0)
            TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, newTotalCash, 'set', reason)
            TriggerEvent('QBCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, newTotalCash, 'set', reason)
        end
        return true
    end

    -- ...your existing balance-set code continues unchanged below...
end

function Player:GetMoney(moneytype)
    if not moneytype then return false end
    moneytype = moneytype:lower()

    if moneytype == 'cash' and GetResourceState('qb-inventory') ~= 'missing' and exports['qb-inventory']:IsCashAsItem() then
        local cashCount = exports['qb-inventory']:GetItemCount(self.PlayerData.source, 'cash') or 0
        if self.PlayerData.money.cash ~= cashCount then
            self.PlayerData.money.cash = cashCount
        end
        return cashCount
    end

    return self.PlayerData.money[moneytype]
end
--------------------------EDITED BY APCODE END--------------------------
```

#### B. Update the `CheckPlayerData` Function

Still in `qb-core/server/player.lua`, find the function `QBCore.Player.CheckPlayerData`. **Do not delete the whole function** — some forks add their own logic in there (job default-duty handling, custom defaults, etc.), and wiping it out will silently regress those features. Instead, find the block that loads the inventory. It will look something like this:

```lua
if GetResourceState('qb-inventory') ~= 'missing' then
    PlayerData.items = exports['qb-inventory']:LoadInventory(PlayerData.source, PlayerData.citizenid)
end
```

(it may be gated with an extra `not Offline and ...` condition too — keep whatever guard your version already has) and insert the cash sync right after the `LoadInventory` line, inside the same `if` block:

```lua
--------------------------EDITED BY APCODE START--------------------------
if GetResourceState('qb-inventory') ~= 'missing' then
    PlayerData.items = exports['qb-inventory']:LoadInventory(PlayerData.source, PlayerData.citizenid)
    if exports['qb-inventory']:IsCashAsItem() then
        local cashInInventory = 0
        if PlayerData.items then
            for _, item in pairs(PlayerData.items) do
                if item and item.name == 'cash' then
                    cashInInventory = cashInInventory + item.amount
                end
            end
        end
        PlayerData.money.cash = cashInInventory
    end
end
--------------------------EDITED BY APCODE END--------------------------
```

This ensures the player's inventory — and their synced cash balance — is loaded correctly when they join the server.

### Step 3: Add Cash Item to `qb-core/shared/items.lua`

```lua
['cash'] = {
    name = 'cash',
    label = 'Cash',
    weight = 0,
    type = 'item',
    image = 'cash.png',
    unique = false,
    useable = false,
    shouldClose = false,
    description = 'Don\'t spend it all in one place.'
},
```

### Step 4: Add Decay Rate to Food and Drinks

To make food and drinks perishable, you need to add a decay rate to them.
Open qb-core/shared/items.lua and for every food and drink item, add the following line inside its definition:

`decayrate = 86400.0`

EXAMPLE :

```lua
['sandwich'] = {
    name = 'sandwich',
    label = 'Sandwich',
    weight = 200,
    type = 'item',
    image = 'sandwich.png',
    unique = false,
    useable = true,
    shouldClose = true,
    description = 'Nice bread for your stomach',
    decayrate = 86400.0
},
```

If you encounter any issues, require assistance, or wish to suggest new features, please join our official Discord server. We're here to help!

[**Join the Official AP Code Discord**](https://discord.gg/HMMYNPEXGY)

## ⚙️ Configuration

All major configuration options can be found in the `config.lua` file. You can adjust:

- The default keybind to open the inventory.
- Maximum weight and slot counts.
- Storage sizes for trunks, gloveboxes, and drops.
- Items sold in Vending Machines.
- And much more.

---

## Special thanks to the QBCore community for their support and inspiration.
