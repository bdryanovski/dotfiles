if !exists('g:loaded_telescope') | finish | endif

nnoremap <silent> <c-p> <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <silent> ;r <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <silent> ;b <cmd>lua require('telescope.builtin').file_browser()<cr>
nnoremap <silent> \\ <cmd>Telescope buffers<cr>
nnoremap <silent> ;; <cmd>Telescope help_tags<cr>

lua << EOF
function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup{
  defaults = {
    layout_config = {
      vertical = { width = 0.5 }
    },
    file_ignore_patterns = { "node_modules", "dist" },
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
  },
  pickers = {
    -- find_files = { theme = "dropdown" },
  },
}
EOF


