" lua <<EOF
" require('go').setup({
"   max_line_len = 120,
"   tag_transform = false,
"   test_dir = '',
"   comment_placeholder = '   ',
"   -- lsp_cfg = true, -- false: use your own lspconfig
"   -- lsp_gofumpt = true, -- true: set default gofmt in gopls format to gofumpt
"   -- lsp_on_attach = true, -- use on_attach from go.nvim
"   -- dap_debug = true,
" })
"
" local protocol = require'vim.lsp.protocol'
"
" EOF