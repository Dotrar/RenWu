# RenWu 任务
Simple todo list in nvim

Special thanks goes out to ThePrimeagen, for which I learnt how to rip off his code. 
and to sunjonSenghanBri for helping me on irc.

## Pictures
![image](https://user-images.githubusercontent.com/1199335/143765693-b4a8ceb2-eed2-4108-ab24-8c391fd07788.png)

## Install

Through the usual means, such as vim-plugged. Then set up two commands for yourself as such:

```vim
call plug#begin(stdpath('data') . '/plugged')
Plug 'Dotrar/Renwu'
call plug#end() 

" Make a mapping with a space at the end, acts as a prompt for new items.
nnoremap <leader>g :RenWu<space>

" Empty command means to show menu (<space> is ignored, so safe to just use the one mapping)
nnoremap <leader>` :RenWu<cr>
```

When called with string arguments, the command will add the string as a new line to your todo list

The todolist buffer acts as normal, so you can re-arrange with ddP and etc. Markdown syntax supported
Config is relatively easy and simple
