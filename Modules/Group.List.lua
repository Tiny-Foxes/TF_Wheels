return function(Songs)

    local Groups = {}

    for _, v in ipairs(Songs) do
        local Add = true
        for _, v2 in ipairs(Groups) do
            if v2 == v[1]:GetGroupName() then
                Add = false
                break
            end
        end
        if Add then Groups[#Groups + 1] = v[1]:GetGroupName() end
    end

    local function compare(a, b)
        return ToLower(a) < ToLower(b)
    end

    table.sort(Groups, compare)

    return Groups
end
