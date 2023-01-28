local status, shade = pcall(require, "shade")
if (not status) then return end

shade.setup({
    overlay_opacity = 50,
    opacity_step = 1,
    keys = {
        brightness_up = '<C-UP>',
        brightness_down = '<C-Down>',
        toggle = '<leader>ssss',
    }
})
