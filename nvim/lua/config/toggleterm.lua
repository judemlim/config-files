local M = {}

function M.setup()
  local status_ok, actions = pcall(require, "toggleterm")
  if not status_ok then
    print("Error loading toggleterm")
    return
  end
require("toggleterm").setup{
  -- size can be a number or function which is passed the current terminal
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.3
    end
  end,

  open_mapping = [[<c-a>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = false,
  shading_factor =  0, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  persist_size = true,
  --direction = 'vertical' | 'horizontal' | 'window' | 'float',
  direction ='horizontal',
  close_on_exit = false, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
 -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_win_open'
    -- see :h nvim_win_open for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    --border = 'single' | 'double' | 'shadow' | 'curved',
    border = 'double',
    width = function()
      return math.floor(vim.o.columns*0.95)
    end,
    height = function()
      return math.floor(vim.o.lines*0.8)
    end,
    winblend = 3,
    highlights = {
      border = "Normal",
      background = "Normal",
    }
  }
}
-- vim.api.nvim_set_keymap("n", "<C-t>", "<cmd>ToggleTerm dir=%:h:p<CR>", {noremap = true})
-- vim.api.nvim_set_keymap("n", "<C-t>", "<cmd>ToggleTerm<CR>", {noremap = true})
-- local opts = {noremap = true}
-- vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
-- vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
-- vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
-- vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
-- vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
-- vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
-- if you only want these mappings for toggle term use term://*toggleterm#* instead
-- vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- Think of a program I would like to run in - lazygit?
-- local Terminal = require("toggleterm.terminal").Terminal
--local cwd_terminal = Terminal:new({ cmd = "cd $:p:h", count = 2 })
--toggle_current_directory = function()
  --current_directory_terminal:toggle()
--end

vim.api.nvim_set_keymap(
  "n",
  "<leader>m",
  [[<cmd>2TermExec cmd="cd %:p:h"<CR>]],
  {noremap = true, silent = true}
)

end


return M

