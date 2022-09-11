
vim.api.nvim_command('colorscheme gruvbox') -- requires plugin installed

-- better comenting on NerdCommenter
vim.cmd([[
let NERDSpaceDelims=1
let g:NERDDefaultAlign = 'left'
]])

-- netrw
vim.cmd([[
let g:netrw_liststyle=3
]])

-- Ranger
vim.cmd([[let g:ranger_map_keys = 0]])
vim.cmd([[let g:no_plugin_maps = 1]])
vim.api.nvim_set_keymap('n', '<leader>ra', "<cmd>:Ranger<CR>", {})

-- Bclose
vim.api.nvim_set_keymap('n', 'ZC', "<cmd>:Bclose<CR>", {})

-- fugitive mappings
vim.api.nvim_set_keymap('n', '<leader>gs', "<cmd>:Git<CR>", {})
vim.api.nvim_set_keymap('n', '<leader>g<space>', ":Git ", {})
vim.api.nvim_set_keymap('n', '<leader>gb', "<cmd>:Git blame<CR>", {})
vim.api.nvim_set_keymap('n', '<leader>gh', "<cmd>:0Gclog<CR>", {})
vim.api.nvim_set_keymap('n', '<leader>gd', "<cmd>:Gvdiffsplit<CR>", {})

--require('lualine').setup{
  --options = { theme = 'gruvbox_light' }
--}
require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    mappings = {
      i = {
	["<c-d>"] = require("telescope.actions").delete_buffer,
	-- Right hand side can also be the name of the action as a string
	--["<c-d>"] = "delete_buffer",
        ["<C-Down>"] = require('telescope.actions').cycle_history_next,
        ["<C-Up>"] = require('telescope.actions').cycle_history_prev,
        ["<C-s>"] = require("telescope.actions").send_to_qflist + require('telescope.actions').open_qflist,
        ["<C-S>"] = require("telescope.actions").send_selected_to_qflist + require('telescope.actions').open_qflist,
        ["<C-a>"] = require("telescope.actions").add_to_qflist + require('telescope.actions').open_qflist,
        ["<C-A>"] = require("telescope.actions").add_selected_to_qflist + require('telescope.actions').open_qflist,

      },
      n = {
	["<c-d>"] = require("telescope.actions").delete_buffer,
      }
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    path_display = {},
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  }
}

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
-- require('telescope').load_extension('dap')


