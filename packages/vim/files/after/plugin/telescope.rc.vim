if !exists('g:loaded_telescope') | finish | endif

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <leader>fs <cmd>Telescope grep_string<cr>
nnoremap <leader>ft <cmd>Telescope file_browser<cr>

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
    file_ignore_patterns = { "node_modules" },
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
  },
  pickers = {
    find_files = { theme = "ivy" }, 
    -- find_files = { theme = "dropdown" },
  },
}
EOF


