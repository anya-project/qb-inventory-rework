## 🌐 Connect with Us

<p align="center">
  <a href="https://discord.gg/HMMYNPEXGY"><img src="https://img.shields.io/badge/Discord-%237289DA.svg?style=for-the-badge&logo=discord&logoColor=white"/></a>
</p>

## [QB INVENTORY REWORK] a modern, feature-rich, and optimized inventory system for the QBCore Framework.

![Inventory Showcase](https://i.imgur.com/gCWzI8h.png)
![Inventory Showcase](https://i.imgur.com/NUgPvCy.png)

---

## 📜 Description

QB Inventory Rework is a complete replacement for the default QBCore inventory, designed to provide a more immersive and functional experience for players.

---

## ✨ Features

### Inventory & Items
- **New 2-panel UI layout** with a redesigned give system, drag-and-drop, and a dedicated weapon attachment panel.
- **Decay system** — food & drink items can expire over time (`decayrate` on the item definition), so stockpiling perishables isn't free.
- **Rob Player** — search/rob another player's inventory and cash.
- **Toggle blur effect** on the background while the inventory is open.
- **Stacked notifications** — multiple item-gain/loss toasts can show at once instead of one replacing the other.
- **Nearby-player names use real character names** (`charinfo`), not the player's Rockstar/Steam name, when giving items to someone near you.
- **Image fallback** — if an item's `.png` icon fails to load, the UI retries with a `.webp` of the same name before giving up (requires you to actually add a matching `.webp` file — see Configuration).

### Money & Economy
- **Cash as an item** — physical, robbable `cash` item instead of (or alongside) the `money.cash` account balance. Off by default; see Installation Step 2 to wire it into `qb-core`.

### Vehicles
- **Per-vehicle-model trunk/glovebox capacity** (`VehicleStorage.byModel`) with a sane class-based fallback (`VehicleStorage[class]` / `VehicleStorage.default`) covering all 22 GTA vehicle classes.
- **Per-vehicle trunk interaction distance** (`TrunkDistances`) — useful for larger vehicles where the default 5m radius doesn't reach the trunk.

### Player Weight
- **Per-player max carry weight override** via `metadata.maxweight` — lets you grant individual players (VIP tiers, inventory upgrades, job perks, etc.) more or less carry capacity than `Config.MaxWeight`, enforced consistently on both the server (all add/remove/weight checks) and the client UI.
- **`/setmaxweight [id] [weight]`** admin command to set or reset that override without needing a separate script (see Admin Commands below).

### Technical
- **Self-hosted UI assets** — fonts, icons, Vue, and other UI libraries are bundled in `html/lib/`, so the NUI no longer depends on external CDNs (Google Fonts, unpkg, cdnjs, etc.) at runtime.
- **Legacy compatibility bridge** (`server/compat.lua`) — listens for the older `inventory:server:OpenInventory`, `QBCore:Server:AddItem`, `QBCore:Server:RemoveItem` events and the `QBCore:Server:HasItem` callback, and routes them to this inventory's exports. This exists purely for interop with third-party scripts that still use those older, event-based APIs instead of exports — if nothing in your server uses those events, it simply sits idle.
- Code modifications for optimization & security.

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

You need to edit the `qb-core/server/player.lua` file to integrate the money-as-an-item system. This only enables the money side of it — `Config.CashAsItem` in `config/config.lua` must also be set to `true`, or none of this branch ever runs (see Configuration).

#### A. Add the Cash-as-Item Branch to the Money Functions

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

Only needed if you're enabling cash-as-item (Step 2 + `Config.CashAsItem = true`).

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
Open `qb-core/shared/items.lua` and for every food and drink item, add the following line inside its definition:

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

All major configuration options can be found in `config/config.lua` and `config/vehicles.lua`. You can adjust:

- `CashAsItem` / `CustomHUD` — toggle cash-as-item mode (requires Step 2 & 3 above) and an optional third-party HUD integration.
- Default keybind to open the inventory, and hotbar keybind.
- Maximum weight and slot counts (`Config.MaxWeight` / `Config.MaxSlots`) — the default for all players; override per-player via `metadata.maxweight` (see Admin Commands).
- Storage sizes for stashes and drops (`Config.StashSize` / `Config.DropSize`).
- `VehicleStorage` in `config/vehicles.lua` — trunk/glovebox slots & weight per vehicle model or class, plus `TrunkDistances` for per-vehicle interaction range.
- Items sold in Vending Machines.
- To use the `.webp` image fallback, drop a same-named `.webp` file next to the item's `.png` in `html/images/` — no code changes needed.

## 🛡️ Admin Commands

| Command | Permission | Description |
|---|---|---|
| `/giveitem [id] [item] [amount]` | admin | Spawn an item into a player's inventory. |
| `/clearinv [id]` | admin | Clear a player's inventory (or your own if `id` is omitted). |
| `/setmaxweight [id] [weight]` | admin | Set a player's custom max carry weight in grams, or omit the weight (or pass `reset`) to clear the override and fall back to `Config.MaxWeight`. |
| `/randomitems` | god | Give the caller 10 random non-weapon items — useful for testing. |

---

## Special thanks to the QBCore community for their support and inspiration.
