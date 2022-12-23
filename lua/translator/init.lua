local M      = {}
local config = require('translator.config').config
local curl   = require('plenary.curl')

M.translate = function(target_lang)
    local text = Buf_vtext()
    print(text)

    -- check if target_lang is nil or empty
    if target_lang == nil or target_lang == '' then
        target_lang = config.translator_target_lang
    end

    local result = Translate_deepl(text, target_lang)
    print(result)
    if result then
        vim.api.nvim_command("'<,'>s/" .. text .. "/" .. result .. "/")
    end
end

Translate_deepl = function(text, target_lang)

    local json = {
        target_lang = target_lang,
        text = text,
    }

    local res = curl.post(config.translator_deepl_url, {
        headers = {
            Authorization = "DeepL-Auth-Key " .. os.getenv(config.translator_deepl_auth),
        },
        accept  = "application/json",
        body    = json,
    })
    if res.status ~= 200 then
        print("Error: " .. res.status)
        return
    end
    return vim.fn.json_decode(res.body).translations[1].text
end

function Buf_vtext()
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

-- M.get_visual_selection = function()
--     local s_start = vim.fn.getpos("'<")
--     local s_end = vim.fn.getpos("'>")
--     local n_lines = math.abs(s_end[2] - s_start[2]) + 1
--     local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
--     lines[1] = string.sub(lines[1], s_start[3], -1)
--     if n_lines == 1 then
--         lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
--     else
--         lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
--     end
--     return table.concat(lines, '\n')
-- end

M.setup = function(user_config)
    -- merge in config
    if user_config ~= nil then
        for k, v in pairs(user_config) do
            config[k] = v
        end
    end
end

return M
