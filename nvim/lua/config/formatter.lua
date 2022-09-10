local M = {}

function M.setup()
  local status_ok, actions = pcall(require, "formatter")

  if not status_ok 


  then

    -- TODO Better error handling
    print("Error loading formatter")
    return

  end

  require("formatter").setup({
    logging = true,
    filetype = {
      javascript = {
        -- prettier
        function()
          return {
            exe = "prettier",
            args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
            stdin = true,
          }
        end,
      },
      typescript = {
        -- prettier
        function()
          return {
            exe = "npx prettier",
            args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
            stdin = true,
          }
        end,
      },
      typescriptreact = {
        -- prettier
        function()
          return {
            exe = "npx prettier",
            args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
            stdin = true,
          }
        end,
      },
      rust = {
        -- Rustfmt
        function()
          return {
            exe = "rustfmt",
            args = { "--emit=stdout" },
            stdin = true,
          }
        end,
      },
      lua = {
        -- luafmt
        function()
          return {
            exe = "stylua",
            args = {
              "--config-path " .. "~/.config/stylua/stylua.toml",
              "-",
            },
            stdin = true,
          }
        end,
      },
    },
  })
  vim.api.nvim_set_keymap("n", "<leader>F", "<cmd>Format<CR>", {})
end

return M
