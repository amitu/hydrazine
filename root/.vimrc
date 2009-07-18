" let users become root when doing w!!
cmap w!! %!sudo tee > /dev/null %

set nocompatible " use vim defaults (this should be first in .vimrc)
filetype plugin on " load ftplugin.vim

set modeline
set autowrite

set hlsearch " highlight the current search pattern
" in normal mode enter clears search highlight
nnoremap <silent><CR> :nohlsearch<CR><CR> 

" enter spaces when tab is pressed:
set expandtab
" do not break lines when line lenght increases
set textwidth=0
" user 4 spaces to represent a tab
set tabstop=4 
set softtabstop=4
" number of space to use for auto indent you can use >> or << keys to indent
" current line or selection in normal mode.
set shiftwidth=4
" Copy indent from current line when starting a new line.
set autoindent
" makes backspace key more powerful.
set backspace=indent,eol,start
" shows the match while typing
set incsearch
" case insensitive search
set ignorecase
" show line and column number
set ruler
" show some autocomplete options in status bar
set wildmenu

"set autochdir 

" automatically save and restore folds
au BufWinLeave *.* mkview
au BufWinEnter *.* silent loadview

" this lets us put the marker in the file so that
" it can be shared across and stored in version control.
set foldmethod=marker
" this is for python, put
" # name for the folded text # {{{
" to begin marker and
" # }}}
" close to end it.
set commentstring=\ #\ %s
" default fold level, all open, set it 200 or something
" to make it all closed.
set foldlevel=0

" share clipboard with windows clipboard
set clipboard+=unnamed

" set viminfo='100,f1
" minibufexplorer settings:j
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchWindows = 1

syntax on

set ttymouse=xterm2
set mouse=a

let NERDChristmasTree = 1
let NERDTreeAutoCenter = 1
let NERDTreeIgnore=['\.sw?$', '\~$', '\.pyc$']

highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.*/

":autocmd FileType mail :nmap <F8> :w<CR>:!aspell -e -c %<CR>:e<CR>
nmap <F8> :w<CR>:!aspell -e -c %<CR>:e<CR>
filetype plugin indent on

" f5 before and after pasing
nnoremap <F5> :set invpaste paste?<Enter>
imap <F5> <C-O><F5>
set pastetoggle=<F5>

" reflow para shortcut
nnoremap Q gqap
" for visual mode
vnoremap Q gq  

" rapidly switch between files
nnoremap <C-N> :bnext<Enter>
nnoremap <C-P> :bprev<Enter>
set confirm
