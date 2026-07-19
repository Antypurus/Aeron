
local frame = CreateFrame("Frame", "PetHandleFrame")
frame:RegisterEvent("UNIT_PET")
frame:RegisterEvent("UNIT_HEALTH")
frame:RegisterEvent("UNIT_DIED")

local lastPetEvent = 0
local PET_EVENT_DEBOUNCE = 0.1 --100ms window

local hasPet = false
local firstUpdateDone = false
frame:SetScript("OnEvent", function(self, event, unit)
    if event == "UNIT_PET" then
        if unit == "player" then
            local currTime = GetTime()
            if (currTime - lastPetEvent) >= PET_EVENT_DEBOUNCE then

                if not hasPet then
                    hasPet = true
                    print("pet summoned")
                else
                    hasPet = false
                    print("pet dismissed")
                end

                lastPetEvent = currTime
            end
        end
    elseif event == "UNIT_DIED" then
        if unit == "player" then
            hasPet = false
        end
    elseif event == "UNIT_HEALTH" then
        print("PET IDK " .. unit)
    end

    if firstUpdateDone and not hasPet then
        print("you are missing your pet")
    end

    if UnitExists("pet") then
        print("You have your pet")
    end

    firstUpdateDone = true
end)
