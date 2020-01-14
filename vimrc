set nocompatible
syntax on
set nonumber
set ignorecase
set smarttab expandtab tabstop=4 shiftwidth=4

set nobackup noswapfile
set wildmode=longest,list,full

set backspace=indent,eol,start
"set autoindent

" Tab specific option
" key-bindings
" imap jk <esc>
" imap kj <esc>
nnoremap ; :
nnoremap j gj
nnoremap k gk
let mapleader="\<Space>"
nmap <leader>ev :e $MYVIMRC<CR>
nmap <leader>sv :source $MYVIMRC<CR>
nmap <leader>k :Explore<CR>
nmap <leader>j :Rexplore<CR>
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

"colorscheme ron

"set spell

set laststatus=2
set statusline=%f\ %y\ %l/%L\ 

" haskell-vim
let g:haskell_indent_if = 3
let g:haskell_indent_case = 2
let g:haskell_indent_let = 4
let g:haskell_indent_where = 6
let g:haskell_indent_before_where = 2
let g:haskell_indent_after_bare_where = 2
let g:haskell_indent_do = 3
let g:haskell_indent_in = 1
let g:haskell_indent_guard = 2
let g:haskell_indent_case_alternative = 1
let g:cabal_indent_section = 2

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height = 5
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_cpp_compiler = "g++"
let g:syntastic_cpp_compiler_options = "-std=c++11 -Wall -Wextra -Wpedantic"
"let g:syntastic_debug = 3

let g:syntastic_haskell_checkers = [ 'hlint' ]

nmap > :lnext<CR>
nmap < :lprev<CR>

" neco-ghc
" Disable haskell-vim omnifunc
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
let g:necoghc_enable_detailed_browse = 1

" vim-airline
"let g:airline_powerline_fonts=0
"set timeoutlen=1000
"let g:airline_left_sep=""
"let g:airline_right_sep=""
