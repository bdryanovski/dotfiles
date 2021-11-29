"
"
"   ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓
"   ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒
"  ▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░
"  ▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██
"  ▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒
"  ░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░
"  ░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░
"     ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░
"           ░    ░  ░    ░ ░        ░   ░         ░
"                                   ░
"   ▄████▄   ▒█████   ███▄    █   █████▒██▓  ▄████
"  ▒██▀ ▀█  ▒██▒  ██▒ ██ ▀█   █ ▓██   ▒▓██▒ ██▒ ▀█▒
"  ▒▓█    ▄ ▒██░  ██▒▓██  ▀█ ██▒▒████ ░▒██▒▒██░▄▄▄░
"  ▒▓▓▄ ▄██▒▒██   ██░▓██▒  ▐▌██▒░▓█▒  ░░██░░▓█  ██▓
"  ▒ ▓███▀ ░░ ████▓▒░▒██░   ▓██░░▒█░   ░██░░▒▓███▀▒
"  ░ ░▒ ▒  ░░ ▒░▒░▒░ ░ ▒░   ▒ ▒  ▒ ░   ░▓   ░▒   ▒
"  ░  ▒     ░ ▒ ▒░ ░ ░░   ░ ▒░ ░      ▒ ░  ░   ░
"  ░        ░ ░ ░ ▒     ░   ░ ░  ░ ░    ▒ ░░ ░   ░
"  ░ ░          ░ ░           ░         ░        ░
"  ░
"
"  Personal NeoVim configuration - Bozhidar Dryanovski
"
"
"  ! Warning this configuration is opinionated so pick only the things you like
"
"  ! May not work as expected in Vim.
"
" ---------------------------------------------------------------------------------------------------------------------
" Settings
" ---------------------------------------------------------------------------------------------------------------------
"
set expandtab               " converts tabs to white space
" set relativenumber        " Show relative numbers
set hidden
set showmatch               " show matching
set ignorecase              " case insensitive
set hlsearch                " highlight search
set tabstop=2               " number of columns occupied by a tab
set softtabstop=2           " see multiple spaces as tabstops so <BS> does the right thing
set shiftwidth=2            " width for autoindents
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set cc=120                  " set an 120 column border for good coding style
set mouse=a                 " enable mouse click
set cursorline              " highlighd current cursorline

set list
set listchars=tab:‣\ ,trail:·,precedes:«,extends:»

"
" Not working that good so don't enable until find time to fix it!
" set spell                 " enable spell check (may need to download language package)

"
" Don't backup anything - fail like real men``
"
set noswapfile              " disable creating swap file
set nobackup
set nowritebackup
" set backupdir=~/.cache/vim " Directory to store backup files.
"
set cmdheight=1
set updatetime=00

set shortmess+=c

syntax on                   " syntax highlighting
filetype plugin on
filetype plugin indent on   "allow auto-indenting depending on file type

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

"
" ---------------------------------------------------------------------------------------------------------------------
" Plugins
" ---------------------------------------------------------------------------------------------------------------------
"

"
" Make sure to install vim-plug
"

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(data_dir . '/plugins')

 source ~/.config/nvim/config/theme.vim
 source ~/.config/nvim/config/nerdtree.vim
 source ~/.config/nvim/config/lsp.vim
 source ~/.config/nvim/config/comments.vim
 source ~/.config/nvim/config/ui.vim
 source ~/.config/nvim/config/control-version.vim
 source ~/.config/nvim/config/editor.vim
 source ~/.config/nvim/config/surround.vim
call plug#end()

doautocmd User PlugLoaded

"
" Configuration if i'm using neovide
"
source ~/.config/nvim/neovide.vim

syntax enable

"
" ---------------------------------------------------------------------------------------------------------------------
" Personal Configuration
" ---------------------------------------------------------------------------------------------------------------------
"" open new split panes to right and below
set splitright
set splitbelow

"
" ---------------------------------------------------------------------------------------------------------------------
" Autocommands
" ---------------------------------------------------------------------------------------------------------------------
"

" Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

"
" ---------------------------------------------------------------------------------------------------------------------
" Mapping and keyboard
" ---------------------------------------------------------------------------------------------------------------------
source ~/.config/nvim/mapping.vim
