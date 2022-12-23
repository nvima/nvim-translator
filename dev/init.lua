--[[
-- plugin name will be used to reload the loaded modules
--]]
local package_name = 'translator'

-- add the escape character to special characters
local escape_pattern = function(text)
    return text:gsub("([^%w])", "%%%1")
end

-- unload loaded modules by the matching text
local unload_packages = function()
    local esc_package_name = escape_pattern(package_name)

    for module_name, _ in pairs(package.loaded) do
        if string.find(module_name, esc_package_name) then
            package.loaded[module_name] = nil
        end
    end
end

-- executes the run method in the package
run_action = function(text)
    unload_packages()
    require(package_name).translate(text)
end
-- unload and run the function from the package

local set_keymap = vim.api.nvim_set_keymap

set_keymap('n', ',r', '<cmd>luafile dev/init.lua<cr>', {})
set_keymap('v', ',w', ':<c-u>lua run_action()<cr>', {})
set_keymap('v', ',t', ':lua run_action(vim.fn.input(""))<cr>', {})
-- Hallo wie geht es dir?
