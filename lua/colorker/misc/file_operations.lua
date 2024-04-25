local M = {}

-- Buscar el archivo "*.css" en el directorios actual y superiores.
M.find_file = function(fname, dir, attempt, limit)
  if not attempt or attempt > limit then
    return
  end

  dir = dir or ""
  local command = "ls -1 " .. dir

  local handle = io.popen(command)
  if not handle then
    return false
  end

  for file in handle:lines() do
    if file == fname then
      handle:close()
      return dir .. "/" .. fname
    end
  end
  handle:close()

    dir = dir .. "../"

  return M.find_file(fname, dir, attempt + 1, limit)
end

-- Abrir un archivo y retornar su contenido.
M.open_file = function(fname, variable_pattern, color_pattern)
  local data = {}
  local file = io.open(fname, "r")
  if not file then
    return
  end

  for line in file:lines() do
    local variable = string.match(line, variable_pattern)
    if variable then
      for _, pattern in pairs(color_pattern) do
        local color = string.match(line, pattern)
        if color then
          data[variable] = color
          break
        end
      end
    end
  end

  file:close()
  return data
end

return M
