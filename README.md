> [!TIP]
> Use `Google Translate` to read this file in your native language.

# Colorker.nvim

Este plugin para Neovim es una herramienta útil que te ayudará a identificar fácilmente los colores definidos en variables CSS en archivos específicos, como `main.css` o `style.css`. Cuando el plugin detecta un color en una variable CSS en estos archivos, resalta su aparición, lo que facilita su visualización desde cualquier otro archivo.

## Requerimientos

* [`neovim`](https://github.com/neovim/neovim) >= 0.7
* [`mini.hipatterns`](https://github.com/echasnovski/mini.hipatterns)

### Instalación

Usando [`folke/lazy.nvim`](https://github.com/folke/lazy.nvim):

```lua
{
    'farias-hecdin/Colorker.nvim',
    ft = "css",
    dependencies = {
        "mini.hipatterns"
    },
    config = true,
    -- If you want to configure some options, replace the previous line with:
    -- config = function()
    -- end,
}
```

Posteriormente, en la configuración del plugin `mini.hipatterns`:

```lua
local hipatterns = require("mini.hipatterns")
local colorker = require("colorker")

hipatterns.setup({
    -- Your other settings...
    highlighters = {
        css_variables = colorker.get_settings()
        -- Your other settings...
    }
})
```

## Configuración

Estas son las opciones de configuración predeterminadas:

```lua
require('colorker').setup({
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
```

### Comandos y atajos de teclado

| Comandos           | Atajos de teclado | Descripción                         |
| -------------------|------------------ | ----------------------------------- |
| `Colorker`         | `<leader>cc`      | Activa el plugin y actualiza el resaltado de colores |

Puedes desactivar los atajos de teclado predeterminados estableciendo la opción `disable_keymaps` en `true`

## Licencia

Colorker.nvim está bajo la licencia MIT. Consulta el archivo `LICENSE` para obtener más información.
