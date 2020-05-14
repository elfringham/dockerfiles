syntax on

map <F2> :buffers<CR>
map <F3> :b
map <F4> :set hlsearch<CR>
map <F5> :noh<CR>
map <F6> :w<CR>
map <F7> :q<CR>

highlight DiffAdd cterm=none ctermfg=Black  ctermbg=Green gui=none guifg=Grey guibg=Green
highlight DiffDelete cterm=none ctermfg=Black ctermbg=Red gui=none guifg=Grey guibg=Red
highlight DiffChange cterm=none ctermfg=Black ctermbg=Yellow gui=none guifg=Grey guibg=Yellow
highlight DiffText cterm=none ctermfg=Black ctermbg=Cyan gui=none guifg=Grey guibg=Magenta

" autocmd BufRead,BufNewFile */llvm* set colorcolumn=81 nowrap
set colorcolumn=81
highlight ColorColumn ctermbg=7
"
set hlsearch
set viminfo='1000,f1
set ruler
