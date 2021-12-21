require "general"
require "plugins"
-- require "plugins-config"
require "lsp"
vim.api.nvim_set_keymap('n', '<leader>E', "<cmd>!eslint --fix %<CR>", {})
