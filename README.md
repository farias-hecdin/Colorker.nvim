> [!TIP]
> Use `Google Translate` to read this file in your native language.

# CSSVarHighlight

Este plugin para **Neovim** es una herramienta útil que te ayudará a identificar fácilmente los colores definidos en variables CSS en tus archivos de estilo, como `main.css` o `style.css`. Cuando el plugin detecta un color en una variable CSS en estos archivos, resalta su aparición, lo que facilita su visualización desde cualquier otro archivo.

## Requerimientos

* [`Neovim`](https://github.com/neovim/neovim): Versión 0.7 o superior.
* [`Mini.hipatterns`](https://github.com/echasnovski/mini.hipatterns): El resaltador de colores.
* [`CSSPluginHelpers`](https://github.com/farias-hecdin/CSSPluginHelpers): Funciones esenciales para el plugin.

### Instalación

Usando [`folke/lazy.nvim`](https://github.com/folke/lazy.nvim):

```lua
{
    'farias-hecdin/CSSVarHighlight',
    ft = "css",
    dependencies = {
        "echasnovski/mini.hipatterns",
        "farias-hecdin/CSSPluginHelpers",
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
local CSSVarHighlight = require("CSSVarHighlight")

hipatterns.setup({
    -- Your other settings...
    highlighters = {
        css_variables = CSSVarHighlight.get_settings()
        -- Your other settings...
    }
})
```

## Configuración

Estas son las opciones de configuración predeterminadas:

```lua
require('CSSVarHighlight').setup({
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
| `CSSVarHighlight`  | `<leader>ch`      | Activa el plugin y actualiza el resaltado de colores |

Puedes ampliar la búsqueda de archivos hacia arriba o seleccionar otro archivo utilizando el comando `:CSSVarHighlight`.

* Para buscar hacia arriba, utiliza la sintaxis `:CSSVarHighlight <number> <string>`, donde `<number>` es el número de niveles que deseas buscar hacia arriba y `<string>` es el nombre del archivo. El plugin analizará cada nivel hasta encontrar el archivo deseado.

* Para buscar hacia abajo o en un directorio específico, utiliza la sintaxis `:CSSVarHighlight <string> <string>`, donde el primer `<string>` es el nombre del archivo y el segundo `<string>` es la ruta del directorio donde deseas buscar. Por ejemplo:

```
:CSSVarHighlight filename file/path/to/search
```

Si deseas desactivar los atajos de teclado predeterminados, puedes establecer la opción  `disable_keymaps` en `true`

## Licencia

CSSVarHighlight está bajo la licencia MIT. Consulta el archivo `LICENSE` para obtener más información.
