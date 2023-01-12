vim.cmd('autocmd!')

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.wo.number = true

vim.opt.title = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true

vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.scrolloff = 10
vim.opt.shell = 'zsh'

vim.opt.backupskip = '/tmp/*'

-- indentation
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.iskeyword:append("-") -- add dash as part of the word when selecting/deleting

-- line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- cursers
vim.opt.cursorline = true

vim.opt.inccommand = 'split'
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.ai = true -- auto indent
vim.opt.si = true -- smart indent
vim.opt.wrap = false -- don't wrap lines
vim.opt.backspace = 'start,eol,indent'
vim.opt.path:append { '**' } -- finding files - search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*' }

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = '*',
    command = 'set nopaste'
})

vim.opt.formatoptions:append { 'r' }

-- Leader key
vim.g.mapleader = ','


-- automatically update the content of the file when it change
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
    command = "if mode() != 'c' | checktime | endif",
    pattern = { "*" },
})
