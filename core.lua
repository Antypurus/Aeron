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

local rootFrame = CreateFrame("Frame")

rootFrame:RegisterEvent("PLAYER_REGEN_DISABLED") -- combat enter
rootFrame:RegisterEvent("PLAYER_REGEN_ENABLED")  -- leaving combat
rootFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
rootFrame:RegisterEvent("PLAYER_LOGIN")
rootFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")

local actionButton = CreateFrame("Button", "MyAddonFrame", UIParent, "SecureActionButtonTemplate, BackdropTemplate")
actionButton:SetSize(200, 200)
actionButton:SetPoint("CENTER")
actionButton:SetMovable(true)
actionButton:EnableMouse(true)
actionButton:RegisterForClicks("AnyDown")
actionButton:RegisterForDrag("LeftButton")
actionButton.cooldown = CreateFrame("Cooldown", nil, actionButton, "CooldownFrameTemplate")
actionButton.cooldown:SetAllPoints(actionButton)
actionButton.cooldown:SetDrawEdge(true)
actionButton.cooldown:SetDrawSwipe(true)
actionButton.cooldown:SetDrawBling(true)
actionButton.cooldown:SetHideCountdownNumbers(false)

local savedSpellID = nil
rootFrame:SetScript("OnEvent", function(_, event, unit, castGUID, spellID)
    if event == "PLAYER_REGEN_DISABLED" then
        print("Entered Combat...")
    elseif event == "PLAYER_REGEN_ENABLED" then
        print("Left Combat...")
    end

    if event == "UNIT_SPELLCAST_SUCCEEDED" and unit == "player" then
        local spellName = C_Spell.GetSpellName(spellID)
        print(spellName)
    end

    if event == "PLAYER_LOGIN" then
        if AeronDB.msg ~= nil then
            print(AeronDB.msg)
        end
        if AeronDB.savedSpellID ~= nil then
            savedSpellID = AeronDB.savedSpellID
            SetActionButton(actionButton, AeronDB.savedSpellID)
        end
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
end)

-- Background
local bg = actionButton:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints()
bg:SetColorTexture(0, 0, 0, 0.65)
-- Text
local text = actionButton:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
text:SetPoint("CENTER")
--text:SetText("Hello World")
--frame:SetScript("OnUpdate", function(self, elapse)
--local fps = GetFramerate()
--text:SetText(math.floor(fps))
--end)

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

SLASH_SUGMA1 = "/sugma"
SlashCmdList["SUGMA"] = function(msg)
    print(msg)
    AeronDB.msg = msg
end


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
