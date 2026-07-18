function DeepDump(label, value)
    print("=== " .. tostring(label) .. " ===")
    print("type: " .. type(value))

    -- dump the value itself
    print("-- value --")
    DevTools_Dump(value)

    -- if it has a metatable, dump that too
    local mt = getmetatable(value)
    if mt then
        print("-- metatable --")
        DevTools_Dump(mt)

        -- if __index is a table, dump it separately
        if mt.__index and type(mt.__index) == "table" then
            print("-- __index methods --")
            local methods = {}
            for k, v in pairs(mt.__index) do
                table.insert(methods, tostring(k) .. " [" .. type(v) .. "]")
            end
            table.sort(methods)
            for _, m in ipairs(methods) do
                print(m)
            end
        end
    end

    -- if it's a table, also iterate it directly
    if type(value) == "table" then
        print("-- raw table keys --")
        for k, v in pairs(value) do
            print(tostring(k) .. " = " .. tostring(v))
        end
    end

    print("=== end " .. tostring(label) .. " ===")
end
