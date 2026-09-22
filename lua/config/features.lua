-- Keep machine-specific choices out of the shared config.
local features = {
  kotlin_lsp = false,
}

local local_config = vim.fn.stdpath('config') .. '/lua/config/local.lua'
if vim.uv.fs_stat(local_config) then
  features = vim.tbl_extend('force', features, require('config.local'))
end

return features
