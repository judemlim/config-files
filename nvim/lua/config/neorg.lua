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
      ["core.norg.journal"] = {},
      ["core.norg.manoeuvre"] = {},
      -- ["core.gtd.base"] = {},
      ["core.norg.qol.toc"] = {},
      ["core.norg.concealer"] = {},
      -- ["core.norg.completion"] = {},
      ["core.norg.dirman"] = {
        config = {
            workspaces = {
                my_ws = "~/neorg", -- Format: <name_of_workspace> = <path_to_workspace_root>
            },
            autochdir = true, -- Automatically change the directory to the current workspace's root every time
            index = "index.norg", -- The name of the main (root) .norg file
        }
      }
    }
  }
end

return M
