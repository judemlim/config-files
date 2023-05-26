local M = {}
function M.setup()

  local status_ok, _ = pcall(require, "null-ls")
  if not status_ok then
    print("Error loading null-ls")
    return
  end
  require("null-ls").setup({
    sources = {
        -- require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.formatting.eslint,
        -- require("null-ls").builtins.diagnostics.eslint, -- Need to to turn off annoying virtual text
        -- require("null-ls").builtins.completion.spell, -- BEWARE: Why does this overwrite gq???!!
        require("null-ls").builtins.code_actions.eslint, -- Why not working?
    },
  })
end


return M
