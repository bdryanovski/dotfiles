if !exists('g:loaded_cmp') | finish | endif

" set completeopt=menuone,noinsert,noselect

lua <<EOF
  local cmp = require'cmp'
  local lspkind = require('lspkind')

  cmp.setup({
    completion = {
      completeopt = 'menu,menuone,noinsert',
    },
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    }),
    formatting = {
      format = lspkind.cmp_format()
    }
  })

EOF

