local status, cmpNpm = pcall(require, "cmp-npm")
if (not status) then return end


cmpNpm.setup({
  ignore = {},
  only_semantic_versions = true,
})
