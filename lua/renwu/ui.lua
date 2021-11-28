local renwu = require('renwu')
local popup = require('plenary.popup')


local M = {}

Renwu_win = nil
Renwu_buf = nil

local function close_menu()
    vim.api.nvim_win_close(Renwu_win,true)
    Renwu_win = nil
    Renwu_buf = nil
end

local function create_window()
    local config = renwu.get_window_config()
    local width = config.width or 60
    local height = config.height or 10
    local title = config.title or "RenWu Todo"

    local borderchars = config.borderchars
        or { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

    local bufnr = vim.api.nvim_create_buf(false, false)

    local cmd_win, win = popup.create(bufnr, {
        title = title,
        highlight = "RenWuWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
    })

    vim.api.nvim_win_set_option(
        win.border.win_id,
        "winhl",
        "Normal:RenWuBorder"
    )

    return {
        bufnr = bufnr,
        win_id = cmd_win,
    }
end

local function get_todo_items()
    local lines = vim.api.nvim_buf_get_lines(Renwu_buf, 0, -1, true)
    return lines
end

local function get_first_empty_slot()
    local t = renwu.get_todo_items()
    local max_t = table.maxn(t)
    for idx = 1, max_t do
        local st = t[idx]
        if st == "" then
            return idx
        end
    end
    return max_t+1
end

M.command = function(input_string)
    if input_string == "" then
        M.toggle_menu()
    else
        M.add_new_item(input_string)
    end
end

M.add_new_item = function(input_string)
    local empty_idx = get_first_empty_slot()
    renwu.get_todo_items()[empty_idx] = input_string
    renwu.save()
end

M.menu_save = function()
    local contents = get_todo_items()

    -- clear out old list, give new.
    local store = renwu.get_todo_items()
    for k in pairs(store) do
        store[k] = nil
    end

    for k,v in pairs(contents) do
        store[k] = v
    end

    -- emit "saved" message? 

    renwu.save()

end

M.toggle_menu = function()
     if
         Renwu_win ~= nil
         and vim.api.nvim_win_is_valid(Renwu_win)
     then
         M.menu_save()
         close_menu()
         return
     end

    local win_info = create_window()
    local contents = renwu.get_todo_items()
    Renwu_win = win_info.win_id
    Renwu_buf = win_info.bufnr

    -- TODO fill contents with the todo items that becomes "commands" 
    --

    -- contents = {
    --     "line 1",
    --     "line 2",
    --     "line 3",
    -- }

    vim.api.nvim_win_set_option(Renwu_win, "number", true)
    vim.api.nvim_buf_set_name(Renwu_buf, "renwu-menu")
    vim.api.nvim_buf_set_lines(Renwu_buf,0,#contents, false, contents)

    vim.api.nvim_buf_set_option(Renwu_buf,"filetype","markdown")
    vim.api.nvim_buf_set_option(Renwu_buf,"buftype", "acwrite")
    vim.api.nvim_buf_set_option(Renwu_buf,"bufhidden","delete")

    local km = function(key, command)
        vim.api.nvim_buf_set_keymap(Renwu_buf,"n",key,command, {silent = true})
    end
    local cmd = function (f_str, ...)
        vim.cmd(string.format(f_str,...))
    end

    -- set up keybindings for the menu here
    km("q",":lua require('renwu.ui').toggle_menu()<CR>")
    km("<esc>",":lua require('renwu.ui').toggle_menu()<CR>")

    cmd("autocmd BufWriteCmd <buffer=%s> :lua require('renwu.ui').menu_save()",Renwu_buf)
    cmd("autocmd BufModifiedSet <buffer=%s> set nomodified", Renwu_buf)
end

return M