vim.api.nvim_set_keymap('n', '<leader>z', "<cmd>:ZenMode<CR>", {})
--vim.cmd([[inoremap <silent><expr> <C-Space>      compe#complete()]])
--vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
--vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", { expr = true })
--vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
--vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
-- require("toggleterm").setup{
--   -- size can be a number or function which is passed the current terminal
--   size = function(term)
--     if term.direction == "horizontal" then
--       return 15
--     elseif term.direction == "vertical" then
--       return vim.o.columns * 0.4
--     end
--   end,
--   open_mapping = '<C-t>',
--   hide_numbers = true, -- hide the number column in toggleterm buffers
--   shade_filetypes = {},
--   shade_terminals = false,
--   shading_factor =  3, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
--   start_in_insert = true,
--   insert_mappings = true, -- whether or not the open mapping applies in insert mode
--   persist_size = true,
--   --direction = 'vertical' | 'horizontal' | 'window' | 'float',
--   direction ='horizontal',
--   close_on_exit = true, -- close the terminal window when the process exits
--   shell = vim.o.shell, -- change the default shell
--  -- This field is only relevant if direction is set to 'float'
--   float_opts = {
--     -- The border key is *almost* the same as 'nvim_win_open'
--     -- see :h nvim_win_open for details on borders however
--     -- the 'curved' border is a custom border type
--     -- not natively supported but implemented in this plugin.
--     --border = 'single' | 'double' | 'shadow' | 'curved',
--     border = 'double',
--     width = function()
--       return math.floor(vim.o.columns*0.95)
--     end,
--     height = function()
--       return math.floor(vim.o.lines*0.8)
--     end,
--     winblend = 3,
--     highlights = {
--       border = "Normal",
--       background = "Normal",
--     }
--   }
-- }
-- vim.api.nvim_set_keymap("n", "<C-T>", "<cmd>ToggleTerm dir=%:h:p<CR>", {noremap = true})
-- local opts = {noremap = true}
-- vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
-- vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
-- vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
-- vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
-- vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
-- vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
-- vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

---- Think of a program I would like to run in - lazygit?
--local Terminal = require("toggleterm.terminal").Terminal
----local cwd_terminal = Terminal:new({ cmd = "cd $:p:h", count = 2 })
----toggle_current_directory = function()
  ----current_directory_terminal:toggle()
----end
--
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
  map <F6> :FloatermNew! cd %:p:h<CR>
  " map <C-t> :FloatermToggle<CR>
]]

vim.api.nvim_set_keymap(
  "n",
  "<leader>m",
  [[<cmd>2TermExec cmd="cd %:p:h"<CR>]],
  {noremap = true, silent = true}
)

-- Vim Dap
local dap = require("dap")
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/vscode-node-debug2/out/src/nodeDebug.js'},
  --args = {'test'},
  --args = {os.getenv('HOME') .. '/vscode-node-debug2/out/src/nodeDebug.js'},
}
dap.configurations.typescript = {
  {
    host = '127.0.0.1',
    -- Check if I can dynamicall change the port?
    -- Is it possible to have multiple
    port = function()
      local path = vim.api.nvim_buf_get_name(0)
      if string.find(path, 'scheduler')
      then
	return 9231
      elseif string.find(path, 'worker')
      then
	return 9230
      else
	return 9229
      end
    end,
    type = 'node2',
    request = 'attach',
    name = 'debug',
    --program = '~/debug/test.js',
    --program = '${workspaceFolder}/${file}',
    cwd = vim.fn.getcwd(),
    scurceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
}
dap.configurations.javascript = {
  {
    host = '127.0.0.1',
    -- Check if I can dynamicall change the port?
    -- Is it possible to have multiple
    port = 9229,
    type = 'node2',
    request = 'attach',
    name = 'debug',
    --program = '~/debug/test.js',
    --program = '${workspaceFolder}/${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
}

--attach_dap = function()
  --print("attaching")
  --dap.run({
    --type = 'node2',
    --request = 'attach',
    --cwd = vim.fn.getcwd(),
    --sourceMaps = true,
    --protocol = 'inspector',
    ----skipFiles = {'<node_internals>/**/*.js'},
  --})
  --print("finished")
--end

vim.api.nvim_set_keymap('n', '<leader>dt', [[<cmd>lua require'dap'.toggle_breakpoint()<cr>]], {})
vim.api.nvim_set_keymap('n', '<leader>da', [[<cmd>lua require'dap'.list_breakpoints()<CR>]], {})
--vim.api.nvim_set_keymap('n', '<leader>da', [[<cmd>lua attach_dap()<cr>]], {})
vim.api.nvim_set_keymap('n', '<leader>dc', [[<cmd>lua require'dap'.continue()<cr>]], {})
vim.api.nvim_set_keymap('n', '<leader>ds', [[<cmd>lua require'dap'.close()<cr>]], {})
vim.api.nvim_set_keymap('n', '<leader>d_', [[<cmd>lua require'dap'.disconnect();require'dap'.close();require'dap'.run_last()<CR>]], {})
vim.api.nvim_set_keymap('n', '<leader>dn', [[<cmd>lua require'dap'.step_over()<CR>]], {})
vim.api.nvim_set_keymap('n', '<leader>dk', [[<cmd>lua require'dap'.up()<CR>]], {})
vim.api.nvim_set_keymap('n', '<leader>dj', [[<cmd>lua require'dap'.down()<CR>]], {})
vim.api.nvim_set_keymap('n', '<leader>dh', [[<cmd>lua require'dap'.step_out()<CR>]], {})
vim.api.nvim_set_keymap('n', '<leader>dl', [[<cmd>lua require'dap'.step_into()<CR>]], {})
vim.api.nvim_set_keymap('n', '<leader>di', [[<cmd>lua require'dap.ui.variables'.hover()<CR>]], {})
vim.api.nvim_set_keymap('n', '<leader>di', [[<cmd>lua require'dap.ui.variables'.visual_hover()<CR>]], {})
vim.api.nvim_set_keymap('n', '<leader>di', [[<cmd>lua require'dap.ui.widgets'.hover()<CR>]], {})
vim.api.nvim_set_keymap('n', '<leader>d?', [[<cmd>:lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>]], {})


--require("dapui").setup({
  --icons = {
    --expanded = "▾",
    --collapsed = "▸"
  --},
  --mappings = {
    ---- Use a table to apply multiple mappings
    --expand = {"<CR>", "<2-LeftMouse>"},
    --open = "o",
    --remove = "d",
    --edit = "e",
  --},
  --sidebar = {
    --open_on_start = true,
    --elements = {
      ---- You can change the order of elements in the sidebar
      --"scopes",
      --"breakpoints",
      --"stacks",
      --"watches"
    --},
    --width = 40,
    --position = "left" -- Can be "left" or "right"
  --},
  --tray = {
    --open_on_start = true,
    --elements = {
      --"repl"
    --},
    --height = 10,
    --position = "bottom" -- Can be "bottom" or "top"
  --},
  --floating = {
    --max_height = nil, -- These can be integers or a float between 0 and 1.
    --max_width = nil   -- Floats will be treated as percentage of your screen.
  --}
--})
-- nerd commenter fix

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

-- Map compe confirm and complete functions
vim.api.nvim_set_keymap('i', '<cr>', 'compe#confirm("<cr>")', { expr = true })
vim.api.nvim_set_keymap('i', '<c-space>', 'compe#complete()', { expr = true })

require('formatter').setup({
  logging = false,
  filetype = {
    javascript = {
        -- prettier
       function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)},
            stdin = true
          }
        end
    },
    typescript = {
        -- prettier
       function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)},
            stdin = true
          }
        end
    },
    rust = {
      -- Rustfmt
      function()
        return {
          exe = "rustfmt",
          args = {"--emit=stdout"},
          stdin = true
        }
      end
    },
    lua = {
        -- luafmt
        function()
          return {
            exe = "luafmt",
            args = {"--indent-count", 2, "--stdin"},
            stdin = true
          }
        end
      }
  }
})
vim.api.nvim_set_keymap('n', '<leader>F', "<cmd>Format<CR>", {})
-- primarily being used for organising imports
vim.api.nvim_set_keymap('n', '<leader>E', "<cmd>!eslint --fix %<CR>", {})
-- Not working for some reason for ranged formatting

