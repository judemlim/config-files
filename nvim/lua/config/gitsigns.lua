local M = {}

function M.setup()
	local status_ok, _ = pcall(require, "gitsigns")
	if not status_ok then
		print("Error loading gitsigns")
		return
	end
	require("gitsigns").setup({
		on_attach = function(bufnr)
			local function map(mode, lhs, rhs, opts)
				opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
				vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
			end

			map("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
			map("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

			-- Actions
			map("n", "<leader>hs", ":Gitsigns stage_hunk<CR>")
			map("v", "<leader>hs", ":Gitsigns stage_hunk<CR>")
			map("n", "<leader>hr", ":Gitsigns reset_hunk<CR>")
			map("v", "<leader>hr", ":Gitsigns reset_hunk<CR>")
			map("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<CR>")
			map("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>")
			map("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>")
			map("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>")
			map("n", "<leader>hb", '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
			map("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<CR>")
			map("n", "<leader>hd", "<cmd>Gitsigns diffthis<CR>")
			map("n", "<leader>hD", '<cmd>lua require"gitsigns".diffthis("~")<CR>')
			map("n", "<leader>td", "<cmd>Gitsigns toggle_deleted<CR>")

			-- Text object
			map("o", "ih", ":<C-U>Gitsigns select_hunk<CR>")
			map("x", "ih", ":<C-U>Gitsigns select_hunk<CR>")
		end,
		signs = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
		numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
		linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
		word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
		watch_gitdir = {
			follow_files = true,
		},
		auto_attach = true,
		attach_to_untracked = false,
		current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
			delay = 1000,
			ignore_whitespace = false,
			virt_text_priority = 100,
		},
		current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
		current_line_blame_formatter_opts = {
			relative_time = false,
		},
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil, -- Use default
		max_file_length = 40000, -- Disable if file is longer than this (in lines)
		preview_config = {
			-- Options passed to nvim_open_win
			border = "single",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
	})
	-- require('gitsigns').setup {
	--   signs = {
	--     add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
	--     change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
	--     delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
	--     topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
	--     changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
	--   },
	--   numhl = false,
	--   linehl = false,
	--   current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
	--   current_line_blame_opts = {
	--     virt_text = true,
	--     virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
	--     delay = 1000,
	--   },
	--   sign_priority = 6,
	--   update_debounce = 100,
	--   status_formatter = nil, -- Use default
	--   word_diff = false,
	-- }
end

return M
