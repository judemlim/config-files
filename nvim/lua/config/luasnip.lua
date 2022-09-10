local M = {}

function M.setup()
  local status_ok, actions = pcall(require, "luasnip")
  if not status_ok then
    -- TODO Better error handling
    print("Error loading luasnip")
    return
  end

  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  local check_back_space = function()
    local col = vim.fn.col '.' - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' then
      return true
    else
      return false
    end
  end

local luasnip = require 'luasnip'
  -- lua snippots
  _G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t '<C-n>'
    elseif luasnip.expand_or_jumpable() then
      return t '<Plug>luasnip-expand-or-jump'
    elseif check_back_space() then
      return t '<Tab>'
    else
      return vim.fn['compe#complete']()
    end
  end

  _G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t '<C-p>'
    elseif luasnip.jumpable(-1) then
      return t '<Plug>luasnip-jump-prev'
    else
      return t '<S-Tab>'
    end
  end

  -- Map tab to the above tab complete functiones
  vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', { expr = true })
  vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', { expr = true })
  vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })
  vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })
end

return M
