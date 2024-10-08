-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only requirednvim-compe if you have packer configured as `opt`
-- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()
vim.cmd([[packadd cfilter]])

require("lazy").setup({
	"adl-lang/adl-vim-highlight",
	"tpope/vim-rhubarb",
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({
				disable_filetype = { "TelescopePrompt", "vim" },
			})
		end,
	},
	"tpope/vim-surround",

	-- Vim sugar for unix shell command
	"tpope/vim-eunuch",

	-- Extra useful shortcuts
	"tpope/vim-unimpaired",

	-- Ability to apply repeat '.' to some commands
	"tpope/vim-repeat",

	"MattesGroeger/vim-bookmarks",

	"kevinhwang91/nvim-bqf",

	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("config.treesitter").setup()
		end,
	},
	{
		"wbthomason/packer.nvim",
		log = { level = "error" },
	},
	{
		"nvim-treesitter/playground",
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = "<cmd>TSUpdate",
		config = function()
			require("config.treesitter").setup()
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			require("config.telescope").setup()
		end,
	},
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	{
		"nvim-telescope/telescope-dap.nvim",
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
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
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		config = function()
			require("noice").setup({
				views = {
					cmdline_popup = {
						position = {
							row = 3,
							col = "50%",
						},
						size = {
							width = 60,
							height = "auto",
						},
					},
					popupmenu = {
						relative = "editor",
						position = {
							row = 8,
							col = "50%",
						},
						size = {
							width = 60,
							height = 10,
						},
						border = {
							style = "single",
							padding = { 0, 1 },
						},
						win_options = {
							winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
						},
					},
				},
			})
		end,
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	{
		"rcarriga/nvim-notify",
		config = function()
			vim.api.nvim_set_keymap("n", "<backspace>n", "<cmd>lua require('notify').dismiss()<CR>", {})
		end,
	},
	-- Formatter --
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					-- Conform will run multiple formatters sequentially
					python = { "isort", "black" },
					-- Use a sub-list to run only the first available formatter
					javascript = { { "prettierd", "prettier" } },
					typescript = { { "prettierd", "prettier" } },
					typescriptreact = { { "prettierd", "prettier" } },
				},
			})
			vim.api.nvim_set_keymap("n", "<space>F", "<cmd>lua require('conform').format()<CR>", {})
		end,
		opts = {},
	},
	---- Lsp ----
	-- {
	--   "ray-x/lsp_signature.nvim"
	-- },
	{
		-- use official lspconfig package (and enable completion):
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lsp_on_attach = function(client, bufnr)
				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				-- following keymap is based on both lspconfig and lsp-zero.nvim:
				-- - https://github.com/neovim/nvim-lspconfig/blob/fd8f18fe819f1049d00de74817523f4823ba259a/README.md?plain=1#L79-L93
				-- - https://github.com/VonHeikemen/lsp-zero.nvim/blob/18a5887631187f3f7c408ce545fd12b8aeceba06/lua/lsp-zero/server.lua#L285-L298
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
				-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
				vim.keymap.set("n", "go", vim.lsp.buf.type_definition, bufopts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
				--m.keymap.set('n', TODO   , vim.lsp.buf.code_action                           , bufopts) -- lspconfig: <space>ca; lsp-zero: <F4>
				--m.keymap.set('n', TODO   , function() vim.lsp.buf.format { async = true } end, bufopts) -- lspconfig: <space>f
				--m.keymap.set('n', TODO   , vim.lsp.buf.rename                                , bufopts) -- lspconfig: <space>rn; lsp-zero: <F2>
				--
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				vim.keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", bufopts)
				-- Use telescope instead
				--buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', bufopts)
				vim.keymap.set("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", bufopts)
				vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", bufopts)
				vim.keymap.set("n", "<C-space>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", bufopts)
				vim.keymap.set("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", bufopts)
				vim.keymap.set("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", bufopts)
				vim.keymap.set(
					"n",
					"<leader>wl",
					"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
					bufopts
				)
				vim.keymap.set("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", bufopts)
				vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", bufopts)
				-- Conflicting with nerd commenter
				vim.keymap.set("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", bufopts)
				-- Use telescope instead once I learn how to add to quickfix list
				vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", bufopts)

				vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", bufopts)
				-- Jump to diagnostic and save into jumplist
				vim.keymap.set("n", "<C-p>", "<cmd>lua vim.diagnostic.goto_prev()<CR><cmd> normal m'<CR>", bufopts)
				vim.keymap.set("n", "<C-n>", "<cmd>lua vim.diagnostic.goto_next()<CR><cmd> normal m'<CR>", bufopts)
				vim.keymap.set("n", "<leader>q", "<cmd>lua vim.diagnostic.set_loclist()<CR>", bufopts)
				vim.keymap.set("n", "<leader>f", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", bufopts)

				vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", {})
				vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", {})
			end
			local lspconfig = require("lspconfig")
			-- enable both language-servers for both eslint and typescript:
			local servers = {
				pyright = {},
				prismals = {},
				-- tsserver = {},
				eslint = {},
				vtsls = {},
				lua_ls = {
					settings = {
						Lua = {
							runtime = {
								-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
								version = "LuaJIT",
							},
							diagnostics = {
								-- Get the language server to recognize the `vim` global
								globals = { "vim" },
							},
							workspace = {
								-- Make the server aware of Neovim runtime files
								library = vim.api.nvim_get_runtime_file("", true),
							},
							-- Do not send telemetry data containing a randomized but unique identifier
							telemetry = {
								enable = false,
							},
						},
					},
				},
			}
			for server, opts in pairs(servers) do
				lspconfig[server].setup({
					capabilities = lsp_capabilities,
					on_attach = lsp_on_attach,
				})
			end
		end,
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "python" },
	},
	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim", -- optional
			"neovim/nvim-lspconfig", -- optional
		},
		opts = {}, -- your configuration
	},
	-- {
	-- 	"mfussenegger/nvim-jdtls",
	-- },
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"pyright",
			},
		},
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
	},
	-- Note Taking --
	{
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true,
	},
	{
		"nvim-neorg/neorg",
		dependencies = { "luarocks.nvim", "nvim-neorg/neorg-telescope", "nvim-lua/plenary.nvim" },
		config = function()
			require("config.neorg").setup()
		end,
	},
	-- {
	-- 	"pmizio/typescript-tools.nvim",
	-- 	config = function()
	-- 		-- Disable built in formatting to use conform.nvim instead
	-- 		require("typescript-tools").setup({
	-- 			on_attach = function(client)
	-- 				client.server_capabilities.documentFormattingProvider = false
	-- 				client.server_capabilities.documentRangeFormattingProvider = false
	-- 				local bufopts = { noremap = true, silent = true, buffer = bufnr }
	-- 				-- following keymap is based on both lspconfig and lsp-zero.nvim:
	-- 				-- - https://github.com/neovim/nvim-lspconfig/blob/fd8f18fe819f1049d00de74817523f4823ba259a/README.md?plain=1#L79-L93
	-- 				-- - https://github.com/VonHeikemen/lsp-zero.nvim/blob/18a5887631187f3f7c408ce545fd12b8aeceba06/lua/lsp-zero/server.lua#L285-L298
	-- 				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	-- 				vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	-- 				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	-- 				-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	-- 				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	-- 				vim.keymap.set("n", "go", vim.lsp.buf.type_definition, bufopts)
	-- 				vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	-- 				--m.keymap.set('n', TODO   , vim.lsp.buf.code_action                           , bufopts) -- lspconfig: <space>ca; lsp-zero: <F4>
	-- 				--m.keymap.set('n', TODO   , function() vim.lsp.buf.format { async = true } end, bufopts) -- lspconfig: <space>f
	-- 				--m.keymap.set('n', TODO   , vim.lsp.buf.rename                                , bufopts) -- lspconfig: <space>rn; lsp-zero: <F2>
	-- 				--
	-- 				-- See `:help vim.lsp.*` for documentation on any of the below functions
	-- 				vim.keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", bufopts)
	-- 				-- Use telescope instead
	-- 				--buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', bufopts)
	-- 				vim.keymap.set("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", bufopts)
	-- 				vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", bufopts)
	-- 				vim.keymap.set("n", "<C-space>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", bufopts)
	-- 				vim.keymap.set("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", bufopts)
	-- 				vim.keymap.set("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", bufopts)
	-- 				vim.keymap.set(
	-- 					"n",
	-- 					"<leader>wl",
	-- 					"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
	-- 					bufopts
	-- 				)
	-- 				vim.keymap.set("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", bufopts)
	-- 				vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", bufopts)
	-- 				-- Conflicting with nerd commenter
	-- 				vim.keymap.set("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", bufopts)
	-- 				-- Use telescope instead once I learn how to add to quickfix list
	-- 				vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", bufopts)
	--
	-- 				vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", bufopts)
	-- 				-- Jump to diagnostic and save into jumplist
	-- 				vim.keymap.set("n", "<C-p>", "<cmd>lua vim.diagnostic.goto_prev()<CR><cmd> normal m'<CR>", bufopts)
	-- 				vim.keymap.set("n", "<C-n>", "<cmd>lua vim.diagnostic.goto_next()<CR><cmd> normal m'<CR>", bufopts)
	-- 				vim.keymap.set("n", "<leader>q", "<cmd>lua vim.diagnostic.set_loclist()<CR>", bufopts)
	-- 				vim.keymap.set("n", "<leader>f", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", bufopts)
	--
	-- 				vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", {})
	-- 				vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", {})
	-- 			end,
	-- 		})
	-- 	end,
	-- 	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	-- 	opts = {},
	-- },
	-- {
	-- 	"nvimtools/none-ls.nvim",
	-- 	dependencies = {
	-- 		"nvimtools/none-ls-extras.nvim",
	-- 	},
	-- 	config = function()
	-- 		local null_ls = require("null-ls")
	-- 		null_ls.setup({
	-- 			sources = {
	-- 				require("none-ls.diagnostics.cpplint"),
	-- 				require("none-ls.formatting.jq"),
	-- 				require("none-ls.code_actions.eslint"),
	-- 			},
	-- 		})
	-- 	end,
	-- },

	---- Git integration ----
	{
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
	},
	{
		"pwntester/octo.nvim",
		config = function()
			require("octo").setup()
		end,
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
	},
	{
		"sindrets/diffview.nvim",
		config = function()
			require("config.diffview").setup()
		end,
	},
	{

		"lewis6991/gitsigns.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("config.gitsigns").setup()
		end,
	},
	---- Debugger ----
	{
		"mfussenegger/nvim-dap",
		config = function()
			require("config.dap").setup()
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap" },
	},

	---- Project ----
	{
		"folke/persistence.nvim",
		events = "BufReadPre",
		config = function()
			require("persistence").setup({
				dir = vim.fn.expand(vim.fn.stdpath("config") .. "/session/"),
			})

			-- restore the session for the current directory
			vim.api.nvim_set_keymap("n", "<leader>ss", [[<cmd>lua require("persistence").load()<cr>]], {})
			--
			-- -- restore the last session
			vim.api.nvim_set_keymap(
				"n",
				"<leader>sl",
				[[<cmd>lua require("persistence").load({ last = true })<cr>]],
				{}
			)
			--
			-- -- stop Persistence => session won't be saved on exit
			vim.api.nvim_set_keymap("n", "<leader>sd", [[<cmd>lua require("persistence").stop()<cr>]], {})
		end,
	},
	{
		"kyazdani42/nvim-tree.lua",
		dependencies = "kyazdani42/nvim-web-devicons",
		-- config = function()
		--   require('config.nvim-tree').setup()
		-- end,
	},
	{
		"francoiscabrol/ranger.vim",
		config = function()
			vim.cmd([[
      let g:ranger_map_keys = 0
      let g:no_plugin_maps = 1
      let g:ranger_replace_netrw = 1
    ]])
			vim.api.nvim_set_keymap("n", "-", "<cmd>Ranger<CR>", {})
		end,
		dependencies = "rbgrouleff/bclose.vim",
	},
	---- Movement ----
	{
		"ggandor/leap.nvim",
		config = function()
			require("leap").set_default_keymaps()
		end,
	},

	---- Aesthetics ----
	{
		"kyazdani42/nvim-web-devicons",
		config = function()
			require("config.nvim-web-devicons").setup()
		end,
	},
	{
		"hoob3rt/lualine.nvim",
		event = "VimEnter",
		-- config = [[require('config.lualine')]],
		config = function()
			require("lualine").setup({
				sections = {
					lualine_x = {
						{
							require("noice").api.status.message.get_hl,
							cond = require("noice").api.status.message.has,
						},
						{
							require("noice").api.status.command.get,
							cond = require("noice").api.status.command.has,
							color = { fg = "#ff9e64" },
						},
						{
							require("noice").api.status.mode.get,
							cond = require("noice").api.status.mode.has,
							color = { fg = "#ff9e64" },
						},
						{
							require("noice").api.status.search.get,
							cond = require("noice").api.status.search.has,
							color = { fg = "#ff9e64" },
						},
					},
				},
			})
		end,
		-- wants = "nvim-web-devicons",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- Terminals
	{
		"akinsho/nvim-toggleterm.lua",
		config = function()
			require("config.toggleterm").setup()
			local Terminal = require("toggleterm.terminal").Terminal
			local lazygit = Terminal:new({
				cmd = "lazygit",
				hidden = true,
				direction = "float",
				silent = true,

				-- function to run on opening the terminal
				on_open = function(term)
					vim.cmd("startinsert!")
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"n",
						"q",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
				end,
				-- function to run on closing the terminal
				on_close = function(term)
					vim.cmd("startinsert!")
				end,
			})

			function _lazygit_toggle()
				lazygit:toggle()
			end

			vim.api.nvim_set_keymap(
				"n",
				"<leader>lg",
				"<cmd>lua _lazygit_toggle()<CR>",
				{ noremap = true, silent = true }
			)
		end,
	},

	-- Easy buffer wipe (I think this is the right word for it)
	{
		"rbgrouleff/bclose.vim",
		config = function()
			vim.api.nvim_set_keymap("n", "ZC", "<cmd>Bclose<CR>", {})
		end,
	},
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false,
	--                config = function()
	--                    vim.cmd [[
	--                        colorscheme tokyonight
	--                    ]]
	--                end,
	-- 	priority = 1000,
	-- 	opts = {},
	-- },
	{
		"ellisonleao/gruvbox.nvim",
		dependencies = { "rktjmp/lush.nvim" },
		lazy = false,
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				undercurl = true,
				underline = true,
				bold = true,
				italic = {
					strings = true,
					operators = true,
					comments = true,
				},
				strikethrough = true,
				invert_selection = false,
				invert_signs = false,
				invert_tabline = false,
				invert_intend_guides = false,
				inverse = true, -- invert background for search, diffs, statuslines and errors
				contrast = "", -- can be "hard", "soft" or empty string
				overrides = {},
			})
			vim.cmd([[
	                        hi DiffAdd      gui=none    guifg=NONE          guibg=#bada9f
	                        hi DiffChange   gui=none    guifg=NONE          guibg=#fae8b9
	                        hi DiffDelete   gui=bold    guifg=#ff8080       guibg=#ffb0b0
	                        hi DiffText     gui=none    guifg=NONE          guibg=#fff18c
	                        hi Visual     gui=none    guifg=NONE          guibg=#FFD580
	                      ]])
			vim.o.termguicolors = true
			vim.cmd([[
	                       colorscheme gruvbox
	                   ]])
			vim.o.bg = "light"
		end,
	},
	-- AI
	-- {
	-- 	"CopilotC-Nvim/CopilotChat.nvim",
	-- 	-- branch = "canary",
	-- 	dependencies = {
	-- 		{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
	-- 		{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
	-- 	},
	-- 	-- opts = {
	-- 	-- 	debug = true, -- Enable debugging
	-- 	-- 	-- See Configuration section for rest
	-- 	-- },
	-- 	config = function()
	-- 		require("CopilotChat").setup({
	-- 			debug = true, -- Enable debugging
	-- 			-- See Configuration section for rest
	-- 		})
	-- 	end,
	-- 	-- See Commands section for default commands if you want to lazy load on them
	-- },
	{
		"jpmcb/nvim-llama",
		config = function()
			require("nvim-llama").setup({
				{
					-- See plugin debugging logs
					debug = false,

					-- The model for ollama to use. This model will be automatically downloaded.
					model = "codellama",
				},
			})
		end,
	},
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	-- {
	-- 	"jackMort/ChatGPT.nvim",
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		require("chatgpt").setup()
	-- 	end,
	-- 	dependencies = {
	-- 		"MunifTanjim/nui.nvim",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"folke/trouble.nvim",
	-- 		"nvim-telescope/telescope.nvim",
	-- 	},
	-- },
}, {})

