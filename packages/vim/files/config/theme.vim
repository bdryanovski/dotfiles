
" ████████╗██╗  ██╗███████╗███╗   ███╗███████╗
" ╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝
"    ██║   ███████║█████╗  ██╔████╔██║█████╗  
"    ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝  
"    ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗
"    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝
"

Plug 'dracula/vim'
Plug 'fenetikm/falcon'

" color schemes
if (has("termguicolors"))
 set termguicolors
endif


" augroup DraculaOverrides
"     autocmd!
" 
"     " Some theme changes
"     autocmd ColorScheme dracula highlight DraculaComment cterm=italic gui=italic
" 
"     autocmd User PlugLoaded ++nested colorscheme dracula
" augroup end
" 

"
" Falcon
"
let g:falcon_airline = 1
let g:airline_theme = 'falcon'
autocmd User PlugLoaded colorscheme falcon
