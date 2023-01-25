local setup, nvimtree = pcall(require, "nvim-tree")
if (not setup) then return end


vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local HEIGHT_RATIO = 0.8 -- You can change this
local WIDTH_RATIO = 0.5 -- You can change this too

vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])


local tree_actions = {
    {
        name = "Create node",
        handler = require("nvim-tree.api").fs.create,
    },
    {
        name = "Remove node",
        handler = require("nvim-tree.api").fs.remove,
    },
    {
        name = "Trash node",
        handler = require("nvim-tree.api").fs.trash,
    },
    {
        name = "Rename node",
        handler = require("nvim-tree.api").fs.rename,
    },
    {
        name = "Fully rename node",
        handler = require("nvim-tree.api").fs.rename_sub,
    },
    {
        name = "Copy",
        handler = require("nvim-tree.api").fs.copy.node,
    },

    -- ... other custom actions you may want to display in the menu
}

local function tree_actions_menu(node)
    local entry_maker = function(menu_item)
        return {
            value = menu_item,
            ordinal = menu_item.name,
            display = menu_item.name,
        }
    end

    local finder = require("telescope.finders").new_table({
        results = tree_actions,
        entry_maker = entry_maker,
    })

    local sorter = require("telescope.sorters").get_generic_fuzzy_sorter()

    local default_options = {
        finder = finder,
        sorter = sorter,
        attach_mappings = function(prompt_buffer_number)
            local actions = require("telescope.actions")

            -- On item select
            actions.select_default:replace(function()
                local state = require("telescope.actions.state")
                local selection = state.get_selected_entry()
                -- Closing the picker
                actions.close(prompt_buffer_number)
                -- Executing the callback
                selection.value.handler(node)
            end)

            -- The following actions are disabled in this example
            -- You may want to map them too depending on your needs though
            actions.add_selection:replace(function() end)
            actions.remove_selection:replace(function() end)
            actions.toggle_selection:replace(function() end)
            actions.select_all:replace(function() end)
            actions.drop_all:replace(function() end)
            actions.toggle_all:replace(function() end)

            return true
        end,
    }

    -- Opening the menu
    require("telescope.pickers").new({ prompt_title = "Tree menu" }, default_options):find()
end

nvimtree.setup({
    auto_reload_on_write = true,
    disable_netrw = false,
    hijack_cursor = false,
    hijack_netrw = true,
    hijack_unnamed_buffer_when_opening = false,
    ignore_buffer_on_setup = false,
    open_on_setup = false,
    open_on_setup_file = false,
    sort_by = "name",
    root_dirs = {},
    prefer_startup_root = false,
    sync_root_with_cwd = false,
    reload_on_bufenter = false,
    respect_buf_cwd = false,
    on_attach = "disable",
    remove_keymaps = false,
    select_prompts = false,
    view = {
        adaptive_size = false,
        centralize_selection = false,
        hide_root_folder = false,
        side = "left",
        preserve_window_proportions = false,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
        mappings = {
            custom_only = false,
            list = {
                { key = "<space>", action = "tree actions", action_cb = tree_actions_menu }
                -- user mappings go here
            },
        },
        width = function()
            return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        end,
        float = {
            enable = true,
            quit_on_focus_loss = true,
            open_win_config = function()
                local screen_w = vim.opt.columns:get()
                local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                local window_w = screen_w * WIDTH_RATIO
                local window_h = screen_h * HEIGHT_RATIO
                local window_w_int = math.floor(window_w)
                local window_h_int = math.floor(window_h)
                local center_x = (screen_w - window_w) / 2
                local center_y = ((vim.opt.lines:get() - window_h) / 2)
                    - vim.opt.cmdheight:get()
                return {
                    border = 'rounded',
                    relative = 'editor',
                    row = center_y,
                    col = center_x,
                    width = window_w_int,
                    height = window_h_int,
                }
            end,
        },
    },
    renderer = {
        add_trailing = false,
        group_empty = false,
        highlight_git = false,
        full_name = false,
        highlight_opened_files = "name",
        root_folder_label = ":~:s?$?/..?",
        indent_width = 2,
        indent_markers = {
            enable = true,
            inline_arrows = false,
            icons = {
                corner = "└",
                edge = "│",
                item = "│",
                bottom = "─",
                none = " ",
            },
        },
        icons = {
            webdev_colors = true,
            git_placement = "before",
            padding = " ",
            symlink_arrow = " ➛ ",
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                default = "",
                symlink = "",
                bookmark = "",
                folder = {
                    arrow_closed = "", -- "",arrow when folder is closed
                    arrow_open = "", -- "",arrow when folder is open
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = "",
                },
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★",
                    deleted = "",
                    ignored = "◌",
                },
            },
        },
        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "package.json" },
        symlink_destination = true,
    },
    hijack_directories = {
        enable = true,
        auto_open = true,
    },
    update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {},
    },
    ignore_ft_on_setup = {},
    system_open = {
        cmd = "",
        args = {},
    },
    diagnostics = {
        enable = false,
        show_on_dirs = false,
        show_on_open_dirs = true,
        debounce_delay = 50,
        severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
        },
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    filters = {
        dotfiles = false,
        git_clean = false,
        no_buffer = false,
        custom = {},
        exclude = {},
    },
    filesystem_watchers = {
        enable = true,
        debounce_delay = 50,
        ignore_dirs = {},
    },
    git = {
        enable = true,
        ignore = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        timeout = 400,
    },
    actions = {
        use_system_clipboard = true,
        change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
        },
        expand_all = {
            max_folder_discovery = 300,
            exclude = {},
        },
        file_popup = {
            open_win_config = {
                col = 1,
                row = 1,
                relative = "cursor",
                border = "shadow",
                style = "minimal",
            },
        },
        open_file = {
            quit_on_open = false,
            resize_window = true,
            window_picker = {
                enable = false,
                chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                exclude = {
                    filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                    buftype = { "nofile", "terminal", "help" },
                },
            },
        },
        remove_file = {
            close_window = true,
        },
    },
    trash = {
        cmd = "gio trash",
        require_confirm = true,
    },
    live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = true,
    },
    tab = {
        sync = {
            open = false,
            close = false,
            ignore = {},
        },
    },
    notify = {
        threshold = vim.log.levels.INFO,
    },
    log = {
        enable = false,
        truncate = false,
        types = {
            all = false,
            config = false,
            copy_paste = false,
            dev = false,
            diagnostics = false,
            git = false,
            profile = false,
            watcher = false,
        },
    },
})

vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>', { silent = true })
