Ids = Ids or {}
if not Ids.CreateUniqueId then
    function Ids.CreateUniqueId(tbl, len, pattern)
        tbl = tbl or {}
        len = len or 8
        local id = ""
        for i = 1, len do
            if pattern and #pattern > 0 then
                local charIndex = math.random(1, #pattern)
                id = id .. pattern:sub(charIndex, charIndex)
            else
                id = id .. (math.random(1, 2) == 1 and string.char(math.random(65, 90)) or string.format("%d", math.random(0, 9)))
            end
        end
        if tbl[id] then return Ids.CreateUniqueId(tbl, len, pattern) end
        return id
    end
end
if not Ids.RandomString then
    function Ids.RandomString(tbl, len)
        return Ids.CreateUniqueId(tbl or {}, len or 8, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    end
end
if not Ids.RandomNumber then
    function Ids.RandomNumber(tbl, len)
        return Ids.CreateUniqueId(tbl or {}, len or 6, "0123456789")
    end
end

Table = Table or {}
if not Table.CheckPopulated then
    function Table.CheckPopulated(tbl)
        if type(tbl) ~= "table" then return false end
        if #tbl > 0 then return true end
        for _ in pairs(tbl) do return true end
        return false
    end
end
