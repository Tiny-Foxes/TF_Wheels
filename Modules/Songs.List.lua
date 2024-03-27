return function(Songs, CurGroup)

    local SongsOut = {}

    for _, v in ipairs(Songs) do
        if CurGroup == v[1]:GetGroupName() then
        SongsOut[#SongsOut + 1] = v end
    end

    local function compare(a, b)
        return ToLower(a[1]:GetDisplayMainTitle()) < ToLower(b[1]:GetDisplayMainTitle())
    end

    table.sort(SongsOut, compare)

    return SongsOut
end
