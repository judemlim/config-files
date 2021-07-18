-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only requirednvim-compe if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]
-- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()

return require('packer').startup(function(use)
  ---- Packer can manage itself
  use 'wbthomason/packer.nvim'

  --use 'puremourning/vimspector'
  use 'mfussenegger/nvim-dap'

  use "ray-x/lsp_signature.nvim"
  use{
    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup{
	auto_save_enabled = true
      }
    end
  }

  -- New neovim 0.5 things
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

  use { "neovim/nvim-lspconfig" }

  --use 'nvim-lua/completion-nvim'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  use 'hrsh7th/nvim-compe'

  -- Improved cursor movement
  use 'ggandor/lightspeed.nvim' -- fix up

  -- Multiline commenter
  use 'preservim/nerdcommenter'

  -- Snippets
  use 'honza/vim-snippets'

  -- Git integration
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  -- Pair up enclosing characters
  use 'jiangmiao/auto-pairs'

  -- Insert/replace/delete typeof brackets
  use 'tpope/vim-surround'

  -- Floating terminal implementation
  --use 'voldikss/vim-floaterm'
  --use {"akinsho/nvim-toggleterm.lua"}

  -- Language server for intellisense code completion
  -- use 'neoclide/coc.nvim', {'branch': 'release'}

  -- Vim sugar for unix shell command
  use 'tpope/vim-eunuch'

  -- Extra useful shortcuts
  use 'tpope/vim-unimpaired'

  -- Ability to apply repeat '.' to some commands
  use 'tpope/vim-repeat'

  --- File navigation ---
  use 'tpope/vim-vinegar'
  -- very useful fuzzy finder
  -- may not work cause I removed something
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'

  -- Ranger
  use 'francoiscabrol/ranger.vim'
  use 'rbgrouleff/bclose.vim'

  -- Bracket colors
  use 'luochen1990/rainbow'

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

  --- All syntax hightlighting ---
  -- use 'sheerun/vim-polyglot'

  --- Note taking ---
  use 'vimwiki/vimwiki'

  --- Intutive book marks ---

  use 'MattesGroeger/vim-bookmarks'
  use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}
  use {'andymass/vim-matchup', event = 'VimEnter'}
  -- Disabling ale for now - currenty using efm for my linting needs
  --use {
    --'w0rp/ale',
    --ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex', 'js', 'ts', 'jsx', 'tsx', 'lua'},
    --cmd = 'ALEEnable',
    --config = 'vim.cmd[[ALEEnable]]'
  --}
  use {'dracula/vim', as = 'dracula'}
  use {'morhetz/gruvbox', as = 'gruvbox'}
  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }

  use {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup {
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
      }
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
  use 'folke/lsp-colors.nvim' -- colour virtual text from diagnostics
  use {
    'mhartington/formatter.nvim',
    config = function()
      require("formatter").setup{}
    end
  }
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
  }


end)

