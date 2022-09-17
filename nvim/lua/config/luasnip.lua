local M = {}

function T(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.setup()
  local status_ok, _ = pcall(require, "luasnip")
  if not status_ok then
    -- TODO Better error handling
    print("Error loading luasnip")
    return
  end

  local luasnip = require("luasnip")
  luasnip.config.setup({
    history = false,
    -- Update more often, :h events for more info.
    updateevents = "TextChanged,TextChangedI",
  })

  --- <tab> to jump to next snippet's placeholder
  local function on_tab()
    return luasnip.jump(1) and "" or T("<Tab>")
  end

  --- <s-tab> to jump to next snippet's placeholder
  local function on_s_tab()
    return luasnip.jump(-1) and "" or T("<S-Tab>")
  end

  vim.keymap.set("i", "<Tab>", on_tab, { expr = true })
  vim.keymap.set("s", "<Tab>", on_tab, { expr = true })
  vim.keymap.set("i", "<S-Tab>", on_s_tab, { expr = true })
  vim.keymap.set("s", "<S-Tab>", on_s_tab, { expr = true })
  require("luasnip.loaders.from_vscode").lazy_load()
  end

return M
