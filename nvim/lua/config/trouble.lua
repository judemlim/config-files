local M = {}

function M.setup()
  local status_ok, actions = pcall(require, "trouble")
  -- Lua
  -- use {
  --   "folke/trouble.nvim",
  --   requires = "kyazdani42/nvim-web-devicons",
  --   config = function()
  --     require("trouble").setup {
  --       -- your configuration comes here
  --       -- or leave it empty to use the default settings
  --       -- refer to the configuration section below
  --     }
  --     vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>", { silent = true, noremap = true })
  --     vim.api.nvim_set_keymap(
  --       "n",
  --       "<leader>xw",
  --       "<cmd>Trouble lsp_workspace_diagnostics<cr>",
  --       { silent = true, noremap = true }
  --     )
  --     vim.api.nvim_set_keymap(
  --       "n",
  --       "<leader>xd",
  --       "<cmd>Trouble lsp_document_diagnostics<cr>",
  --       { silent = true, noremap = true }
  --     )
  --     vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>", { silent = true, noremap = true })
  --     vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", { silent = true, noremap = true })
  --     vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>", { silent = true, noremap = true })
  --   end,
  -- }
end

return M
