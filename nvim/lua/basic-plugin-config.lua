
vim.api.nvim_command('colorscheme gruvbox') -- requires plugin installed

require'nvim-treesitter.configs'.setup {
  nsure_installed = {"javascript","typescript", "lua", "haskell"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  --ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    --disable = {"typescript", "javascript"},  -- list of language that will be disabled
  },
}


-- compe settings --
vim.o.completeopt = "menuone,noselect"

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  };
}
vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", { noremap = true, silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", { noremap = true, silent = true, expr = true })
--vim.api.nvim_set_keymap("i", "<C-e>", "compe#close('<C-e>')", { noremap = true, silent = true, expr = true })
--vim.api.nvim_set_keymap("i", "<C-f>", "compe#scroll({ 'delta': +4 })", { noremap = true, silent = true, expr = true })
--vim.api.nvim_set_keymap("i", "<C-d>", "compe#scroll({ 'delta': -4 })", { noremap = true, silent = true, expr = true })

vim.api.nvim_set_keymap('n', ',h', "<cmd>Telescope oldfiles<CR>", {})
vim.api.nvim_set_keymap('n', ',b', "<cmd>Telescope buffers<CR>", {})
vim.api.nvim_set_keymap('n', ',B', "<cmd>Telescope file_browser<CR>", {})
vim.api.nvim_set_keymap('n', ',g', "<cmd>Telescope git_files<CR>", {})
vim.api.nvim_set_keymap('n', ',f', "<cmd>Telescope find_files<CR>", {})
vim.api.nvim_set_keymap('n', ',l', "<cmd>Telescope live_grep<CR>", {})
vim.api.nvim_set_keymap('n', ',s', "<cmd>Telescope lsp_document_symbols<CR>", {})
vim.api.nvim_set_keymap('n', ',S', ":Telescope lsp_workspace_symbols query=", {})
vim.api.nvim_set_keymap('n', ',rS', ":Telescope lsp_workspace_symbols query=<c-r><c-w><CR>", {})
vim.api.nvim_set_keymap('n', ',rs', ":Rg <c-r><c-w><CR>", {})
vim.api.nvim_set_keymap('n', ',d', "<cmd>Telescope lsp_document_diagnostics<CR>", {})
vim.api.nvim_set_keymap('n', ',c', "<cmd>Telescope lsp_code_actions<CR>", {})

require('formatter').setup({
  logging = false,
  filetype = {
    javascript = {
        -- prettier
       function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), ' --arrow-parens avoid --function-paren-newline'},
            stdin = true
          }
        end
    },
    typescript = {
        -- prettier
       function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), '--single-quote --arrow-parens avoid --function-paren-newline'},
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
-- Not working for some reason for ranged formatting
--vim.api.nvim_set_keymap('v', '<leader>f', "<cmd>:Format<CR>", {})

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

require('lualine').setup{
  options = { theme = 'gruvbox_light' }
}
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
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

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
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,

    ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
    ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

    ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    ['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['v <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',

    -- Text objects
    ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
  },
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
  use_decoration_api = true,
  use_internal_diff = true,  -- If luajit is present
}

vim.api.nvim_set_keymap('n', '<leader>z', "<cmd>:ZenMode<CR>", {})
--vim.cmd([[inoremap <silent><expr> <C-Space>      compe#complete()]])
--vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
--vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", { expr = true })
--vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
--vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
--require("toggleterm").setup{
  ---- size can be a number or function which is passed the current terminal
  --size = function(term)
    --if term.direction == "horizontal" then
      --return 15
    --elseif term.direction == "vertical" then
      --return vim.o.columns * 0.4
    --end
  --end,
  --open_mapping = '<C-t>',
  --hide_numbers = true, -- hide the number column in toggleterm buffers
  --shade_filetypes = {},
  --shade_terminals = true,
  --shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  --start_in_insert = true,
  --insert_mappings = true, -- whether or not the open mapping applies in insert mode
  --persist_size = true,
  ----direction = 'vertical' | 'horizontal' | 'window' | 'float',
  --direction ='float',
  --close_on_exit = true, -- close the terminal window when the process exits
  --shell = vim.o.shell, -- change the default shell
 ---- This field is only relevant if direction is set to 'float'
  --float_opts = {
    ---- The border key is *almost* the same as 'nvim_win_open'
    ---- see :h nvim_win_open for details on borders however
    ---- the 'curved' border is a custom border type
    ---- not natively supported but implemented in this plugin.
    ----border = 'single' | 'double' | 'shadow' | 'curved',
    --border = 'double',
    --width = function()
      --return math.floor(vim.o.columns*0.95)
    --end,
    --height = function()
      --return math.floor(vim.o.lines*0.8)
    --end,
    --winblend = 3,
    --highlights = {
      --border = "Normal",
      --background = "Normal",
    --}
  --}
--}

---- Think of a program I would like to run in - lazygit?
--local Terminal = require("toggleterm.terminal").Terminal
----local cwd_terminal = Terminal:new({ cmd = "cd $:p:h", count = 2 })
----toggle_current_directory = function()
  ----current_directory_terminal:toggle()
----end

--vim.api.nvim_set_keymap(
  --"n",
  --"<leader>m",
  --[[<cmd>2TermExec cmd="cd %:p:h"<CR>]]
  --{noremap = true, silent = true}
--)



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

vim.api.nvim_set_keymap('n', '<leader>dh', [[<cmd>lua require'dap'.toggle_breakpoint()<cr>]], {})
vim.api.nvim_set_keymap('n', '<leader>da', [[<cmd>lua attach_dap()<cr>]], {})
vim.api.nvim_set_keymap('n', '<leader>dc', [[<cmd>lua require'dap'.continue()<cr>]], {})
vim.api.nvim_set_keymap('n', '<leader>ds', [[<cmd>lua require'dap'.stop()<cr>]], {})
vim.api.nvim_set_keymap('n', '<leader>d_', [[<cmd>lua require'dap'.disconnect();require'dap'.stop();require'dap'.run_last()<CR>]], {})
vim.api.nvim_set_keymap('n', '<leader>di', [[<cmd>lua require'dap.ui.variables'.hover()<CR>]], {})
vim.api.nvim_set_keymap('n', '<leader>di', [[<cmd>lua require'dap.ui.variables'.hover()<CR>]], {})
vim.api.nvim_set_keymap('n', '<leader>di', [[<cmd>lua require'dap.ui.variables'.visual_hover()<CR>]], {})
vim.api.nvim_set_keymap('n', '<leader>d?', [[<cmd>lua require'dap.ui.variables'.scopes()<CR>]], {})

