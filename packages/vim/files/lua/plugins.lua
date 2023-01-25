local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

local status, packer = pcall(require, 'packer')

if (not status) then return end

-- vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
    use 'wbthomason/packer.nvim'

    -- Theme
    use "EdenEast/nightfox.nvim"
    use 'folke/tokyonight.nvim'

    -- Status line
    use 'hoob3rt/lualine.nvim'

    -- File Explorer
    use("nvim-tree/nvim-tree.lua")

    -- LSP / TypeScript
    use 'neovim/nvim-lspconfig'

    -- General
    use 'numToStr/Comment.nvim'
    use 'folke/twilight.nvim'

    -- Autocomplite
    use 'onsails/lspkind-nvim' -- vscode pictograms
    use 'hrsh7th/cmp-buffer' -- for buffer words
    use 'hrsh7th/cmp-nvim-lsp' -- for integration with lsp
    use 'hrsh7th/nvim-cmp' -- complitter

    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/vim-vsnip-integ'

    -- Snippets
    use 'L3MON4D3/LuaSnip'

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    }

    -- Editor helpers
    use 'windwp/nvim-autopairs'
    use 'windwp/nvim-ts-autotag'


    -- Telescope
    use 'nvim-lua/plenary.nvim' -- Utilities
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-telescope/telescope-file-browser.nvim'

    -- Icons
    use 'kyazdani42/nvim-web-devicons'

    -- Tabs
    use 'akinsho/nvim-bufferline.lua'

    -- Utilities
    use 'norcalli/nvim-colorizer.lua'

    -- LSP Saga
    use 'glepnir/lspsaga.nvim' -- LSP UIs

    -- Additional LSP
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'

    -- Code formatting
    -- use 'jose-elias-alvarez/null-ls.nvim'

    -- Git
    use 'lewis6991/gitsigns.nvim'
    use 'dinhhuy258/git.nvim'

    -- GraphQL
    use 'jparise/vim-graphql'

    -- TimeTrackers
    use 'wakatime/vim-wakatime'

    use {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end
    }

    -- NPM integrations
    use {
        'David-Kunz/cmp-npm',
        requires = {
            'nvim-lua/plenary.nvim'
        }
    }

    -- Indent
    use "lukas-reineke/indent-blankline.nvim"

    -- Startup Screen
    use {
        'glepnir/dashboard-nvim',
        event = 'VimEnter',
        config = function()
            require('dashboard').setup {
            }
        end
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
