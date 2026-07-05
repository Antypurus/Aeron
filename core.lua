local f = CreateFrame("Frame")

f:RegisterEvent("PLAYER_REGEN_DISABLED") -- combat enter
f:RegisterEvent("PLAYER_REGEN_ENABLED")  -- leaving combat
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

f:SetScript("OnEvent", function(_, event, unit, castGUID, spellID)
    if event == "PLAYER_REGEN_DISABLED" then
        print("Entered Combat...")
    elseif event == "PLAYER_REGEN_ENABLED" then
        print("Left Combat...")
    end

    if event == "UNIT_SPELLCAST_SUCCEEDED" and unit == "player" then
        local spellName = C_Spell.GetSpellName(spellID)
        print(spellName)
    end
end)

local frame = CreateFrame("Button", "MyAddonFrame", UIParent, "SecureActionButtonTemplate, BackdropTemplate")
frame:SetSize(200, 200)
frame:SetPoint("CENTER")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForClicks("AnyDown")
frame:RegisterForDrag("LeftButton")

-- Background
local bg = frame:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints()
bg:SetColorTexture(0, 0, 0, 0.65)
-- Text
local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
text:SetPoint("CENTER")
--text:SetText("Hello World")
--frame:SetScript("OnUpdate", function(self, elapse)
--local fps = GetFramerate()
--text:SetText(math.floor(fps))
--end)

local ButtonData = nil

frame.icon = bg
frame.spellID = nil
frame:SetScript("OnReceiveDrag", function(self)
    local type, spellIndex, bookType, spellID, baseSpellID = GetCursorInfo()
    print("Spellbook Index: " .. spellIndex)
    if type == "spell" and spellIndex and spellID then
        local spellIDObt = C_SpellBook.GetSpellBookItemInfo(spellIndex, Enum.SpellBookSpellBank.Player)
        if spellIDObt then
            print(spellIDObt.name)
        else
            print("failed to get spell data from spellbook")
            DumpPlayerSpellList()
        end

        local spellInfo = C_Spell.GetSpellInfo(spellID)
        if spellInfo then
            print(spellInfo.name)

            print(spellInfo.iconID)
            ButtonData = spellID
            self.icon:SetTexture(spellInfo.iconID)
            self.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

            self:SetAttribute("type", "spell")
            self:SetAttribute("spell", spellInfo.name)

            ClearCursor()
        end
    end
end)
frame:SetScript("PostClick", function(self, button)
    print("Button press fired", ButtonData)
    print(issecurevariable("MyAddonFrame"))
end)

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
