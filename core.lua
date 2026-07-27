local function SetActionButton(button, spellID)
    local spellInfo = C_Spell.GetSpellInfo(spellID)
    if spellInfo == nil then
        return
    end

    button.icon:SetTexture(spellInfo.iconID)
    button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    button:SetAttribute("type", "spell")
    button:SetAttribute("spell", spellInfo.name)

    SetBinding("ALT-K", nil)
    local assignResult = SetBindingClick("ALT-K", button:GetName())
    if assignResult == nil then
        print("failed to set keybinding")
    end

    print("action button is all setup")
end

local function FindActionSlot(spellID)
    for i = 1, 180 do
        local actionType, id = GetActionInfo(i)
        if actionType == "spell" and id == spellID then
            return i
        end
    end
    return nil
end

AeronDB = {
    msg = nil,
    savedSpellID = nil
}
AeronCharDB = {
}

rootFrame = CreateFrame("Frame")

rootFrame:RegisterEvent("PLAYER_REGEN_DISABLED") -- combat enter
rootFrame:RegisterEvent("PLAYER_REGEN_ENABLED")  -- leaving combat
rootFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
rootFrame:RegisterEvent("PLAYER_LOGIN")
rootFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
rootFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")

local mirrorActionButton = CreateFrame("Button", "AeronActionButton1", UIParent, "SecureActionButtonTemplate, BackdropTemplate")
local actionButton = CreateFrame("Button", "MyAddonFrame", UIParent, "SecureActionButtonTemplate, BackdropTemplate")

actionButton:SetSize(200, 200)
actionButton:SetPoint("CENTER")
actionButton:SetMovable(true)
actionButton:EnableMouse(true)
actionButton:RegisterForClicks("RightButtonDown")
actionButton:RegisterForDrag("LeftButton")
actionButton.cooldown = CreateFrame("Cooldown", nil, actionButton, "CooldownFrameTemplate")
actionButton.cooldown:SetAllPoints(actionButton)
actionButton.cooldown:SetDrawEdge(true)
actionButton.cooldown:SetDrawSwipe(true)
actionButton.cooldown:SetDrawBling(true)
actionButton.cooldown:SetHideCountdownNumbers(false)

actionButton:SetScript("OnDragStart", function()
    actionButton:StartMoving()
end)
actionButton:SetScript("OnDragStop", function()
    actionButton:StopMovingOrSizing()
end)

local savedSpellID = nil
rootFrame:SetScript("OnEvent", function(_, event, unit, castGUID, spellID)
    if event == "PLAYER_REGEN_DISABLED" then
        print("Entered Combat...")
    elseif event == "PLAYER_REGEN_ENABLED" then
        print("Left Combat...")
    end

    if event == "UNIT_SPELLCAST_SUCCEEDED" and unit == "player" then
        local spellName = C_Spell.GetSpellName(spellID)
        print(spellName .. " | " .. spellID)

        if spellID == 781 then
            print("!!!YOU CASTED DISENGAGE!!!")
        end
    end

    if event == "PLAYER_LOGIN" then
        if AeronDB.savedSpellID ~= nil then
            savedSpellID = AeronDB.savedSpellID
            SetActionButton(actionButton, AeronDB.savedSpellID)
        end
        C_ChatInfo.RegisterAddonMessagePrefix("aeron")
    end

    if event == "SPELL_UPDATE_COOLDOWN" then
        local actionSlot = FindActionSlot(savedSpellID)
        if actionSlot == nil then
            print("didnt find action slot for spell id: " .. savedSpellID)
            return
        end

        local spellCooldownDuration = C_ActionBar.GetActionCooldownDuration(actionSlot)
        if spellCooldownDuration then
            actionButton.cooldown:SetCooldownFromDurationObject(spellCooldownDuration)
        else
            actionButton.cooldown:Clear()
        end
    end

    if event == "ACTIONBAR_SLOT_CHANGED" then
        if unit == 1 then
            local mirrorTexture = GetActionTexture(1)
            if mirrorTexture == nil then
                print("Could not find texture")
            end
            mirrorActionButton.Icon:SetTexture(mirrorTexture)
        end
    end
end)

actionButton:SetScript('PostClick', function()
    C_ChatInfo.SendChatMessage("test_message", "AFK")
end)

-- Background
local bg = actionButton:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints()
bg:SetColorTexture(0, 0, 0, 0.65)
-- Text
local frame = CreateFrame("Frame", "MyNewTestFrame", UIParent)
local text = actionButton:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
text:SetPoint("CENTER")
text:SetText("Hello World")
frame:SetScript("OnUpdate", function(self, elapse)
    local fps = GetFramerate()
    text:SetText(math.floor(fps))
end)

local ButtonData = nil

actionButton.icon = bg
actionButton.spellID = nil
actionButton:SetScript("OnReceiveDrag", function(self)
    local type, spellIndex, bookType, spellID, baseSpellID = GetCursorInfo()
    print("Spellbook Index: " .. spellIndex)
    if type == "spell" and spellIndex and spellID then
        local spellIDObt = C_SpellBook.GetSpellBookItemInfo(spellIndex, Enum.SpellBookSpellBank.Player)
        if spellIDObt == nil then
            print("failed to get spell data from spellbook")
            DumpPlayerSpellList()
        end

        AeronDB.savedSpellID = spellID
        SetActionButton(self, spellID)
        ClearCursor()
    end
end)

SLASH_AERON1 = "/aeron"
SlashCmdList["AERON"] = function(msg)
    print(msg)
end


mirrorActionButton:SetSize(200, 200)
mirrorActionButton:SetPoint("CENTER")
mirrorActionButton:SetMovable(true)
mirrorActionButton:EnableMouse(true)
mirrorActionButton:RegisterForClicks("AnyDown")
mirrorActionButton:RegisterForDrag("LeftButton")
mirrorActionButton:SetAttribute("type", "action")
mirrorActionButton:SetAttribute("action", 1)

mirrorActionButton:SetBackdrop({
    bgFile   = "Interface/Buttons/WHITE8X8",
    edgeFile = "Interface/Buttons/WHITE8X8",
    edgeSize = 1,
})
mirrorActionButton:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
mirrorActionButton:SetBackdropBorderColor(0, 0, 0, 1)

local mirrorTexture = GetActionTexture(1)
if mirrorTexture == nil then
    print("Could not find texture")
end
mirrorActionButton.Icon = mirrorActionButton:CreateTexture(nil, "ARTWORK")
mirrorActionButton.Icon:SetAllPoints()
mirrorActionButton.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
mirrorActionButton.Icon:SetTexture(mirrorTexture)



--local button = CreateFrame("Button", "TestButton", frame, "UIPanelButtonTemplate")
--button:SetText("test")
--button:SetSize(100, 20)
--button:SetPoint("BOTTOM")
--button:SetFrameLevel(frame:GetFrameLevel() + 10)

--[[
-- widget scripts
frame:SetScript("OnEnter", function()
    GameTooltip:SetOwner(frame, "ANCHOR_TOPRIGHT")
    GameTooltip:AddLine("HelloWorld!")
    GameTooltip:Show()
end)
frame:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

-- adding a texture
local texture = frame:CreateTexture(nil, "BACKGROUND")
texture:SetTexture("interface\\icons\\inv_mushroom_11")
texture:SetAllPoints()
--]]
