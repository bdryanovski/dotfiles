return {
	{
		"sainnhe/sonokai",
		priority = 1000,
		config = function()
			vim.g.sonokai_transparent_background = "0"
			vim.g.sonokai_better_performance = "1"
			vim.g.sonokai_enable_italic = "1"
			vim.g.sonokai_disable_italic_comment = "0"
			vim.g.sonokai_dim_inactive_windows = "1"
			vim.g.sonokai_menu_selection_background = "green"
			vim.g.sonokai_diagnostic_text_highlight = 1
			vim.g.sonokai_diagnostic_line_highlight = 1
			vim.g.sonokai_diagnostic_virtual_text = "colored"
			vim.g.sonokai_current_word = "underline"
			vim.g.sonokai_inlay_hints_background = "dimmed"
			vim.g.sonokai_cursor = "red"
			vim.g.sonokai_style = "andromeda"
			-- vim.cmd.colorscheme("sonokai")
		end,
	},
	{
		"bluz71/vim-nightfly-guicolors",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			-- vim.cmd([[colorscheme nightfly]])
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
				transparent_background = false, -- disables setting the background color.
				show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
				term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
				dim_inactive = {
					enabled = true, -- dims the background color of inactive window
					shade = "dark",
					percentage = 0.15, -- percentage of the shade to apply to the inactive window
				},
				no_italic = false, -- Force no italic
				no_bold = false, -- Force no bold
				no_underline = false, -- Force no underline
				styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
					comments = { "italic" }, -- Change the style of comments
					conditionals = { "italic" },
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
				},
				color_overrides = {},
				custom_highlights = {},
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					treesitter = true,
					treesitter_context = true,
					which_key = true,
					telescope = true,
					notify = false,
					lsp_trouble = true,
					mini = {
						enabled = true,
						indentscope_color = "",
					},
					-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
				},
			})
			-- setup must be called before loading
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"folke/tokyonight.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- local bg = "#011628"
			-- local bg_dark = "#011423"
			-- local bg_highlight = "#143652"
			-- local bg_search = "#0A64AC"
			-- local bg_visual = "#275378"
			-- local fg = "#CBE0F0"
			-- local fg_dark = "#B4D0E9"
			-- local fg_gutter = "#627E97"
			-- local border = "#547998"

			require("tokyonight").setup({
				style = "moon",
				light_style = "day", -- The theme is used when the background is set to light
				transparent = false, -- Enable this to disable setting the background color
				terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
				styles = {
					-- Style to be applied to different syntax groups
					-- Value is any valid attr-list value for `:help nvim_set_hl`
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
					-- Background styles. Can be "dark", "transparent" or "normal"
					sidebars = "dark", -- style for sidebars, see below
					floats = "dark", -- style for floating windows
				},
				sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
				day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
				hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
				dim_inactive = false, -- dims inactive windows
				lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

				-- on_colors = function(colors)
				-- 	colors.bg = bg
				-- 	colors.bg_dark = bg_dark
				-- 	colors.bg_float = bg_dark
				-- 	colors.bg_highlight = bg_highlight
				-- 	colors.bg_popup = bg_dark
				-- 	colors.bg_search = bg_search
				-- 	colors.bg_sidebar = bg_dark
				-- 	colors.bg_statusline = bg_dark
				-- 	colors.bg_visual = bg_visual
				-- 	colors.border = border
				-- 	colors.fg = fg
				-- 	colors.fg_dark = fg_dark
				-- 	colors.fg_float = fg
				-- 	colors.fg_gutter = fg_gutter
				-- 	colors.fg_sidebar = fg_dark
				-- end,
			})
			-- load the colorscheme here
			-- vim.cmd([[colorscheme tokyonight]])
		end,
	},
}