--return require("packer").startup(function(use)
--  ---- General ----
--  use "tpope/vim-rhubarb"
--  use {
--    "windwp/nvim-autopairs",
--    config = function()
--      require("nvim-autopairs").setup {
--        disable_filetype = { "TelescopePrompt", "vim" },
--      }
--    end,
--  }
--  use "tpope/vim-surround"

--  -- Vim sugar for unix shell command
--  use "tpope/vim-eunuch"

--  -- Extra useful shortcuts
--  use "tpope/vim-unimpaired"

--  -- Ability to apply repeat '.' to some commands
--  use "tpope/vim-repeat"

--  use "MattesGroeger/vim-bookmarks"

--  -- Lua
--  use {
--    "folke/which-key.nvim",
--    config = function()
--      vim.o.timeout = true
--      vim.o.timeoutlen = 300
--      require("which-key").setup {
--        -- your configuration comes here
--        -- or leave it empty to use the default settings
--        -- refer to the configuration section below
--      }
--    end
--  }

--  -- extend % to things like 'if' and 'while'
--  use { "andymass/vim-matchup", event = "VimEnter" }
--  --
--  -- Get file symbol outline
--  use { "simrat39/symbols-outline.nvim",
--    config = function()
--      require("symbols-outline").setup()
--    end,
--  }

--  use{
--    "lukas-reineke/indent-blankline.nvim",
--    config = function()
--      require("indent_blankline").setup {
--        -- for example, context is off by default, use this to turn it on
--        show_current_context = true,
--        show_current_context_start = true,
--      }
--    end,
--  }

--  -- add extra functionality to the quickfix list
--  use "kevinhwang91/nvim-bqf"

--  -- Documention generator
--  -- use { "kkoomen/vim-doge", run = "<cmd>call doge#install()" }

--  -- Think about deleteing this
--  use {
--    "mhartington/formatter.nvim",
--    config = function()
--      require("config.formatter").setup()
--    end,
--  }

--  -- prettier asynchrounous notifications
--  use {
--    'rcarriga/nvim-notify',
--    config = function ()
--      vim.api.nvim_set_keymap("n", "<backspace>n", "<cmd>lua require('notify').dismiss()<CR>", {})
--    end
--  }

--  -- Pomodorro timer
--  use {
--      'wthollingsworth/pomodoro.nvim',
--      requires = 'MunifTanjim/nui.nvim',
--      config = function()
--          require('pomodoro').setup({
--              time_work = 55,
--              time_break_short = 5,
--              time_break_long = 20,
--              timers_to_long_break = 3
--          })
--      end
--  }

--  use {
--     "folke/zen-mode.nvim",
--     config = function()
--       require("zen-mode").setup {
--         -- your configuration comes here
--         -- or leave it empty to use the default settings
--         -- refer to the configuration section below
--       }
--       vim.api.nvim_set_keymap("n", "<leader>z", "<cmd>ZenMode<CR>", {})
--     end,
--  }

--  use {
--    "ellisonleao/gruvbox.nvim",
--    requires = { "rktjmp/lush.nvim" },
--    config = function()
--      require("gruvbox").setup({
--        undercurl = true,
--        underline = true,
--        bold = true,
--        italic = {
--          strings = true,
--          operators = true,
--          comments = true,
--        },
--        strikethrough = true,
--        invert_selection = false,
--        invert_signs = false,
--        invert_tabline = false,
--        invert_intend_guides = false,
--        inverse = true, -- invert background for search, diffs, statuslines and errors
--        contrast = "", -- can be "hard", "soft" or empty string
--        overrides = {},
--      })
--      vim.cmd [[
--        hi DiffAdd      gui=none    guifg=NONE          guibg=#bada9f
--        hi DiffChange   gui=none    guifg=NONE          guibg=#fae8b9
--        hi DiffDelete   gui=bold    guifg=#ff8080       guibg=#ffb0b0
--        hi DiffText     gui=none    guifg=NONE          guibg=#fff18c
--        hi Visual     gui=none    guifg=NONE          guibg=#FFD580
--      ]]
--    end,
--  }

--  -- use {'akinsho/bufferline.nvim',
--  --   tag = "v3.*",
--  --   requires = 'kyazdani42/nvim-web-devicons',
--  --   config=function ()
--  --     require("bufferline").setup({
--  --       options = {
--  --         mode = "tabs"
--  --       }
--  --     })
--  --   end
--  -- }

--  ---- Language Specfic ----
--  --- Typescript ---
--  use "JoosepAlviste/nvim-ts-context-commentstring"
--  use { "windwp/nvim-ts-autotag",
--    config = function()
--      require('nvim-ts-autotag').setup()
--    end
--  }
--  -- typescript server somewhat lacking, so additional functionality availabile in vscode and tsserver
--  use { "jose-elias-alvarez/nvim-lsp-ts-utils" }
--  use { "jose-elias-alvarez/typescript.nvim" }

--  --- Latex Plugins ---
--  --use 'lervag/vimtex'
--  use "Konfekt/FastFold"
--  -- use "matze/vim-tex-fold"

--  --- R ---
--  use "vim-pandoc/vim-pandoc"
--  use "vim-pandoc/vim-rmarkdown"
--  use "vim-pandoc/vim-pandoc-syntax"
--  use "jalvesaq/Nvim-R"

--  --- Python ---
--  -- Run code withe jupyter
--  use {
--    "dccsillag/magma-nvim",
--    run = ":UpdateRemotePlugins",
--    config = function()
--      require('config.magma').setup()
--    end,
--  }

--  ---- Snippets ----
--  -- use {
--  --   "hrsh7th/vim-vsnip-integ",
--  --   requires = {
--  --     "hrsh7th/vim-vsnip",
--  --   },
--  -- }
--  -- use { "rafamadriz/friendly-snippets" }

--  -- use 'honza/vim-snippets'

--  -- BEWARE: This may be slowing down my vim
--  use{
--    'L3MON4D3/LuaSnip',
--    config=function ()
--      require("config.luasnip").setup()
--    end,
--    requires = {
--      "rafamadriz/friendly-snippets",
--    }
--  }

--  ---- Note taking ----
--  use "vimwiki/vimwiki"
--  -- use "mattn/calendar-vim"

--  use

--  ---- Calendar ----
--  -- use {
--  --   "itchyny/calendar.vim",
--  --   config = function()
--  --     vim.cmd([[
--  --       source ~/.cache/calendar.vim/credentials.vim
--  --       let g:calendar_google_calendar = 1
--  --     ]])
--  --   end
--  -- }

--end)
