-- Helpers
local cmd = vim.cmd
local opt = vim.opt

-- Vim only commands
-- Enable file specific key bindings and features defined in the ftplugin folder
cmd "filetype plugin indent on"

-- Colorscheme
vim.o.termguicolors = true
-- vim.api.nvim_command('colorscheme gruvbox')
vim.o.bg = 'light'

-- Settings
vim.g.mapleader = ' '
opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
opt.cmdheight = 2 -- more space in the neovim command line for displaying messages
opt.title = true
opt.titlestring = "%<%F%=%l/%L - nvim" -- what the title of the window will be set to
opt.number = true
opt.hlsearch = true
-- keeps undo history when changing buffers I think
opt.hidden = true
opt.splitbelow = true -- force all horizontal splits to go below current window
opt.splitright = true -- force all vertical splits to go to the right of current window
opt.ignorecase = true -- ignore case in search patterns
opt.smartcase = true -- case considered if it is in search
opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
opt.cursorline = true -- highlight the current line
opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
opt.showtabline = 2 -- always show tabs

-- Key bindings --

vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", { silent = true }) -- save like everywhere else in the world
vim.api.nvim_set_keymap("n", "<backspace-o>", ":only<CR>", { silent = true }) -- save like everywhere else in the world

-- New buffer management
vim.api.nvim_set_keymap("n", "<leader>n", ":noh<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>v", ":vsp<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>s", ":sp<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>t", ":tabnew<CR>", { silent = true })

-- better window movement
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { silent = true })

-- Terminal window navigation
vim.api.nvim_set_keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", {silent = true, noremap = true})
vim.api.nvim_set_keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", {silent = true, noremap = true})
vim.api.nvim_set_keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", {silent = true, noremap = true})
vim.api.nvim_set_keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", {silent = true, noremap = true})
vim.api.nvim_set_keymap("i", "<C-h>", "<C-\\><C-N><C-w>h", {silent = true, noremap = true})
vim.api.nvim_set_keymap("i", "<C-j>", "<C-\\><C-N><C-w>j", {silent = true, noremap = true})
vim.api.nvim_set_keymap("i", "<C-k>", "<C-\\><C-N><C-w>k", {silent = true, noremap = true})
vim.api.nvim_set_keymap("i", "<C-l>", "<C-\\><C-N><C-w>l", {silent = true, noremap = true})
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", {silent = true, noremap = true})

-- Resize with arrows
vim.api.nvim_set_keymap("n", "<C-Up>", ":resize -2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-Down>", ":resize +2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-Left>", ":vertical resize -2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true })

-- Tab switch buffer
--vim.api.nvim_set_keymap("n", "<TAB>", ":bnext<CR>", { noremap = true, silent = true })
--vim.api.nvim_set_keymap("n", "<S-TAB>", ":bprevious<CR>", { noremap = true, silent = true })

-- Move selected line / block of text in visual mode
vim.api.nvim_set_keymap("x", "K", ":move '<-2<CR>gv-gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "J", ":move '>+1<CR>gv-gv", { noremap = true, silent = true })

-- Should probably get rid of
--vim.g.diagnostics_active = true
--function _G.toggle_diagnostics()
  --if vim.g.diagnostics_active then
    --vim.g.diagnostics_active = false
    --vim.lsp.diagnostic.clear(0)
    --vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
  --else
    --vim.g.diagnostics_active = true
    --vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      --vim.lsp.diagnostic.on_publish_diagnostics, {
        --virtual_text = true,
        --signs = true,
        --underline = true,
        --update_in_insert = false,
      --}
    --)
  --end
--end

--vim.api.nvim_set_keymap('n', '<leader>tt', ':call v:lua.toggle_diagnostics()<CR>', {noremap = true, silent = true})
