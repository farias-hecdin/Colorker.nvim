local M = {}

local function hexToString(num)
    local chars = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"}
    return chars[math.floor(num * 0.0625) + 1] .. chars[num % 16 + 1]
end

M.rgbToHex = function(r, g, b)
  return "#" .. hexToString(r) .. hexToString(g) .. hexToString(b)
end

return M
