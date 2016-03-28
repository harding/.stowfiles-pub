set title

syntax enable
set background=dark     " Assume a dark background
let g:solarized_termcolors=256
"colorscheme solarized
set showmode
"set cursorline
set ignorecase
set smartcase
set wildmenu
set foldenable
set shiftwidth=2
set expandtab
set autoindent

" disable auto rewraping from within a paragraph
set fo+=v
set textwidth=72

" Paste from xclip
map [2~ :r !xclip -o

" Autoreformat
map F !} dhfmt

" Put backup files out of the way
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
