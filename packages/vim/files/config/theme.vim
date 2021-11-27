
" ████████╗██╗  ██╗███████╗███╗   ███╗███████╗
" ╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝
"    ██║   ███████║█████╗  ██╔████╔██║█████╗  
"    ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝  
"    ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗
"    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝
"

Plug 'dracula/vim'

" color schemes
if (has("termguicolors"))
 set termguicolors
endif


augroup DraculaOverrides
    autocmd!

    " Some theme changes
    autocmd ColorScheme dracula highlight DraculaComment cterm=italic gui=italic

    autocmd User PlugLoaded ++nested colorscheme dracula
augroup end

