require "general"
require "plugins"
-- require "plugins-config"
require "lsp"
vim.api.nvim_set_keymap('n', '<leader>E', "<cmd>!eslint --fix %<CR>", {})
vim.cmd[[
let g:NERDCustomDelimiters={ 'javascript': { 'left': '//', 'right': '', 'leftAlt': '{/*', 'rightAlt': '*/}' } }
]]
