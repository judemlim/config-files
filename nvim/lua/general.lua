-- Helpers
local cmd = vim.cmd
local opt = vim.opt

-- Vim only commands
-- Enable file specific key bindings and features defined in the ftplugin folder
cmd "filetype plugin indent on"

-- Colorscheme
-- vim.o.termguicolors = true
-- vim.api.nvim_command('colorscheme gruvbox')
-- vim.o.bg = 'light'

-- Settings
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

--opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard -- issues with gitSigns preview hunk
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
cmd "au VimEnter * highlight CursorLine guibg=#fdf8e3"

--#fdf8e3
opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
opt.showtabline = 2 -- always show tabs
opt.expandtab = true -- use space instead of tabs
opt.smarttab = true -- don't know what this does

-- Key bindings --

-- easier to execute commands
vim.api.nvim_set_keymap("n", ";", ":", { silent = true, noremap = true })
vim.api.nvim_set_keymap("v", ";", ":", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", ":", ";", { silent = true, noremap = true })
vim.api.nvim_set_keymap("v", ":", ";", { silent = true, noremap = true })

-- vim.api.nvim_set_keymap("n", "<C-s>", "<cmd>w<CR>", { silent = true }) -- save like everywhere else in the world
vim.api.nvim_set_keymap("n", "<backspace>o", [[<cmd>only<CR>]], { silent = true })
vim.api.nvim_set_keymap("n", "<backspace>t", [[<cmd>tabonly<CR>]], { silent = true })
vim.api.nvim_set_keymap("n", "<backspace>h", "<cmd>noh<CR>", { silent = true })

-- New buffer management
-- vim.api.nvim_set_keymap("n", "<leader>v", "<cmd>vsp<CR>", { silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>s", "<cmd>sp<CR>", { silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>tabnew<CR>", { silent = true })

-- better window movement
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { silent = true })

-- Terminal window navigation
-- Disabled because I like to use <C-l> to clear the terminal
-- vim.api.nvim_set_keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", {silent = true, noremap = true})
-- vim.api.nvim_set_keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", {silent = true, noremap = true})
-- vim.api.nvim_set_keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", {silent = true, noremap = true})
-- vim.api.nvim_set_keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", {silent = true, noremap = true})
-- vim.api.nvim_set_keymap("i", "<C-h>", "<C-\\><C-N><C-w>h", {silent = true, noremap = true})
-- vim.api.nvim_set_keymap("i", "<C-j>", "<C-\\><C-N><C-w>j", {silent = true, noremap = true})
-- vim.api.nvim_set_keymap("i", "<C-k>", "<C-\\><C-N><C-w>k", {silent = true, noremap = true})
-- vim.api.nvim_set_keymap("i", "<C-l>", "<C-\\><C-N><C-w>l", {silent = true, noremap = true})
-- vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", {silent = true, noremap = true})

-- Resize with arrows
vim.api.nvim_set_keymap("n", "<C-Up>", "<cmd>resize -2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-Down>", "<cmd>resize +2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { silent = true })

-- Tab switch buffer
--vim.api.nvim_set_keymap("n", "<TAB>", ":bnext<CR>", { noremap = true, silent = true })
--vim.api.nvim_set_keymap("n", "<S-TAB>", ":bprevious<CR>", { noremap = true, silent = true })

-- Move selected line / block of text in visual mode
vim.api.nvim_set_keymap("x", "K", "<cmd>move '<-2<CR>gv-gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "J", "<cmd>move '>+1<CR>gv-gv", { noremap = true, silent = true })

-- Use ripgrep for grep
vim.cmd('set grepprg=rg\\ --vimgrep\\ --smart-case\\ --follow')


-- Utility functions and commonds,( I don't know if there is syntax for this or not )
vim.cmd([[

command! BufOnly execute '%bdelete|edit #|normal `"'

function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

nmap <silent> <backspace>l <cmd>call ToggleList("Location List", 'l')<CR>
nmap <silent> <backspace>q <cmd>call ToggleList("Quickfix List", 'c')<CR>

function ZoomWindow()
  let cpos = getpos(".")
  tabnew %
  redraw
  call cursor(cpos[1], cpos[2])
  normal! zz
endfunction
nmap gz <cmd>call ZoomWindow()<CR>

function! CloseInactiveBuffers()
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
        call extend(tablist, tabpagebuflist(i + 1))
    endfor

    "Below originally inspired by Hara Krishna Dara and Keith Roberts
    "http://tech.groups.yahoo.com/group/vim/message/56425
    let nWipeouts = 0
    for i in range(1, bufnr('$'))
        if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
        "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
            silent exec 'bwipeout' i
            let nWipeouts = nWipeouts + 1
        endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
endfunction
command! Bdi :call CloseInactiveBuffers()
]])


vim.api.nvim_create_user_command(
  'CloseInactiveBuffers',
  "call CloseInactiveBuffers()",
  {}
)
