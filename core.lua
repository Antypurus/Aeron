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

local frame = CreateFrame("Frame", "MyAddonFrame", UIParent)
frame:SetSize(200, 50)
frame:SetPoint("CENTER")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", function(self, button)
    self:StartMoving()
    print("Started Dragging ", button)
end)
frame:SetScript("OnDragStop", function(self, button)
    self:StopMovingOrSizing()
    print("Stopped Dragging")
end)

-- Background
local bg = frame:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints()
bg:SetColorTexture(0, 0, 0, 0.65)
-- Text
local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
text:SetPoint("CENTER")
text:SetText("Hello World")
frame:SetScript("OnUpdate", function(self, elapse)
    local fps = GetFramerate()
    text:SetText(math.floor(fps))
end)

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
