local status, colorizer = pcall(require, "colorizer")
if (not status) then return end

colorizer.setup({
    filetypes = {
        'html',
        'css',
        'javascript',
        'typescript',
        'typescriptreact',
        'javascriptreact',
        'lua'
    },
})
