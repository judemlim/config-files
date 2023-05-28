-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only requirednvim-compe if you have packer configured as `opt`
-- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()
vim.cmd [[packadd cfilter]]

return require("packer").startup(function(use)
  ---- General ----
  use {
    "wbthomason/packer.nvim",
    log = { level = "error" },
  }
  use { "nvim-treesitter/playground" }
  use { "nvim-treesitter/nvim-treesitter-textobjects" }
  use {
    "nvim-treesitter/nvim-treesitter",
    run = "<cmd>TSUpdate",
    config = function()
      require("config.treesitter").setup()
    end,
  }
  use {
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
    config = function()
      require("config.telescope").setup()
    end,
  }
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
  use { "nvim-telescope/telescope-dap.nvim" }

  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("config.nvim-cmp").setup()
    end,
  }
  use "tpope/vim-commentary"
  use "tpope/vim-rhubarb"
  use {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {
        disable_filetype = { "TelescopePrompt", "vim" },
      }
    end,
  }
  use "tpope/vim-surround"

  -- Vim sugar for unix shell command
  use "tpope/vim-eunuch"

  -- Extra useful shortcuts
  use "tpope/vim-unimpaired"

  -- Ability to apply repeat '.' to some commands
  use "tpope/vim-repeat"

  use "MattesGroeger/vim-bookmarks"

  -- Lua
  use {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  -- extend % to things like 'if' and 'while'
  use { "andymass/vim-matchup", event = "VimEnter" }
  --
  -- Get file symbol outline
  use { "simrat39/symbols-outline.nvim",
    config = function()
      require("symbols-outline").setup()
    end,
  }

  use{
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup {
        -- for example, context is off by default, use this to turn it on
        show_current_context = true,
        show_current_context_start = true,
      }
    end,
  }

  -- Terminals
  use {
    "akinsho/nvim-toggleterm.lua",
    config = function()
      require("config.toggleterm").setup()
    end,
  }

  -- Easy buffer wipe (I think this is the right word for it)
  use {
    "rbgrouleff/bclose.vim",
    config = function()
      vim.api.nvim_set_keymap("n", "ZC", "<cmd>Bclose<CR>", {})
    end,
  }


  -- add extra functionality to the quickfix list
  use "kevinhwang91/nvim-bqf"

  -- Documention generator
  -- use { "kkoomen/vim-doge", run = "<cmd>call doge#install()" }

  -- Think about deleteing this
  use {
    "mhartington/formatter.nvim",
    config = function()
      require("config.formatter").setup()
    end,
  }

  -- prettier asynchrounous notifications
  use {
    'rcarriga/nvim-notify',
    config = function ()
      vim.api.nvim_set_keymap("n", "<backspace>n", "<cmd>lua require('notify').dismiss()<CR>", {})
    end
  }

  -- Pomodorro timer
  use {
      'wthollingsworth/pomodoro.nvim',
      requires = 'MunifTanjim/nui.nvim',
      config = function()
          require('pomodoro').setup({
              time_work = 55,
              time_break_short = 5,
              time_break_long = 20,
              timers_to_long_break = 3
          })
      end
  }

  ---- Project ----
  use {
    "folke/persistence.nvim",
    events = "BufReadPre",
    config = function()
      require('persistence').setup({
        dir = vim.fn.expand(vim.fn.stdpath('config') .. '/session/'),
      })

      -- restore the session for the current directory
      vim.api.nvim_set_keymap("n", "<leader>ss", [[<cmd>lua require("persistence").load()<cr>]], {})
      --
      -- -- restore the last session
      vim.api.nvim_set_keymap("n", "<leader>sl", [[<cmd>lua require("persistence").load({ last = true })<cr>]], {})
      --
      -- -- stop Persistence => session won't be saved on exit
      vim.api.nvim_set_keymap("n", "<leader>sd", [[<cmd>lua require("persistence").stop()<cr>]], {})
    end,
  }

  use {
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function()
        require('config.nvim-tree').setup()
      end,
  }
  use {
    "francoiscabrol/ranger.vim",
    config = function()
      vim.cmd [[
        let g:ranger_map_keys = 0
        let g:no_plugin_maps = 1
        let g:ranger_replace_netrw = 1
      ]]
      vim.api.nvim_set_keymap("n", "-", "<cmd>Ranger<CR>", {})
    end,
    requires = "rbgrouleff/bclose.vim",
  }


  ---- Aesthetics ----
  use {
    'kyazdani42/nvim-web-devicons',
    config = function()
      require('config.nvim-web-devicons').setup()
    end,
  }
  use {
    "hoob3rt/lualine.nvim",
    event = "VimEnter",
    -- config = [[require('config.lualine')]],
    config = function()
      require("lualine").setup {}
      -- require("lualine").setup { options = { theme = "auto" }, }
    end,
    wants = "nvim-web-devicons",
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  use {
     "folke/zen-mode.nvim",
     config = function()
       require("zen-mode").setup {
         -- your configuration comes here
         -- or leave it empty to use the default settings
         -- refer to the configuration section below
       }
       vim.api.nvim_set_keymap("n", "leaderz", "<cmd>ZenMode<CR>", {})
     end,
  }

  use {
    "ellisonleao/gruvbox.nvim",
    requires = { "rktjmp/lush.nvim" },
    config = function()
      require("gruvbox").setup({
        undercurl = true,
        underline = true,
        bold = true,
        italic = true,
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "", -- can be "hard", "soft" or empty string
        overrides = {},
      })
      vim.cmd [[
        hi DiffAdd      gui=none    guifg=NONE          guibg=#bada9f
        hi DiffChange   gui=none    guifg=NONE          guibg=#fae8b9
        hi DiffDelete   gui=bold    guifg=#ff8080       guibg=#ffb0b0
        hi DiffText     gui=none    guifg=NONE          guibg=#fff18c
        hi Visual     gui=none    guifg=NONE          guibg=#FFD580
      ]]
    end,
  }

  -- use {'akinsho/bufferline.nvim',
  --   tag = "v3.*",
  --   requires = 'kyazdani42/nvim-web-devicons',
  --   config=function ()
  --     require("bufferline").setup({
  --       options = {
  --         mode = "tabs"
  --       }
  --     })
  --   end
  -- }

  ---- Lsp ----
  use "ray-x/lsp_signature.nvim" -- check if this still work
  use { "neovim/nvim-lspconfig" }
  use 'mfussenegger/nvim-jdtls'
  use {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require('config.null-ls').setup()
    end
  }
  use { "williamboman/mason.nvim",
      config = function()
        require('mason').setup {}
      end
  }

  ---- Language Specfic ----
  --- Typescript ---
  use "JoosepAlviste/nvim-ts-context-commentstring"
  use { "windwp/nvim-ts-autotag",
    config = function()
      require('nvim-ts-autotag').setup()
    end
  }
  -- typescript server somewhat lacking, so additional functionality availabile in vscode and tsserver
  use { "jose-elias-alvarez/nvim-lsp-ts-utils" }
  use { "jose-elias-alvarez/typescript.nvim" }

  --- Latex Plugins ---
  --use 'lervag/vimtex'
  use "Konfekt/FastFold"
  -- use "matze/vim-tex-fold"

  --- R ---
  use "vim-pandoc/vim-pandoc"
  use "vim-pandoc/vim-rmarkdown"
  use "vim-pandoc/vim-pandoc-syntax"
  use "jalvesaq/Nvim-R"

  --- Python ---
  -- Run code withe jupyter
  use {
    "dccsillag/magma-nvim",
    run = ":UpdateRemotePlugins",
    config = function()
      require('config.magma').setup()
    end,
  }

  ---- Debugger ----
  use {
    "mfussenegger/nvim-dap",
    config = function()
      require("config.dap").setup()
    end,
  }
  --use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

  ---- Movement ----
  use {
    "ggandor/leap.nvim",
    config = function()
      require('leap').set_default_keymaps()
    end
  }


  ---- Snippets ----
  -- use {
  --   "hrsh7th/vim-vsnip-integ",
  --   requires = {
  --     "hrsh7th/vim-vsnip",
  --   },
  -- }
  -- use { "rafamadriz/friendly-snippets" }

  -- use 'honza/vim-snippets'

  -- BEWARE: This may be slowing down my vim
  use{
    'L3MON4D3/LuaSnip',
    config=function ()
      require("config.luasnip").setup()
    end,
    requires = {
      "rafamadriz/friendly-snippets",
    }
  }

  ---- Git integration ----
  use {
    "tpope/vim-fugitive",
    config = function()
      vim.api.nvim_set_keymap("n", "<leader>gs", "<cmd>Git<CR>", {})
      -- Note that the semicolon is mapped to colon
      vim.api.nvim_set_keymap("n", "<leader>g<space>", ";Git ", {})
      vim.api.nvim_set_keymap("n", "<leader>gb", "<cmd>Git blame<CR>", {})
      -- Using diffview plugin to show differences now
      -- vim.api.nvim_set_keymap('n', '<leader>gh', "<cmd>0Gclog<CR>", {})
      -- vim.api.nvim_set_keymap('n', '<leader>gd', "<cmd>Gvdiffsplit<CR>", {})
    end,
  }
  use {
    "pwntester/octo.nvim",
    config = function()
      require("octo").setup()
    end,
    requires = {
      "nvim-telescope/telescope.nvim",
    },
  }
  use {
    "sindrets/diffview.nvim",
    config = function()
      require("config.diffview").setup()
    end,
  }

  use {
    "junegunn/gv.vim",
    config = function() end,
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

  use {
    "github/copilot.vim",
    config = function()
      vim.cmd([[
        imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
        let g:copilot_no_tab_map = v:true
      ]])
    end,
  }

  ---- Note taking ----
  use "vimwiki/vimwiki"
  -- use "mattn/calendar-vim"

  use {
      "nvim-neorg/neorg",
      -- tag = "latest",
      -- ft = "norg",
      -- after = "nvim-treesitter", -- You may want to specify Telescope here as well
      config = function()
        require('config.neorg').setup()
      end,
      requires = { { "nvim-lua/plenary.nvim" }, { "nvim-neorg/neorg-telescope" } },
      run = ":Neorg sync-parsers",
  }

  ---- Calendar ----
  use {
    "itchyny/calendar.vim",
    config = function()
      vim.cmd([[
        source ~/.cache/calendar.vim/credentials.vim
        let g:calendar_google_calendar = 1
      ]])
    end
  }

end)
