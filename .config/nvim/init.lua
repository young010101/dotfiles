vim.cmd([[
set nu
]])
vim.g.mapleader = ","
require('plugins')
require('user/telescopenov22')
-- " nnoremap <silent> <Leader><Leader> :source $MYVIMRC<cr>
vim.keymap.set("n", "<Leader><Leader>", ":source $MYVIMRC<cr>")
