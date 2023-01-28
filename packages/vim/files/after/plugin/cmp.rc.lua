local status, cmp = pcall(require, 'cmp')

if (not status) then return end

local lspkind = require 'lspkind'

cmp.setup({

    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        })
    }),

    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { { name = 'buffer' } }
    }),

    formatting = {
        format = lspkind.cmp_format({
            writh_text = false,
            maxwidth = 50
        })
    }
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})


vim.cmd [[
  set completeopt=menu,menuone,noinsert,noselect
  highlight! default link CmpItemKind CmpItemMenuDefault
]]
