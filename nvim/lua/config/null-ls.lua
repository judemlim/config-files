local M = {}

function M.setup()
  local status_ok, actions = pcall(require, "null-ls")
  if not status_ok then
    print("Error loading null-ls")
    return
  end
  require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.formatting.eslint,
        require("null-ls").builtins.diagnostics.eslint,
        -- require("null-ls").builtins.completion.spell,
        require("null-ls").builtins.code_actions.eslint, -- Why not working?
    },
  })
end


return M
