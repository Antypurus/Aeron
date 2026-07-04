function DumpPlayerSpellList()
    for i = 1, C_SpellBook.GetNumSpellBookSkillLines() do
        local skillLineInfo = C_SpellBook.GetSpellBookSkillLineInfo(i)
        print(i .. " -> " .. skillLineInfo.name .. "(" .. skillLineInfo.numSpellBookItems .. ")")

        local offset = skillLineInfo.itemIndexOffset
        local spellCount = skillLineInfo.numSpellBookItems
        for j = offset + 1, offset + spellCount do
            local slotID = j
            local spellBookItemInfo = C_SpellBook.GetSpellBookItemInfo(slotID, Enum.SpellBookSpellBank.Player)
            print("\t" .. slotID .. "->" .. spellBookItemInfo.name)
        end
    end
end
