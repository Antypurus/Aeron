local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function(self)
end)
for i = 1, C_AddOns.GetNumAddOns() do
    local addonInfo = C_AddOns.GetAddOnInfo(i)
    print(addonInfo)
end
