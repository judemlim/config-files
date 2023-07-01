local M = {}

function M.setup()
  local status_ok, actions = pcall(require, "telescope")
  if not status_ok then
    -- TODO Better error handling
    print "Error loading telescope"
    return
  end

  require("telescope").setup {
    autotag = {
      enable = true,
    },
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
      prompt_prefix = "> ",
      selection_caret = "> ",
      entry_prefix = "  ",
      initial_mode = "insert",
      selection_strategy = "reset",
      sorting_strategy = "ascending",
      -- layout_strategy = "vertical",
      layout_config = {
        horizontal = {
          mirror = false,
        },
        vertical = {
          mirror = true,
          prompt_position = "top",
        },
      },
      mappings = {
        i = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
          -- Right hand side can also be the name of the action as a string
          --["<c-d>"] = "delete_buffer",
          ["<c-Down>"] = require("telescope.actions").cycle_history_next,
          ["<c-Up>"] = require("telescope.actions").cycle_history_prev,
          -- ["<c-t>"] = require("trouble.providers.telescope").open_with_trouble,
        },
        n = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
          -- ["<c-t>"] = require("trouble.providers.telescope").open_with_trouble,
        },
      },
      file_sorter = require("telescope.sorters").get_fuzzy_file,
      file_ignore_patterns = {},
      generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
      winblend = 0,
      border = {},
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      color_devicons = true,
      use_less = true,
      path_display = { "truncate" },
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = false, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
    },
  }

  require("telescope").load_extension "fzf"
  require("telescope").load_extension "dap"

  vim.api.nvim_set_keymap("n", ",h", "<cmd>Telescope oldfiles<CR>", {})
  vim.api.nvim_set_keymap("n", ",g", "<cmd>Telescope git_files<CR>", {})
  vim.api.nvim_set_keymap("n", ",f", "<cmd>Telescope find_files<CR>", {})
  vim.api.nvim_set_keymap("n", ",F", "<cmd>Telescope file_browser<CR>", {})
  vim.api.nvim_set_keymap("n", ",r", "<cmd>Telescope resume<CR>", {})
  vim.api.nvim_set_keymap("n", ",k", "<cmd>lua require('telescope.builtin').keymaps()<CR>", {})
  vim.api.nvim_set_keymap(
    "n",
    ",lo",
    "<cmd>lua require('telescope.builtin').live_grep({ prompt_title = 'find string in open buffers...', grep_open_files = true })<CR>",
    {}
  )
  vim.api.nvim_set_keymap("n", ",lg", "<cmd>lua require'telescope.builtin'.live_grep()<CR>", {})
  vim.api.nvim_set_keymap("n", ",s", "<cmd>Telescope lsp_document_symbols<CR>", {})
  vim.api.nvim_set_keymap("n", ",S", "<cmd>Telescope lsp_workspace_symbols query=", {})
  --vim.api.nvim_set_keymap('n', ',rS', "<cmd>Telescope lsp_workspace_symbols query=<c-r><c-w><CR>", {})
  vim.api.nvim_set_keymap("n", ",rS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", {})
  vim.api.nvim_set_keymap("n", ",rs", "<cmd>Rg <c-r><c-w><CR>", {})
  vim.api.nvim_set_keymap("n", ",w", "<cmd>lua require('telescope.builtin').grep_string()<CR>", {})
  vim.api.nvim_set_keymap("n", ",d", "<cmd>Telescope lsp_document_diagnostics<CR>", {})
  vim.api.nvim_set_keymap("n", ",D", "<cmd>Telescope lsp_workspace_diagnostics<CR>", {})
  vim.api.nvim_set_keymap("n", ",a", "<cmd>Telescope lsp_code_actions<CR>", {})
  vim.api.nvim_set_keymap("n", ",q", "<cmd>Telescope quickfix<CR>", {})
  -- Using FZf until I can get buffers sorted by last used consistently
  vim.api.nvim_set_keymap("n", ",b", "<cmd>lua require('telescope.builtin').buffers({ sort_mru = true })<CR>", {})
  -- vim.api.nvim_set_keymap('n', ',b', "<cmd>Buffers<CR>", {})

  -- Attching on when lsp is attached to buffer
  --vim.api.nvim_set_keymap('n', 'gd', "<cmd>Telescope lsp_definitions<CR>", {})
  --vim.api.nvim_set_keymap('n', 'gr', "<cmd>Telescope lsp_references<CR>", {})
end

return M
