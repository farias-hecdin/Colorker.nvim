local M = {}
local vim = vim
local config = require('colorker.misc.config')
local operations = require('colorker.misc.file_operations')
local lch = require('colorker.colors.lch')
local hsl = require('colorker.colors.hsl')
local rgb = require('colorker.colors.rgb')

local colors_from_file = {}

local plugin_exists, plugin = pcall(require, "mini.hipatterns")
if not plugin_exists then
  return
end

M.setup = function(options)
  -- Merge the user-provided options with the default options
  config.options = vim.tbl_deep_extend("keep", options or {}, config.options)
  -- Enable keymap if they are not disableds
  if not config.options.disable_keymaps then
    local keymaps_opts = {buffer = 0, silent = true}
    local filetypes = 'css'
    -- Create the keymaps for the specified filetypes
    vim.api.nvim_create_autocmd('FileType', {
      desc = 'colorker.nvim keymaps',
      pattern = filetypes,
      callback = function()
        vim.keymap.set('n', '<leader>cx', "Colorker<CR>", keymaps_opts)
      end,
    })
  end
end

-- Crear un commando para la funcionalidad
vim.api.nvim_create_user_command("Colorker", function(args)
  local fname = args.fargs[1] or config.options.filename_to_track
  local attempt_limit = tonumber(args.fargs[1] or config.options.parent_search_limit)

  M.get_colors_from_file(fname, attempt_limit)
end, {desc = "Track the colors of the CSS variables", nargs = "*"})

M.get_colors_from_file = function(fname, attempt_limit)
  fname = fname .. ".css"

  local variable_pattern = config.options.variable_pattern
  local color_patterns = {
    hex = '%#%w%w%w%w%w%w',
    lch = 'lch%(.+%)',
    hsl = 'hsl%(.+%)',
    rgb = 'rgb%(.+%)',
  }

  local fpath = operations.find_file(fname, nil, 1, attempt_limit)
  if not fpath then
    vim.print("[Colorker.nvim] Attempt limit reached. Operation cancelled.")
    return
  end

  local data = operations.open_file(fpath, variable_pattern, color_patterns)
  if not data then
    return
  end

  colors_from_file = M.convert_color(data)

  vim.cmd('lua MiniHipatterns.update()')
end

M.convert_color = function(data)
  local colors = {}

  for name, value in pairs(data) do
    if string.match(value, "#") then
      colors[name] = value
    elseif string.match(value, "lch%(") then
      local x, y, z = string.match(value, "lch%((%d+%.?%d+)%p? (%d+%.?%d+) (%d+%.?%d+)%)")
      colors[name] = lch.lchToHex(x, y, z)
    elseif string.match(value, "hsl%(") then
      local x, y, z = string.match(value, "hsl%((%d+)%a*, (%d+)%p?, (%d+)%p?%)")
      colors[name] = hsl.hslToHex(x, y, z)
    elseif string.match(value, "rgb%(") then
      local x, y, z = string.match(value, "rgb%((%d+), (%d+), (%d+)%)")
      colors[name] = rgb.rgbToHex(x, y, z)
    end
  end

  return colors
end

M.get_settings = function()

  local data = {
    pattern = "var%(" .. config.options.variable_pattern .. "%)",
    group = function (_, match)
      local match_value = match:match("var%((.+)%)")
      local color = colors_from_file[match_value] or config.options.initial_variable_color
      return plugin.compute_hex_color_group(color, "bg")
    end
  }

  return data
end

return M
