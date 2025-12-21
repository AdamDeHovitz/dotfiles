" Basic Settings
set nocompatible              " Use Vim defaults instead of Vi
set encoding=utf-8            " UTF-8 encoding
set fileencoding=utf-8

" Syntax and Colors
syntax enable                 " Enable syntax highlighting
set background=dark           " Dark background
colorscheme desert            " Built-in colorscheme (no plugins needed)

" Line Numbers and Display
set number                    " Show line numbers
set relativenumber            " Relative line numbers for easy navigation
set cursorline                " Highlight current line
set showmatch                 " Highlight matching brackets
set showcmd                   " Show command in status line
set ruler                     " Show cursor position
set laststatus=2              " Always show status line

" Search Settings
set hlsearch                  " Highlight search results
set incsearch                 " Incremental search
set ignorecase                " Case insensitive search
set smartcase                 " Case sensitive if uppercase present
nnoremap <CR> :noh<CR><CR>    " Press Enter to clear search highlighting

" Indentation
set autoindent                " Copy indent from current line
set smartindent               " Smart autoindenting
set expandtab                 " Use spaces instead of tabs
set tabstop=4                 " Tab width
set shiftwidth=4              " Indentation width
set softtabstop=4             " Backspace through spaces

" File Type Specific Indentation
autocmd FileType javascript,typescript,json,yaml,html,css setlocal tabstop=2 shiftwidth=2 softtabstop=2

" Usability
set backspace=indent,eol,start  " Backspace works as expected
set scrolloff=8               " Keep 8 lines visible above/below cursor
set sidescrolloff=8           " Keep 8 columns visible left/right
set wildmenu                  " Enhanced command line completion
set wildmode=list:longest     " Complete longest common string
set mouse=a                   " Enable mouse support
set clipboard=unnamed         " Use system clipboard

" Performance
set lazyredraw                " Don't redraw during macros
set ttyfast                   " Fast terminal connection

" File Management
set noswapfile                " Disable swap files
set nobackup                  " Disable backup files
set undofile                  " Persistent undo
set undodir=~/.vim/undodir    " Undo directory

" Split Behavior
set splitbelow                " Horizontal splits open below
set splitright                " Vertical splits open right

" Key Mappings
let mapleader = " "           " Space as leader key

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Stay in visual mode when indenting
vnoremap < <gv
vnoremap > >gv

" Quick buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" File explorer
nnoremap <leader>e :Explore<CR>

" Create undo directory if it doesn't exist
if !isdirectory($HOME."/.vim/undodir")
    call mkdir($HOME."/.vim/undodir", "p", 0700)
endif
