set nocompatible

syntax on
set number
set smarttab expandtab tabstop=4 shiftwidth=4

set nobackup noswapfile
set wildmode=longest,list,full

" key-bindings
nnoremap ; :
nnoremap j gj
nnoremap k gk
let mapleader=","
nmap <leader>ev :e $MYVIMRC<CR>
nmap <leader>sv :source $MYVIMRC<CR>
imap jk <esc>
imap kj <esc>
vmap ; <esc>
nmap <leader>m :make<cr>

"" >>> Vundle ""
filetype off
source ~/.vimrc.vundle
filetype plugin indent on
"" <<< Vundle ""

" base16 colorscheme
let base16colorspace=256
set background=dark 
colorscheme base16-mocha
highlight Comment ctermfg=DarkGrey
highlight Visual cterm=None ctermfg=DarkGrey ctermbg=Grey
highlight MatchParen ctermfg=Red

" vim-airline
set laststatus=2
let g:airline_powerline_fonts=1
set timeoutlen=1000
let g:airline_left_sep=""
let g:airline_right_sep=""
