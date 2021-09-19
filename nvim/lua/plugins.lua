-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only requirednvim-compe if you have packer configured as `opt`
-- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()
vim.cmd [[packadd cfilter]]

return require('packer').startup(function(use)
  ---- Packer can manage itself
  use {
    'wbthomason/packer.nvim',
    log = { level = 'error' }
  }

  -- Close jsx tags
  use {
    'windwp/nvim-ts-autotag',
    config = function ()
      require('nvim-ts-autotag').setup()
    end
  }

  -- Debugger
  use{
    'mfussenegger/nvim-dap',
    config=function ()
      require("config.dap").setup()
    end
  }

  --use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

  use "ray-x/lsp_signature.nvim"

  -- Save session on close
  use {
    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup{
        auto_save_enabled = true
      }
    end
  }

  -- tree viewer (This disables Netrw!!) -- there's an option to prevent it from hijacking netrw
  -- use {
  --     'kyazdani42/nvim-tree.lua',
  --     requires = 'kyazdani42/nvim-web-devicons'
  -- }
  --use 'brooth/far.vim'
  --

  use {'nvim-treesitter/nvim-treesitter-textobjects', branch = '0.5-compat'}
  use {
    'nvim-treesitter/nvim-treesitter',
    branch = '0.5-compat',
    run = '<cmd>TSUpdate',
    config = function ()
      require("config.treesitter").setup()
    end
  }


  use { "neovim/nvim-lspconfig" }

  -- typescript server somewhat lacking, so additional functionality availabile in vscode and tsserver
  -- Didn't solve react import issues
  -- use {"jose-elias-alvarez/nvim-lsp-ts-utils"}

  -- Default tree sitter parser for graphql doesn't seem to be working
  use "jparise/vim-graphql"

  -- Configurable fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
    config = function ()
      require('config.telescope').setup()
    end
  }

  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use {'nvim-telescope/telescope-dap.nvim'}

  -- Completion that taps into lsp, snippets, etc.
  -- use{
  --   'hrsh7th/nvim-compe',
  --   config = function ()
  --     require("config.compe").setup()
  --   end
  -- }
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
    },
    config = function()
      local cmp = require'cmp'
      vim.o.completeopt = 'menuone,noselect'
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
          -- expand = function(args)
          --   require('luasnip').lsp_expand(args.body)
          -- end,
        },
        mapping = {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'vsnip' },
          -- { name = 'luasnip' },
        }
      })
    end
  }

  -- Improved cursor movement
  use 'ggandor/lightspeed.nvim' -- fix up

  -- Multiline commenter
  use {
    'scrooloose/nerdcommenter',
    config = function()
      vim.cmd([[
      let NERDSpaceDelims=1
      let g:NERDDefaultAlign = 'left'
      ]])
    end
  }
  --use 'tpope/vim-commentary'

  -- Snippets
  --use 'honza/vim-snippets'

  -- BEWARE: This may be slowing down my vim
  -- use{
  --   'L3MON4D3/LuaSnip',
  --   config=function ()
  --     require("config.luasnip").setup()
  --   end
  -- }

  -- Git integration
  use {
    'tpope/vim-fugitive',
    config=function ()
      vim.api.nvim_set_keymap('n', '<leader>gs', "<cmd>Git<CR>", {})
      -- Note that the semicolon is mapped to colon
      vim.api.nvim_set_keymap('n', '<leader>g<space>', ";Git ", {})
      vim.api.nvim_set_keymap('n', '<leader>gb', "<cmd>Git blame<CR>", {})
      -- Using diffview plugin to show differences now
      -- vim.api.nvim_set_keymap('n', '<leader>gh', "<cmd>0Gclog<CR>", {})
      -- vim.api.nvim_set_keymap('n', '<leader>gd', "<cmd>Gvdiffsplit<CR>", {})
    end
  }
  use 'tpope/vim-rhubarb'

  -- Pair up enclosing characters
  use 'jiangmiao/auto-pairs'

  -- Insert/replace/delete typeof brackets
  use 'tpope/vim-surround'

  -- Floating terminal implementation
  -- use {
  --   'voldikss/vim-floaterm',
  --   config=function ()
  --     require("config.floaterm").setup()
  --   end
  -- }

  use {
    "akinsho/nvim-toggleterm.lua",
    config = function()
      require('config.toggleterm').setup()
    end
  }

  -- Language server for intellisense code completion
  -- use 'neoclide/coc.nvim', {'branch': 'release'}

  -- Vim sugar for unix shell command
  use 'tpope/vim-eunuch'

  -- Extra useful shortcuts
  use 'tpope/vim-unimpaired'

  -- Ability to apply repeat '.' to some commands
  use 'tpope/vim-repeat'

  -- very useful fuzzy finder
  -- may not work cause I removed something
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'

  -- Ranger
  use{
    'francoiscabrol/ranger.vim',
    config = function ()
      vim.cmd[[
      let g:ranger_map_keys = 0
      let g:no_plugin_maps = 1
      let g:ranger_replace_netrw = 1
      ]]
      vim.api.nvim_set_keymap('n', '-', "<cmd>Ranger<CR>", {})
    end,
    requires = 'rbgrouleff/bclose.vim'
  }

  use {
    'rbgrouleff/bclose.vim',
    config=function ()
      vim.api.nvim_set_keymap('n', 'ZC', "<cmd>Bclose<CR>", {})
    end
  }

  -- Bracket colors
  use 'p00f/nvim-ts-rainbow'

  --- Latex Plugins ---
  --use 'lervag/vimtex'
  use 'Konfekt/FastFold'
  use 'matze/vim-tex-fold'

  --- R ---
  use 'vim-pandoc/vim-pandoc'
  use 'vim-pandoc/vim-rmarkdown'
  use 'vim-pandoc/vim-pandoc-syntax'

  -- R markdown
  use 'jalvesaq/Nvim-R'

  --- CMake ---
  use 'pboettch/vim-cmake-syntax'

  --- All syntax hightlighting (now using tree sitter) ---
  -- use 'sheerun/vim-polyglot'

  --- Note taking and work planning ---
  use 'vimwiki/vimwiki'
  use 'mattn/calendar-vim'


  --- Intutive book marks ---
  use 'MattesGroeger/vim-bookmarks'

  use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}

  use {'andymass/vim-matchup', event = 'VimEnter'}

  -- Disabling ale for now - currenty using efm with eslint for my diagnostics
  --use {
  --'w0rp/ale',
  --ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex', 'js', 'ts', 'jsx', 'tsx', 'lua'},
  --cmd = 'ALEEnable',
  --config = 'vim.cmd[[ALEEnable]]'
  --}

  use {'dracula/vim', as = 'dracula'}

  use {
    'morhetz/gruvbox',
    as = 'gruvbox',
    config = function()
      vim.api.nvim_command('colorscheme gruvbox') -- requires plugin installed
      vim.cmd[[
      hi DiffAdd      gui=none    guifg=NONE          guibg=#bada9f
      hi DiffChange   gui=none    guifg=NONE          guibg=#fae8b9
      hi DiffDelete   gui=bold    guifg=#ff8080       guibg=#ffb0b0
      hi DiffText     gui=none    guifg=NONE          guibg=#fff18c
      hi Visual     gui=none    guifg=NONE          guibg=#FFD580
      ]]
    end
  }

  use {'jez/vim-colors-solarized'}
  -- use 'vim-airline/vim-airline'

  use({
    "hoob3rt/lualine.nvim",
    event = "VimEnter",
    -- config = [[require('config.lualine')]],
    config = function()
      require("lualine").setup{
        options = {theme = 'gruvbox_light'},
      }
    end,
    wants = "nvim-web-devicons",
  })

  use {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
      vim.api.nvim_set_keymap('n', '<leader>z', "<cmd>ZenMode<CR>", {})
    end
  }
  -- Lua
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  -- colour virtual text from diagnostics
  use 'folke/lsp-colors.nvim'

  use {
    'mhartington/formatter.nvim',
    config = function ()
      require("config.formatter").setup()
    end
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function ()
      require("config.gitsigns").setup()
    end
  }

  -- Trying to get testing working for mocha
  -- let g:test#javascript#mocha#executable = 'npx mocha --colors --recursive --timeout 0 --check-leaks --require source-map-support/register --globals database,models --require dist/common/test/init --exit ./dist/common/test'
  use {
    'vim-test/vim-test',
    config = function ()
      vim.cmd[[
      let g:test#javascript#runner = "mocha"
      let g:test#javascript#mocha#options = '--colors --recursive --timeout 0 --check-leaks --require source-map-support/register --globals database,models --require dist/common/test/init '
      let g:test#javascript#mocha#executable = 'make compile && npx mocha'
      let g:test#javascript#mocha#file_pattern = '.*'
      let test#project_root = "~/awayco-monorepo/backend"
      let test#strategy = "neovim"
      let g:test#runner_commands = ['Mocha']
      let g:test#preserve_screen = 1
      ]]
    end
  }

  -- use { "rcarriga/vim-ultest", requires = {"vim-test/vim-test"}, run = ":UpdateRemotePlugins" }


  -- Documention generator I think
  use { 'kkoomen/vim-doge' }

  -- Github cli wrapper
  use { 'pwntester/octo.nvim',
    config = function()
      require"octo".setup()
    end,
    requires = {
      'nvim-telescope/telescope.nvim',
    },
  }

  -- Nice diff view for file history and git staging
  use {'sindrets/diffview.nvim',
    config = function ()
      require('config.diffview').setup()
    end
  }

  -- add extra functionality to the quickfix list
  use {'kevinhwang91/nvim-bqf'}
end)


