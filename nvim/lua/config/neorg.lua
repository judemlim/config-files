local M = {}

function M.setup()
  local status_ok, _ = pcall(require, "neorg")
  if not status_ok then
    -- TODO Better error handling
    print("Error loading neorg")
    return
  end
  require('neorg').setup {
    load = {
      ["core.defaults"] = {},
      ["core.norg.journal"] = {
        config = {
          workspace = "home",
          strategy = "nested"
        }
      },
      ["core.norg.manoeuvre"] = {},
      -- ["core.gtd.base"] = {},
      ["core.norg.qol.toc"] = {},
      ["core.norg.concealer"] = {},
      ["core.integrations.telescope"] = {},
      ["core.norg.completion"] = {
        config = { engine = "nvim-cmp" },
      },
      ["core.integrations.nvim-cmp"] = {},
      ["core.norg.dirman"] = {
        config = {
            workspaces = {
              home  = "~/neorg/home", -- Format: <name_of_workspace> = <path_to_workspace_root>
              work  = "~/neorg/work", -- Format: <name_of_workspace> = <path_to_workspace_root>
              knowledge_base  = "~/neorg/knowledge_base", -- Format: <name_of_workspace> = <path_to_workspace_root>
            },
            autochdir = false, -- Automatically change the directory to the current workspace's root every time
            index = "index.norg", -- The name of the main () .norg file
        }
      }
    }
  }
  vim.api.nvim_set_keymap('n', '<leader>ns', '<cmd>NeorgStart<CR>', {silent = true, noremap = true})
  vim.api.nvim_set_keymap('n', '<leader>nr', '<cmd>Neorg return<CR>', {silent = true, noremap = true})

  vim.api.nvim_set_keymap('n', '<leader>ny', '<cmd>Neorg journal yesterday<CR>', {silent = true, noremap = true})
  vim.api.nvim_set_keymap('n', '<leader>nt', '<cmd>Neorg journal today<CR>', {silent = true, noremap = true})
  vim.api.nvim_set_keymap('n', '<leader>nm', '<cmd>Neorg journal tomorrow<CR>', {silent = true, noremap = true})

  vim.api.nvim_set_keymap('n', '<leader>nw', '<cmd>Neorg workspace work<CR>', {silent = true, noremap = true})
  vim.api.nvim_set_keymap('n', '<leader>nh', '<cmd>Neorg workspace home<CR>', {silent = true, noremap = true})
  vim.api.nvim_set_keymap('n', '<leader>nk', '<cmd>Neorg workspace knowledge_base<CR>', {silent = true, noremap = true})

  vim.api.nvim_set_keymap('n', '<leader>nfl', '<cmd>Telescope neorg insert_file_link<CR>', {silent = true, noremap = true})

end

return M
