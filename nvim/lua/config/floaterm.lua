local M = {}

function M.setup()
  -- local status_ok, actions = pcall(require, "floaterm")
  -- if not status_ok then
  --   -- TODO Better error handling
  --   print("Error loading floaterm")
  --   return
  -- end
  vim.cmd[[
  let g:floaterm_width = 0.95
  let g:floaterm_height = 0.95
  let g:floaterm_position='bottom'
  "let g:floaterm_autoinsert = v:false
  let g:floaterm_keymap_new    = '<F7>'
  let g:floaterm_keymap_prev   = '<F8>'
  let g:floaterm_keymap_next   = '<F9>'
  let g:floaterm_keymap_toggle = '<F12>'
  let g:floaterm_keymap_kill = '<F4>'
  map <F6> <cmd>FloatermNew! cd %:p:h<CR>
  " map <C-t> <cmd>FloatermToggle<CR>
  ]]
end


return M