-- Git signs buggy
require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  numhl = false,
  linehl = false,
  -- Keymaps not attcheing to already open buffers in a session
  --keymaps = {
    ---- Default keymap options
    --noremap = true,
    ----buffer = true,

    --['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
    --['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

    --['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    --['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    --['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    --['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    --['v <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    --['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    --['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    --['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',

    ---- Text objects
    --['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    --['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
  --},
  watch_index = {
    interval = 1000,
    follow_files = true
  },
  current_line_blame = false,
  current_line_blame_delay = 1000,
  current_line_blame_position = 'eol',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  word_diff = false,
  use_internal_diff = true,  -- If luajit is present
}


vim.api.nvim_set_keymap('n', '<leader>hs', '<cmd>lua require"gitsigns".stage_hunk()<CR>', { expr = true })
vim.api.nvim_set_keymap('v', '<leader>hs', '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>', { expr = true })
vim.api.nvim_set_keymap('n', '<leader>hu', '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>', { expr = true })
vim.api.nvim_set_keymap('n', '<leader>hr', '<cmd>lua require"gitsigns".reset_hunk()<CR>', { expr = true })
vim.api.nvim_set_keymap('v', '<leader>hr', '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>', { expr = true })
vim.api.nvim_set_keymap('n', '<leader>hR', '<cmd>lua require"gitsigns".reset_buffer()<CR>', { expr = true })
vim.api.nvim_set_keymap('n', '<leader>hp', '<cmd>lua require"gitsigns".preview_hunk()<CR>', { expr = true })
vim.api.nvim_set_keymap('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line(true)<CR', { expr = true })
vim.api.nvim_set_keymap('n', ']c', '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>', { expr = true })
vim.api.nvim_set_keymap('n', '[c', '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>', { expr = true })


