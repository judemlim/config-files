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
      ["core.journal"] = {
        config = {
          workspace = "neorg",
          strategy = "nested"
        }
      },
      -- ["core.manoeuvre"] = {},
      -- ["core.gtd.base"] = {
      --   config = {
      --     workspace = "gtd"
      --   }
      -- },
      ["core.qol.toc"] = {},
      ["core.concealer"] = {},
      -- ["core.integrations.telescope"] = {},
      ["core.completion"] = {
        config = { engine = "nvim-cmp" },
      },
      ["core.integrations.nvim-cmp"] = {},
      ["core.dirman"] = {
        config = {
            workspaces = {
              neorg = "~/neorg",
              default = "~/neorg",
              tech  = "~/neorg/tech",
              exercise  = "~/neorg/exercise",
              health  = "~/neorg/health",
              music  = "~/neorg/music",
              gtd  = "~/neorg/gtd",
              spanish  = "~/neorg/language/spanish",
              japanese  = "~/neorg/language/japanese",
              finance  = "~/neorg/finance",
              projects  = "~/neorg/projects",
              productivity  = "~/neorg/productivity",
              work  = "~/neorg/work",
            },
            autochdir = true, -- Automatically change the directory to the current workspace's root every time
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

  -- vim.api.nvim_set_keymap('n', '<leader>nw', '<cmd>Neorg workspace work<CR>', {silent = true, noremap = true})
  -- vim.api.nvim_set_keymap('n', '<leader>nh', '<cmd>Neorg workspace home<CR>', {silent = true, noremap = true})
  vim.api.nvim_set_keymap('n', '<leader>nn', '<cmd>Telescope neorg switch_workspace<CR>', {})

  vim.api.nvim_set_keymap('n', '<leader>nfl', '<cmd>Telescope neorg insert_file_link<CR>', {silent = true, noremap = true})

  -- Example of how to configure call dirman (and other modules)
  -- require("neorg.modules.core.norg.dirman.module").public.get_norg_files("tech")
 -- require("neorg.modules.core.norg.dirman.module").public.get_workspace_names()

end

return M
