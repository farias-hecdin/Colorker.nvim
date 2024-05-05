local M = {}
local vim = vim
local cph = require('CSSPluginHelpers')

--- INFO: config section

-- Options table with default values
M.options = {
  -- <number> Parent search limit (number of levels to search upwards)
  parent_search_limit = 5,
  -- <string> Name of the file to track (e.g. "main" for main.lua)
  filename_to_track = "main",
  -- <string> Pattern to search for variables containing "color"
  variable_pattern = "%-%-[-_%w]*color[-_%w]*",
  -- <string> Initial color for variables (in hexadecimal format, e.g. "#000000" for black)
  initial_variable_color = "#000000",
  -- <boolean> Indicates whether keymaps are disabled
  disable_keymaps = false,
}

--- INFO: init section

local colors_from_file = {}

M.setup = function(options)
  -- Merge the user-provided options with the default options
  M.options = vim.tbl_deep_extend("keep", options or {}, M.options)
  -- Enable keymap if they are not disableds
  if not M.options.disable_keymaps then
    local keymaps_opts = {buffer = 0, silent = true}
    -- Create the keymaps for the specified filetypes
    vim.api.nvim_create_autocmd('FileType', {
      desc = 'CSSVarHighlight keymaps',
      pattern = 'css',
      callback = function()
        vim.keymap.set('n', '<leader>ch', ":CSSVarHighlight<CR>", keymaps_opts)
      end,
    })
  end
end

--- Create a user command
vim.api.nvim_create_user_command("CSSVarHighlight", function(args)
  if #(args.fargs[1] or "") > 1 then
    args.fargs[1], args.fargs[2], args.fargs[3] = 1, args.fargs[1], args.fargs[2]
  end

  local attempt_limit = args.fargs[1] or M.options.parent_search_limit
  local fname = (args.fargs[2] or M.options.filename_to_track) .. ".css"
  local fdir = args.fargs[3] or nil

  M.get_colors_from_file(tonumber(attempt_limit), fname, fdir)
end, {desc = "Track the colors of the CSS variables", nargs = "*"})

--- Retrieves color values from a file and updates the mini.hipatterns plugin
M.get_colors_from_file = function(attempt_limit, fname, fdir)
  local fpath = cph.find_file(fname, fdir, 1, attempt_limit)
  if not fpath then
    vim.print("[CSSVarHighlight] Attempt limit reached. Operation cancelled.")
    return
  end

  local data = cph.get_css_attribute(fpath, M.options.variable_pattern)
  colors_from_file = M.convert_color(data)

  vim.cmd('lua MiniHipatterns.update()')
end

--- Converts color values in various formats to hex color
M.convert_color = function(data)
  local colors = {}

  for name, value in pairs(data) do
    if string.match(value, "%#%w%w%w%w%w%w") then
      colors[name] = value
    elseif string.match(value, "lch%(.+%)") then
      local x, y, z = string.match(value, "lch%((%d+%.?%d+)%p? (%d+%.?%d+) (%d+%.?%d+)%)")
      colors[name] = M.lchToHex(x, y, z)
    elseif string.match(value, "hsl%(.+%)") then
      local x, y, z = string.match(value, "hsl%((%d+)%a*, (%d+)%p?, (%d+)%p?%)")
      colors[name] = M.hslToHex(x, y, z)
    elseif string.match(value, "rgb%(.+%)") then
      local x, y, z = string.match(value, "rgb%((%d+), (%d+), (%d+)%)")
      colors[name] = M.rgbToHex(x, y, z)
    end
  end

  return colors
end

--- Retrieves the settings for the mini.hipatterns plugin
M.get_settings = function()
  local plugin = require('mini.hipatterns')

  local data = {
    pattern = "var%(" .. M.options.variable_pattern .. "%)",
    group = function (_, match)
      local match_value = match:match("var%((.+)%)")
      local color = colors_from_file[match_value] or M.options.initial_variable_color
      return plugin.compute_hex_color_group(color, "bg")
    end
  }

  return data
end

--- INFO: Colors sections

--- Rgb to Hex
M.rgbToHex = function(r, g, b)
  local function hexToString(num)
    local chars = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"}
    return chars[math.floor(num * 0.0625) + 1] .. chars[num % 16 + 1]
  end

  return "#" .. hexToString(r) .. hexToString(g) .. hexToString(b)
end

--- Lch to Hex
function M.lchToHex(l, c, h)
  local a = math.floor(c * math.cos(math.rad(h)) + 0.5)
  local b = math.floor(c * math.sin(math.rad(h)) + 0.5)

  local xw, yw, zw = 0.948110, 1.00000, 1.07304

  local fy = (l + 16) * 0.0086206897
  local fx = fy + (a * 0.002)
  local fz = fy - (b * 0.002)

  local x = xw * ((fx ^ 3 > 0.008856) and fx ^ 3 or ((fx - 0.137931034) * 0.1284))
  local y = yw * ((fy ^ 3 > 0.008856) and fy ^ 3 or ((fy - 0.137931034) * 0.1284))
  local z = zw * ((fz ^ 3 > 0.008856) and fz ^ 3 or ((fz - 0.137931034) * 0.1284))

  local R = x * 3.2406 - y * 1.5372 - z * 0.4986
  local G = -x * 0.9689 + y * 1.8758 + z * 0.0415
  local B = x * 0.0557 - y * 0.2040 + z * 1.0570

  R = R > 0.0031308 and 1.055 * R ^ (0.416666667) - 0.055 or 12.92 * R
  G = G > 0.0031308 and 1.055 * G ^ (0.416666667) - 0.055 or 12.92 * G
  B = B > 0.0031308 and 1.055 * B ^ (0.416666667) - 0.055 or 12.92 * B

  R = math.floor(math.max(math.min(R, 1), 0) * 255 + 0.5)
  G = math.floor(math.max(math.min(G, 1), 0) * 255 + 0.5)
  B = math.floor(math.max(math.min(B, 1), 0) * 255 + 0.5)

  return string.format("#%02x%02x%02x", R, G, B)
end

--- Hsl to Hex color
function M.hslToHex(H, S, L)
  local function hueToRgb(p, q, t)
    if t < 0 then
      t = t + 1
    end
    if t > 1 then
      t = t - 1
    end
    if t < 0.1666666667 then
      return p + (q - p) * 6 * t
    end
    if t < 0.5 then
      return q
    end
    if t < 0.6666666667 then
      return p + (q - p) * (0.6666666667 - t) * 6
    end
    return p
  end

  local function hslToRgb(h, s, l)
    local r, g, b
    if s == 0 then
      r, g, b = l, l, l
    else
      local q
      if l < 0.5 then
        q = l * (1 + s)
      else
        q = l + s - l * s
      end
      local p = 2 * l - q

      r = hueToRgb(p, q, h + 0.3333333333)
      g = hueToRgb(p, q, h)
      b = hueToRgb(p, q, h - 0.3333333333)
    end
    return r * 255, g * 255, b * 255
  end

  local r, g, b = hslToRgb(H * 0.0027777778, S * 0.01, L * 0.01)
  return string.format("#%02x%02x%02x", r, g, b)
end

return M
