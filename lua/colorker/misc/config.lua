local M = {}

-- Options table with default values
M.options = {
  parent_search_limit = 5, -- <number>
  filename_to_track = "main", -- <string>
  variable_pattern = "%-%-[-_%w]*color[-_%w]*", -- <string>
  disable_keymaps = false, -- <boolean>
}

return M
