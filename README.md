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
    -- Si quieres configurar algunas opciones, sustituye la línea anterior con:
    -- config = function()
    -- end,
}
```

Posteriormente, en la configuración del plugin `mini.hipatterns`:

```lua
local hipatterns = require("mini.hipatterns")
local colorker = require("colorker")

hipatterns.setup({
    -- El resto de tus ajuste...
    highlighters = {
        css_variables = colorker.get_settings()
        -- El resto de tus ajuste...
    }
})
```

## Configuración

Estas son las opciones de configuración predeterminadas:

```lua
require('colorker').setup({
  parent_search_limit = 5, -- <number>
  filename_to_track = "main", -- <string>
  variable_pattern = "%-%-[-_%w]*color[-_%w]*", -- <string>
  disable_keymaps = false, -- <boolean> Desabihilitar los atajos de teclado.
}
```

## Licencia

Colorker.nvim está bajo la licencia MIT. Consulta el archivo `LICENSE` para obtener más información.
