--------------------------------
-- RenWu 任务
--
-- Simple todo list that follows your work :)
--
-- Author: Dre.K.Westcook
--
-- Shoutout to theprimeagen for which
-- I mainly ripped off his code

local path = require("plenary.path")
local config_path = vim.fn.stdpath('config')
local data_path = vim.fn.stdpath('data')
local user_config_path = string.format("%s/renwu.json", config_path)
local cache_config_path = string.format("%s/renwu.json", data_path)

RenWuConfig = RenWuConfig or {}

M = {}

local function ensure_config(config)
    if config.todo_items == nil then
        config.todo_items = {}
    end
    if config.window == nil then
        config.window = {}
    end
    return config
end

local function load_config(lpath)
    return vim.fn.json_decode(path:new(lpath):read())
end

local function merge_table_impl(t1, t2)
    for k, v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k]) == "table" then
                merge_table_impl(t1[k], v)
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
end

local function merge_tables(...)
    local out = {}
    for i = 1, select("#", ...) do
        merge_table_impl(out, select(i, ...))
    end
    return out
end

local function protected_load_config(...)
    local ok, config = pcall(load_config, ...)
    if not ok then config = {} end
    return config
end


M.save = function()
    path:new(cache_config_path):write(vim.fn.json_encode(RenWuConfig), "w")
end

M.setup = function(given_config)
    local user_config = protected_load_config(user_config_path)
    local cache_config = protected_load_config(cache_config_path)
    local complete_config = merge_tables(user_config, cache_config, given_config or {})

    -- make sure good values are present
    RenWuConfig = ensure_config(complete_config)

    -- set up commands
    vim.api.nvim_create_user_command("RenWu", function(opt)
        local args = opt.args
        local renwu = require 'renwu.ui'
        if args == nil then
            renwu.toggle_menu()
        else
            renwu.command(args)
        end
    end, { nargs = '?' })
end

M.get_window_config = function()
    return ensure_config(RenWuConfig).window
end

M.get_todo_items = function()
    return ensure_config(RenWuConfig).todo_items
end

return M
