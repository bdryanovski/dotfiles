local keymap = vim.keymap

local silent = { silent = true }

keymap.set('n', '<leader>nh', ":nohl<CR>", silent)

keymap.set('n', 'x', '_x')

-- Increment/Decrement numbers
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Delete word
-- keymap.set('n', 'dw', 'vb"_d')

-- Go to first non blank character
keymap.set('n', 'H', '^', silent)

-- Move selected line / block of text in visual mode
keymap.set("x", "K", ":move '<-2<CR>gv-gv", silent)
keymap.set("x", "J", ":move '>+1<CR>gv-gv", silent)

-- Select all text
keymap.set('n', '<C-a>', 'gg<S-v>G')

-- New tab
keymap.set('n', 'te', ':tabedit<Return>', { silent = true })
keymap.set('n', 'ss', ':split<Return><C-w>w', { silent = true })
keymap.set('n', 'sv', ':vsplit<Return><C-w>w', { silent = true })


-- Move across windows
keymap.set('n', '<Space>', '<C-w>w')

keymap.set('', 's<left>', '<C-w>h')
keymap.set('', 's<right>', '<C-w>l')
keymap.set('', 's<up>', '<C-w>k')
keymap.set('', 's<down>', '<C-w>j')

keymap.set('', 'sh', '<C-w>h')
keymap.set('', 'sl', '<C-w>l')
keymap.set('', 'sk', '<C-w>k')
keymap.set('', 'sh', '<C-w>j')


-- Resize
keymap.set('n', '<C-w><left>', '<C-w><')
keymap.set('n', '<C-w><right>', '<C-w>>')
keymap.set('n', '<C-w><up>', '<C-w>+')
keymap.set('n', '<C-w><down>', '<C-w>-')

-- Don't yank on delete char
keymap.set("n", "x", '"_x', silent)
keymap.set("n", "X", '"_X', silent)
keymap.set("v", "x", '"_x', silent)
keymap.set("v", "X", '"_X', silent)


-- Too lazy to learn it
-- https://neovim.io/doc/user/api.html#nvim_create_user_command()
vim.api.nvim_create_user_command('Q', 'q', {})
vim.api.nvim_create_user_command('WQ', 'wq', {})
vim.api.nvim_create_user_command('W', 'w', {})
