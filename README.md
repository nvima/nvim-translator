nvim-translator 
==============

A plugin to translate text in Neovim

The plugin is currently under development. It works only with 1 selected line at the moment.
Currently it is only available in Visual Mode and only works with the Deepl API.
Deepl API has a free quota of 500,000 characters per month.

![](https://raw.githubusercontent.com/nvima/nvim-translator/main/docs/translate.gif)


Installation
------------

Use your favorite plugin manager.

Using [packer](https://github.com/wbthomason/packer.nvim):

```lua
use {
    'nvima/nvim-translator',
    requires = { { 'nvim-lua/plenary.nvim' } }
}

```

Quick start guide
-----------------

Ex. add the following mappings to your vim configuration.

```lua
local translator = require("translator")
local config = {
    -- default target language
    translator_target_lang = "en", --Default value
    -- env var for deepl api key
    translator_deepl_auth = "DEEPL_AUTH", --Default value
    -- deepl free api url
    -- translator_deepl_url = "https://api-free.deepl.com/v2/translate",
    -- deepl paid api url
    -- translator_deepl_url = "https://api.deepl.com/v2/translate",
}
translator.setup(config)

-- Use default target lang for translations
vim.keymap.set("v", "<leader>td", function() translator.translate() end)
-- Use custom target lang from input for translations
vim.keymap.set("v", "<leader>tc", function() translator.translate(vim.fn.input('')) end)


```


Author
------

[nvima](https://github.com/nvima)

License
-------

MIT

