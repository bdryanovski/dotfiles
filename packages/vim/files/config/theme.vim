
" ████████╗██╗  ██╗███████╗███╗   ███╗███████╗
" ╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝
"    ██║   ███████║█████╗  ██╔████╔██║█████╗  
"    ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝  
"    ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗
"    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝
"

Plug 'dracula/vim'
Plug 'fenetikm/falcon'

Plug 'bluz71/vim-nightfly-guicolors'

Plug 'ray-x/aurora'

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

"
" Nightfly
"
let g:lightline = { 'colorscheme': 'nightfly' } 
let g:nightflyCursorColor = 1

"
" When all plugins are loaded execute the following commands
"
autocmd User PlugLoaded colorscheme aurora 
