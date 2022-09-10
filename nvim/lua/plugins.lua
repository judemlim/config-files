-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only requirednvim-compe if you have packer configured as `opt`
-- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()
vim.cmd [[packadd cfilter]]

return require("packer").startup(function(use)
  ---- Packer can manage itself
  use {
    "wbthomason/packer.nvim",
    log = { level = "error" },
  }

  -- Close jsx tags // check if this still works
  use { "windwp/nvim-ts-autotag" }

  -- Debugger
  use {
    "mfussenegger/nvim-dap",
    config = function()
      require("config.dap").setup()
    end,
  }

  --use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
  use "ray-x/lsp_signature.nvim" -- check if this still work

  -- Save session on close
  use {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup {
        auto_save_enabled = true,
      }
    end,
  }

  use {
    'kyazdani42/nvim-web-devicons',
    config = function()
      require'nvim-web-devicons'.setup {
       -- your personnal icons can go here (to override)
       -- you can specify color or cterm_color instead of specifying both of them
       -- DevIcon will be appended to `name`
       override = {
        zsh = {
          icon = "",
          color = "#428850",
          cterm_color = "65",
          name = "Zsh"
        }
       };
       -- globally enable default icons (default to false)
       -- will get overriden by `get_icons` option
       default = true;
      }
    end,
  }

  -- tree viewer (This disables Netrw!!) -- there's an option to prevent it from hijacking netrw
  use {
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function()
        require("nvim-tree").setup({
          sort_by = "case_sensitive",
          view = {
            adaptive_size = true,
            mappings = {
              list = {
                { key = "u", action = "dir_up" },
              },
            },
          },
          renderer = {
            group_empty = true,
          },
          filters = {
            dotfiles = true,
          },
        })
      end,
  }
  --use 'brooth/far.vim'
  --

  use { "nvim-treesitter/playground" }
  use { "nvim-treesitter/nvim-treesitter-textobjects" }
  use {
    "nvim-treesitter/nvim-treesitter",
    run = "<cmd>TSUpdate",
    config = function()
      require("config.treesitter").setup()
    end,
  }

  use { "neovim/nvim-lspconfig" }

  -- typescript server somewhat lacking, so additional functionality availabile in vscode and tsserver
  use { "jose-elias-alvarez/nvim-lsp-ts-utils" }

  -- Default tree sitter parser for graphql doesn't seem to be working
  use "jparise/vim-graphql"

  -- Configurable fuzzy finder
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
    },
    config = function()
      local cmp = require "cmp"
      vim.o.completeopt = "menuone,noselect"
      cmp.setup {
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
          -- expand = function(args)
          --   require('luasnip').lsp_expand(args.body)
          -- end,
        },
        mapping = {
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "buffer" },
          { name = "path" },
          { name = "vsnip" },
          -- { name = 'luasnip' },
        },
      }
      vim.cmd [[
        " NOTE: You can use other key to expand snippet.

        " Expand
        imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
        smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

        " Expand or jump
        imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
        smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

        " Jump forward or backward
        imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
        smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
        imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
        smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

        " Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
        " See https://github.com/hrsh7th/vim-vsnip/pull/50
        " nmap        s   <Plug>(vsnip-select-text)
        " xmap        s   <Plug>(vsnip-select-text)
        " nmap        S   <Plug>(vsnip-cut-text)
        " xmap        S   <Plug>(vsnip-cut-text)
      ]]

    end,
  }

  -- Improved cursor movement
  use "ggandor/lightspeed.nvim" -- fix up

  use "tpope/vim-commentary"

  -- Snippets
  use {
    "hrsh7th/vim-vsnip-integ",
    requires = {
      "hrsh7th/vim-vsnip",
    },
  }
  use { "rafamadriz/friendly-snippets" }

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
  use "tpope/vim-rhubarb"

  use {
    "junegunn/gv.vim",
    config = function() end,
  }

  -- Pair up enclosing characters
  -- use 'jiangmiao/auto-pairs'
  use {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {
        disable_filetype = { "TelescopePrompt", "vim" },
      }
    end,
  }

  -- Insert/replace/delete typeof brackets
  use "tpope/vim-surround"

  use {
    "akinsho/nvim-toggleterm.lua",
    config = function()
      require("config.toggleterm").setup()
    end,
  }

  -- Vim sugar for unix shell command
  use "tpope/vim-eunuch"

  -- Extra useful shortcuts
  use "tpope/vim-unimpaired"

  -- Ability to apply repeat '.' to some commands
  use "tpope/vim-repeat"

  -- very useful fuzzy finder
  -- may not work cause I removed something
  use "junegunn/fzf"
  use "junegunn/fzf.vim"

  -- Ranger
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

  use {
    "rbgrouleff/bclose.vim",
    config = function()
      vim.api.nvim_set_keymap("n", "ZC", "<cmd>Bclose<CR>", {})
    end,
  }

  -- Bracket colors
  -- use "p00f/nvim-ts-rainbow"

  --- Latex Plugins ---
  --use 'lervag/vimtex'
  use "Konfekt/FastFold"
  use "matze/vim-tex-fold"

  --- R ---
  use "vim-pandoc/vim-pandoc"
  use "vim-pandoc/vim-rmarkdown"
  use "vim-pandoc/vim-pandoc-syntax"

  -- R markdown
  use "jalvesaq/Nvim-R"

  --- CMake ---
  -- Not sure if I need this anymore
  use "pboettch/vim-cmake-syntax"

  --- Note taking and work planning ---
  use "vimwiki/vimwiki"
  -- use "mattn/calendar-vim"

  use "itchyny/calendar.vim"

  --- Intutive book marks ---
  -- Should maybe try going back to normal bookmarks or making this more synergistic with it
  use "MattesGroeger/vim-bookmarks"

  use { "tpope/vim-dispatch", opt = true, cmd = { "Dispatch", "Make", "Focus", "Start" } }

  use { "andymass/vim-matchup", event = "VimEnter" }

  use { "dracula/vim", as = "dracula" }

  use {
    "ellisonleao/gruvbox.nvim",
    requires = { "rktjmp/lush.nvim" },
    config = function()
      vim.api.nvim_command "colorscheme gruvbox"
      vim.cmd [[
        hi DiffAdd      gui=none    guifg=NONE          guibg=#bada9f
        hi DiffChange   gui=none    guifg=NONE          guibg=#fae8b9
        hi DiffDelete   gui=bold    guifg=#ff8080       guibg=#ffb0b0
        hi DiffText     gui=none    guifg=NONE          guibg=#fff18c
        hi Visual     gui=none    guifg=NONE          guibg=#FFD580
      ]]
    end,
  }

  use { "jez/vim-colors-solarized" }

  use {
    "hoob3rt/lualine.nvim",
    event = "VimEnter",
    -- config = [[require('config.lualine')]],
    config = function()
      require("lualine").setup {
        options = { theme = "gruvbox_light" },
      }
    end,
    wants = "nvim-web-devicons",
  }

  use {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
      vim.api.nvim_set_keymap("n", "<leader>z", "<cmd>ZenMode<CR>", {})
    end,
  }
  -- Lua
  -- use {
  --   "folke/trouble.nvim",
  --   requires = "kyazdani42/nvim-web-devicons",
  --   config = function()
  --     require("trouble").setup {
  --       -- your configuration comes here
  --       -- or leave it empty to use the default settings
  --       -- refer to the configuration section below
  --     }
  --     vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>", { silent = true, noremap = true })
  --     vim.api.nvim_set_keymap(
  --       "n",
  --       "<leader>xw",
  --       "<cmd>Trouble lsp_workspace_diagnostics<cr>",
  --       { silent = true, noremap = true }
  --     )
  --     vim.api.nvim_set_keymap(
  --       "n",
  --       "<leader>xd",
  --       "<cmd>Trouble lsp_document_diagnostics<cr>",
  --       { silent = true, noremap = true }
  --     )
  --     vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>", { silent = true, noremap = true })
  --     vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", { silent = true, noremap = true })
  --     vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>", { silent = true, noremap = true })
  --   end,
  -- }

  -- colour virtual text from diagnostics
  -- use 'folke/lsp-colors.nvim'

  use {
    "mhartington/formatter.nvim",
    config = function()
      require("config.formatter").setup()
    end,
  }

  -- use {
  --   'lewis6991/gitsigns.nvim',
  --   requires = {
  --     'nvim-lua/plenary.nvim'
  --   },
  --   config = function ()
  --     require("config.gitsigns").setup()
  --   end
  -- }

  use {
    "airblade/vim-gitgutter",
    config = "vim.cmd[[set updatetime=1000]]",
  }

  use {
    "vim-test/vim-test",
    config = function()
      vim.cmd [[
      let g:test#javascript#runner = "mocha"
      let g:test#javascript#mocha#options = '--colors --recursive --timeout 0 --check-leaks --require source-map-support/register --globals database,models --require dist/common/test/init '
      let g:test#javascript#mocha#executable = 'make compile && npx mocha'
      let g:test#javascript#mocha#file_pattern = '.*'
      let test#project_root = "~/awayco-monorepo/backend"
      let test#strategy = "neovim"
      let g:test#runner_commands = ['Mocha']
      let g:test#preserve_screen = 1
      ]]
    end,
  }

  -- Trying to get testing working for mocha
  -- let g:test#javascript#mocha#executable = 'npx mocha --colors --recursive --timeout 0 --check-leaks --require source-map-support/register --globals database,models --require dist/common/test/init --exit ./dist/common/test'
  -- use { "rcarriga/vim-ultest", requires = {"vim-test/vim-test"}, run = ":UpdateRemotePlugins" }

  -- Documention generator
  use { "kkoomen/vim-doge", run = "<cmd>call doge#install()" }

  -- Github cli wrapper
  use {
    "pwntester/octo.nvim",
    config = function()
      require("octo").setup()
    end,
    requires = {
      "nvim-telescope/telescope.nvim",
    },
  }

  -- Nice diff view for file history and git staging
  use {
    "sindrets/diffview.nvim",
    config = function()
      require("config.diffview").setup()
    end,
  }

  -- add extra functionality to the quickfix list
  use { "kevinhwang91/nvim-bqf" }

  -- Uses tree sitter to identify different languages in the same file.
  -- Useful for jsx files.
  use "JoosepAlviste/nvim-ts-context-commentstring"

  -- Get file symbol outline
  use { "simrat39/symbols-outline.nvim", config = function() end }

  -- Run code withe jupyter
  use {
    "dccsillag/magma-nvim",
    run = ":UpdateRemotePlugins",
    config = function()
      vim.cmd [[
        nnoremap <silent><expr> <Leader>r  :MagmaEvaluateOperator<CR>
        nnoremap <silent>       <Leader>rr :MagmaEvaluateLine<CR>
        xnoremap <silent>       <Leader>r  :<C-u>MagmaEvaluateVisual<CR>
        nnoremap <silent>       <Leader>rc :MagmaReevaluateCell<CR>
        nnoremap <silent>       <Leader>rd :MagmaDelete<CR>
        nnoremap <silent>       <Leader>ro :MagmaShowOutput<CR>
        let g:magma_automatically_open_output = v:true
      ]]
    end,
  }

  -- Java lsp
  use 'mfussenegger/nvim-jdtls'

  -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.

  use {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("null-ls").setup({
        sources = {
            require("null-ls").builtins.formatting.stylua,
            require("null-ls").builtins.formatting.eslint,
            require("null-ls").builtins.diagnostics.eslint,
            -- require("null-ls").builtins.completion.spell,
            require("null-ls").builtins.code_actions.eslint, -- Why not working?
        },
      })
    end,
  }

  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup {
          -- for example, context is off by default, use this to turn it on
          show_current_context = true,
          show_current_context_start = true,
      }
    end,
  })

  use {
      "nvim-neorg/neorg",
      -- tag = "latest",
      -- ft = "norg",
      -- after = "nvim-treesitter", -- You may want to specify Telescope here as well
      config = function()
        require('neorg').setup {
            load = {
                ["core.defaults"] = {}
            }
        }
      end
  }

  use { "williamboman/mason.nvim",
      config = function()
        require('mason').setup {}
      end
  }


end)
