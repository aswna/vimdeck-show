" Hide statuslines, line numbers, etc.
set laststatus=0
set nolist
set nonumber
set norelativenumber
set noruler
set noshowcmd
set noshowmode
set showtabline=0

" Workaround to hide line below statusline
autocmd BufWinEnter * call feedkeys(":\<C-\>\<C-n>", 'n')
autocmd BufWinEnter * setlocal textwidth=0

" Hide ~ at the beginning of lines
highlight EndOfBuffer ctermfg=black
highlight NonText ctermfg=black

" Make cursor invisible (restore visibility at exit)
let old_t_ve = &t_ve
autocmd BufWinEnter * let &t_ve = &t_vi
autocmd VimLeave * let &t_ve = old_t_ve

" Remove trailing spaces
silent bufdo %s/\s\+$//e
