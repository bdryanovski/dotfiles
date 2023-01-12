local status, github = pcall(require, "github-theme")
if (not status) then return end


github.setup({
  theme_style = "dimmed",
  function_style = "italic",
  sidebars = { "qf", "vista_kind", "terminal", "packer" },

  -- Change the "hint" color to the "orange" color, and make the "error" color bright red
  colors = { hint = "orange", error = "#ff0000" },

})
