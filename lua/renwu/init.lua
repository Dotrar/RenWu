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
local user_config = string.format("%s/renwu.json", config_path)
local cache_config = string.format("%s/renwu.json", data_path)


-- this file is not loaded seperately, but actually as part of
-- the loading of other system aspects, such as the menu-ui, which
-- will call this function to load some sensible default

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

M.save = function()
    path:new(cache_config):write(vim.fn.json_encode(RenWuConfig),"w")
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

M.setup = function(config)
    if not config then config = {} end

    local ok, u_config = pcall(load_config, user_config)
    if not ok then u_config = {} end

    local ok2, c_config = pcall(load_config, cache_config)
    if not ok2 then c_config = {} end

    --combine loaded cache and user config
    local complete_config = merge_tables({
            window = { },
        },
        u_config,
        c_config,
        config
        )

    -- make sure good values are present
    RenWuConfig = ensure_config(complete_config)
end

M.get_window_config = function()
    return ensure_config(RenWuConfig).window
end

M.get_todo_items = function()
    return ensure_config(RenWuConfig).todo_items
end

M.setup()


return M
