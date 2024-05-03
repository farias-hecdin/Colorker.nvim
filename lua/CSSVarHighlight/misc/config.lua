local M = {}

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

return M
