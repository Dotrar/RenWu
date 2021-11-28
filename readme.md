# RenWu 任务
Simple todo list in nvim

Use the command `:RenWu` to bring up the todo notepad.
or add items with `:RenWu <your text here>`

Special thanks goes out to ThePrimeagen, for which I learnt how to rip off his code
and others who helped on irc and discord.

## Screenshot

## Install

Through the usual means, such as vim-plugged. 


```vim
call plug#begin(stdpath('data') . '/plugged')
Plug 'Dotrar/Renwu'
call plug#end() 
```

or lazy.nvim (shown here with custom config):

```lua
    { 'Dotrar/Renwu',
        config = function()
            require('renwu').setup({
                window = {
                    width = 60,
                    height = 15,
                    title = "任务～ TODO ～你好",
                    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
                },
            })
        end },

```

Then set up two commands for yourself as such:

```vim
" Make a mapping with a space at the end, acts as a prompt for new items.
nnoremap <leader>g :RenWu<space>

" Empty command means to show menu (<space> is ignored, so safe to just use the one mapping)
nnoremap <leader>` :RenWu<cr>
```

When called with string arguments, the command will add the string as a new line to your todo list

The todolist buffer acts as a normal, so you can re-arrange with `ddP` and etc. Markdown syntax supported
Config is relatively easy and simple

## Keybinds

`q` or `<esc>` in normal mode will close the window

## Colours

You can change the colour by adjusting the `RenWuBorder` highlight group
```lua
vim.cmd([[highlight! RenWuBorder guifg=#FF0033 guibg=NONE]])
```
