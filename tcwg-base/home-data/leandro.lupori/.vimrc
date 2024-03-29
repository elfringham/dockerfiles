" my settings
" :source $MYVIMRC

" syntax/tab/indent settings
syntax enable       " syntax hl on
set tw=78
set bs=2            " backspace mode = 2 (erases any char)
set ts=2            " tab stop
set sw=2            " indentation shift width
set expandtab       " tab -> spaces
set autoindent
set cindent

" other settings
"colorscheme mine
set bg=dark
set history=100
set hlsearch
set incsearch
set list            " show tab and trailing chars
set listchars=tab:>-,trail:@    " chars to use in list mode
set modeline        " enable embedded vim options in files
set nobackup
set number
set ruler
set showcmd
set splitbelow
set splitright
set t_vb=           " visual bell termcap code
set visualbell      " no bell sound

autocmd FileType text setlocal textwidth=78

" clear highlight
nnoremap <silent> <leader>/ :nohlsearch<CR>

" enable menus
source $VIMRUNTIME/menu.vim
set wildmenu
set cpo-=<
set wcm=<C-Z>
map <F4> :emenu <C-Z>

" Vundle plugins
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'lyuts/vim-rtags'
"let g:rtagsRcCmd = rtags-rc
call vundle#end()
filetype plugin indent on
