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

run_action = function(text)
    unload_packages()
    require(package_name).translate(text)
end

run_test = function()
    print("start")
    local vsel = buf_vtext()
    print(vsel)
    print("end")
end
function buf_vtext()
    local a_orig = vim.fn.getreg('a')
    local mode = vim.fn.mode()
    if mode ~= 'v' and mode ~= 'V' then
        vim.cmd [[normal! gv]]
    end
    vim.cmd [[normal! "aygv]]
    local text = vim.fn.getreg('a')
    vim.fn.setreg('a', a_orig)
    return text
end

local set_keymap = vim.api.nvim_set_keymap

set_keymap('n', ',r', '<cmd>luafile dev/init.lua<cr>', {})
set_keymap('v', ',w', ':<c-u>lua run_action()<cr>', {})
-- set_keymap('v', ',t', ':lua run_action(vim.fn.input(""))<cr>', {})
set_keymap('v', ',t', ':lua run_test()<cr>', {})
set_keymap('n', ',t', ':lua run_test()<cr>', {})
-- Hallo wie geht es dir?
