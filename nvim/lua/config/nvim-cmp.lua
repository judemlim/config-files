local M = {}

function M.setup()
  local status_ok, _ = pcall(require, "cmp")
  if not status_ok then
    print("Error loading cmp")
    return
  end
  local cmp = require "cmp"
  vim.o.completeopt = "menuone,noselect"
  cmp.setup {
    snippet = {
      -- expand = function(args)
      --   vim.fn["vsnip#anonymous"](args.body)
      -- end,
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<Tab>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
      ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "buffer" },
      { name = "path" },
      { name = "neorg" },
      -- { name = "vsnip" },
      { name = 'luasnip' }
    },
  }
end


return M
