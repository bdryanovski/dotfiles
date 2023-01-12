require('base')
require('highlights')
require('keymap')


local has = function(t)
    return vim.fn.has(t) == 1
end

local is_mac = has "macunix"


if is_mac then
    require('macos')
end


require('plugins')

local g = vim.g

g.neovide_scroll_animation_length = 0.3
g.neovide_hide_mouse_when_typing = true
g.neovide_refresh_rate = 60
g.neovide_refresh_rate_idle = 5
g.neovide_remember_window_size = true
g.neovide_profiler = false
-- g.neovide_cursor_animation_length = 0.08
g.neovide_cursor_trail_size = 0.8
g.neovide_cursor_antialiasing = true
g.neovide_cursor_vfx_mode = "ripple"

vim.opt.guifont = { "Fira Code", "h14" }
