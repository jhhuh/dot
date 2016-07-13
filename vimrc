set nocompatible

syntax on
set number
set ignorecase
set smarttab expandtab tabstop=4 shiftwidth=4

set nobackup noswapfile
set wildmode=longest,list,full

" key-bindings
nnoremap ; :
nnoremap j gj
nnoremap k gk
let mapleader="\<Space>"
nmap <leader>ev :e $MYVIMRC<CR>
nmap <leader>sv :source $MYVIMRC<CR>
nmap <leader>k :Explore<CR>
nmap <leader>j :Rexplore<CR>
imap jk <esc>
imap kj <esc>
vmap ; <esc>
nmap <leader>m :make<cr>

"" >>> Vundle ""
filetype off
source ~/.vimrc.vundle
filetype plugin indent on
"" <<< Vundle ""

"" base16 colorscheme
"let base16colorspace=256
"set background=light
"colorscheme base16-mocha
"highlight Comment ctermfg=DarkGrey
"highlight Visual cterm=None ctermfg=DarkGrey ctermbg=Grey
"highlight MatchParen ctermfg=Red

colorscheme default

set laststatus=2
set statusline=%f\ %y\ %l/%L\ 

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height = 5
let g:syntastic_always_populate_loc_list = 1
nmap > :lnext<CR>
nmap < :lprev<CR>

" vim-airline
"let g:airline_powerline_fonts=0
"set timeoutlen=1000
"let g:airline_left_sep=""
"let g:airline_right_sep=""
