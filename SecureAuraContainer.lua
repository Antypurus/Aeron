-- create the container

local function createButton(button)
    addon:AddBackdrop(button)

    button:SetSize(36, 36)
    button:SetCancelAuraButtons('RightButtonUp')

    local Icon = addon.widgetMixin.CreateIcon(button, 'ARTWORK')
    Icon:SetAllPoints()
    button:SetIcon(Icon)

    local Count = addon.widgetMixin.CreateText(button)
    Count:SetPoint('CENTER', button, 'BOTTOM')
    Count:SetJustifyH('CENTER')
    button:SetApplicationCount(Count)

    local Time = addon.widgetMixin.CreateText(button, 13)
    Time:SetPoint('TOPLEFT', 1, -1)
    Time:SetJustifyH('LEFT')
    button:SetDurationText(Time, timeOptions)
end

local once = true
local container = nil
if (true) then
    container = CreateFrame("AuraContainer", nil, UIParent, "CustomAuraContainerTemplate")
    container:SetPoint("CENTER")
    container:AddAuraGroup(container:GetDebugName(), "HELPFUL", {
        maxFrameCount = 10,
        sortMethod = AuraContainerSortMethod.Default,
        sortDirection = AuraContainerSortDirection.Reverse,
        layout = {
            elementSpacingX = 5,
            elementSpacingY = 5,
            gapX = 5, -- only necessary because of bug with item enchantments
            gapY = 5,
        },
        candidateFilters = {
            includeSpellIDs = {
                [111400] = true,
                [205180] = true,
            }
        },
        initializeFrame = function(auraButton)
            if once then
                print("initialized secure frame")
                once = false
            end

            auraButton:SetSize(50, 50)

            auraButton.Icon = auraButton:CreateTexture(nil, "ARTWORK")
            auraButton.Icon:SetAllPoints(auraButton)
            auraButton.Icon:SetSize(50, 50)
            auraButton.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            auraButton:SetIcon(auraButton.Icon)

            auraButton.cooldown = CreateFrame("Cooldown", nil, auraButton, "CooldownFrameTemplate")
            auraButton.cooldown:SetAllPoints(auraButton)
            auraButton:SetDurationCooldown(auraButton.cooldown)

            auraButton.borderHost = CreateFrame("Frame", nil, auraButton)
            auraButton.borderHost:SetAllPoints(auraButton)
            auraButton.borderHost:SetFrameLevel(auraButton.cooldown:GetFrameLevel() + 1)

            -- and border so neither the swipe nor the border can cover them.
            auraButton.stackCarrier = CreateFrame("Frame", nil, auraButton)
            auraButton.stackCarrier:SetAllPoints(auraButton)
            auraButton.stackCarrier:SetFrameLevel(auraButton.borderHost:GetFrameLevel() + 1)
            auraButton.stack = auraButton.stackCarrier:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            auraButton.duration = auraButton.stackCarrier:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            auraButton:SetApplicationCount(auraButton.stack, {})
        end
    })
    container:SetUnit("player")

    local soundFile1 = "Interface\\Addons\\Aeron\\Sounds\\Purple.ogg"
    local spellTest = 111400
    C_UnitAuras.AddAuraSound(Enum.UnitAuraSoundTrigger.Added ,{
            unitToken = "player",
            spellID = spellTest,
            soundFileName = soundFile1,
            outputChannel = "SFX",
    })
    C_UnitAuras.AddAuraSound(Enum.UnitAuraSoundTrigger.Removed ,{
            unitToken = "player",
            spellID = spellTest,
            soundFileName = soundFile1,
            outputChannel = "SFX",
    })

    --[[local AttributeHandler = CreateFrame('Frame', nil, nil, 'SecureHandlerStateTemplate')
    AttributeHandler:SetScript('OnAttributeChanged', function(self, attribute, value)
        if attribute == 'unit' and container:GetUnit() ~= value then
            container:SetUnit(value)
            container:UpdateAllAuras()
        end
    end)
    RegisterAttributeDriver(AttributeHandler, 'unit', '[vehicleui] vehicle; player')]]--
end
