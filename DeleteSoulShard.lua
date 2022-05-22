local _, NS = ...

SLASH_DSS1 = "/dss"

local YELLOW = "FFFF00"

--[[
returns the input msg with escape sequences applied to add color to it in the UI
@param msg - the input string
@param color - the color to apply in hex format RRGGBB
]]--
local function colorize(msg, color)
    return "|cFF"..color..msg.."|r"
end

--[[
returns usage string
]]--
local function getUsageString()
    local cmd = "/dss"
    local usage = colorize("DeleteSoulShard Usage: ", YELLOW)..cmd.." <numOfShards>\n"
    return usage
end

--[[
takes an input string and splits it into an array based on whitespace between characters
@returns array
]]--
local function tokenize(input)
    local tokens = {}
    local i = 1
    for token in string.gmatch(input, "%S+") do
        tokens[i] = token
        i = i + 1
    end
    return tokens
end

SlashCmdList["DSS"] = function(msg, editBox)
    local tokens = tokenize(msg)
    local tokenCount = table.maxn(tokens)

    if (tokenCount < 1) then
        editBox.chatFrame:AddMessage(getUsageString())
        return false
    end

    local toDelete = tonumber(tokens[1])
    if (toDelete == nil or toDelete < 1) then
        editBox.chatFrame:AddMessage(getUsageString())
        return false
    end

    ClearCursor()
    local deleted = 0
    local breakOuter = false
    for bagId = 0, NUM_BAG_SLOTS, 1 do
        local bagSize = GetContainerNumSlots(bagId)
        for bagSlotId = 1, bagSize, 1 do
            local texture, count, locked, quality, readable, lootable, _, isFiltered, hasNoValue, itemID = GetContainerItemInfo(bagId, bagSlotId)
            if (itemID) then
                local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemID)
                if (name == "Soul Shard") then
                    editBox.chatFrame:AddMessage("Deleting shard from bag "..bagId.." slot "..bagSlotId)
                    PickupContainerItem(bagId, bagSlotId)
                    DeleteCursorItem()
                    deleted = deleted + 1
                end
            end

            if (deleted >= tonumber(tokens[1])) then
                breakOuter = true
                break
            end
        end

        if (breakOuter) then
            break
        end
    end

    editBox.chatFrame:AddMessage("Deleted "..deleted.."  shard(s)")
end

print(getUsageString())
