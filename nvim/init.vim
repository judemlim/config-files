""""""""""""""""""""""""""""""""""""""
" ----- Plugins {{{1
""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.local/share/nvim/plugged')

""" --- General --- 
" Improved cursor movement
Plug 'easymotion/vim-easymotion'

" Snippets
Plug 'honza/vim-snippets'

" Git integration
Plug 'tpope/vim-fugitive'

"Pair up enclosing characters
Plug 'jiangmiao/auto-pairs'

" Insert/replace/delete typeof brackets
Plug 'tpope/vim-surround'

" Multi line commentor
Plug 'scrooloose/nerdcommenter'

" Debugger - python, c/c++
Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }

" Floating terminal implementation
Plug 'voldikss/vim-floaterm'

" Language server for intellisense code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Linter
Plug 'dense-analysis/ale'

" Vim sugar for unix shell command
Plug 'tpope/vim-eunuch'

""" --- File navigation ---
"Plug 'scrooloose/nerdTree'
Plug 'tpope/vim-vinegar'
" very useful fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

""" --- Aesthetics --- 
" Aesthetic bar for mode tracking
Plug 'vim-airline/vim-airline'

" devicons
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'

"" Color schemes
Plug 'morhetz/gruvbox'

" Bracket colors
Plug 'luochen1990/rainbow'

""" --- Latex Plugins ---
Plug 'lervag/vimtex'
Plug 'Konfekt/FastFold'
Plug 'matze/vim-tex-fold'

""" --- C Plugins --- 
"  semi-colon insertion
Plug 'lfilho/cosco.vim'
" additional syntax highlighting for cpp
Plug 'octol/vim-cpp-enhanced-highlight'

""" --- React/webdev plugins ---  
" Typescript highlighting
Plug 'HerringtonDarkholme/yats.vim'
" React Syntax Highlighting
Plug 'maxmellon/vim-jsx-pretty'
" Javascript syntax highlighting
Plug 'yuezk/vim-js'
" Emmet
"Plug 'mattn/emmet-vim'
" post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

""" --- R ---  
" R markdown
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-rmarkdown'
Plug 'vim-pandoc/vim-pandoc-syntax'

" R markdown
Plug 'jalvesaq/Nvim-R'

""" --- CMake ---
Plug 'pboettch/vim-cmake-syntax'

call plug#end()


""""""""""""""""""""""""""""""""""""""
" ----- General{{{1
""""""""""""""""""""""""""""""""""""""
"Set title for compositor transparency exclusions
set title
set titlestring=Neovim
syntax on
set number
set hlsearch

" Map leader '\' to space
nmap <Space> <Leader>
vmap <Space> <Leader>

" Turn of highlighting
nnoremap  <C-N> :noh<CR>

" Map Ctrl-Backspace to delete the previous word in insert mode.
inoremap <C-BS> <C-W>

" open new terminal window in directory
command T silent execute '!urxvt &'
command R silent execute '!urxvt -e ranger&'

" Fast saving
nmap <leader>w :w!<cr>

"" Speed up scrolling in Vim
set ttyfast

"Insert linebreaks
nnoremap <silent> <leader>o :<C-u>call append(line("."),   repeat([""], v:count1))<CR>
nnoremap <silent> <leader>O :<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>

" Easier split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Quick reformat of entire document TODO - check which plugin this is!
nnoremap <leader>F :Format<CR>

" More natural split opening
set splitbelow
set splitright

" Enable file specific key bindings and features defined in the ftplugin folder
filetype plugin indent on

" when the pop up appears it allows <C-j> to move selection cursor
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

" More natural terminal escape
tnoremap <silent> <Esc> <C-\><C-n><CR>

" No numbers in terminal
autocmd Termopen * setlocal nonumber

" Open a buffer in a new tab (zoom in effect)
function ZoomWindow()
  let cpos = getpos(".")
  tabnew %
  redraw
  call cursor(cpos[1], cpos[2])
  normal! zz
endfunction
nmap gz :call ZoomWindow()<CR>

" Delete all buffers except the one I'm currently in
command! BufOnly execute '%bdelete|edit #|normal `"'

"Set python3 location
let g:python3_host_prog = "/bin/python"

" make zsh invocation in vim interactive
set shell=zsh\ -i

" auto resize windows
"autocmd VimResized * wincmd =
nmap <Leader>= <C-W>= 

"""""""""""""""""""""""""""""""""""""""
" ----- FZF configs {{{1
""""""""""""""""""""""""""""""""""""""
nnoremap ,f :Files<CR>
nnoremap ,b :Buffers<CR>
nnoremap ,C :Commands<CR>
nnoremap ,m :Maps<CR>
nnoremap ,w :Windows<CR>
" Ripgrep
nnoremap ,r :Rg<CR>
" Buffer history
nnoremap ,h :History<CR>
" Command history
nnoremap ,Hc :History:<CR>
" Search History
nnoremap ,Hs :History/<CR>

"let g:fzf_layout= {'down': '80%'}
"let g:fzf_preview_window = 'up:60%'

"""""""""""""""""""""""""""""""""""""
" ----- Theme/Color settings {{{1
""""""""""""""""""""""""""""""""""""""
" Color Scheme
colorscheme gruvbox

" vim-color brackets on globally
let g:rainbow_active = 1
let g:rainbow_conf = {
\	'separately': {
\		'nerdtree': 0,
\   'cmake':0,
\	}
\}

" Allow powerline font
let g:airline_powerline_fonts = 1 
let g:airline#extensions#coc#enabled = 0
""""""""""""""""""""""""""""""""""""""
" ----- Vim easymotion config{{{1
""""""""""""""""""""""""""""""""""""""
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_keys='idasonetuh'

nmap s <Plug>(easymotion-overwin-f)
nmap t <Plug>(easymotion-t2)
nmap T <Plug>(easymotion-T2)
nmap <leader>m <Plug>(easymotion-repeat)

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
"nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, bu on average, it may be more comfortable.
"nmap s <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" Different colours for if 1 or 2 keys are needed to be pressed
hi EasyMotionTarget ctermbg=none ctermfg=red 
hi EasyMotionTarget2 ctermbg=none ctermfg=yellow

"hi EasyMotionTarget2First ctermbg=none ctermfg=red
"hi EasyMotionTarget2Second ctermbg=none ctermfg=yellow

" Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
"map <Leader>w <Plug>(easymotion-w)
"map <Leader>e <Plug>(easymotion-e)
"map <Leader>b <Plug>(easymotion-b)
""""""""""""""""""""""""""""""""""""""
" ----- Text, tab, folds, and index related {{{1
""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=2
set tabstop=2

" Linebreak on 500 characters
set lbr
set tw=500

set foldmethod=indent
set nofoldenable
set ai "Auto indent
set wrap "Wrap lines

" smart indent, but still allowing indent of #
set cindent
set cinkeys-=0#
set indentkeys-=0#


""""""""""""""""""""""""""""""""""""""
" ----- Netrw configs {{{1
""""""""""""""""""""""""""""""""""""""
" Trying out netrw
map <leader>n :Exp<CR>
map <leader>v :Vex<CR>
map <leader>s :Sex<CR>
map <leader>l :Lex 15<CR>
let g:netrw_liststyle=3
autocmd FileType netrw setl bufhidden=wipe

"let g:NERDTreeFileExtensionHighlightFullName = 1
"let g:NERDTreeExactMatchHighlightFullName = 1
"let g:NERDTreePatternMatchHighlightFullName = 1
"let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
"let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name

""""""""""""""""""""""""""""""""""""""
" ----- Debugger config {{{1
""""""""""""""""""""""""""""""""""""""
nmap <leader>ds :GdbDebugStop <CR>

""""""""""""""""""""""""""""""""""""""
" ----- Floaterm configs {{{1
""""""""""""""""""""""""""""""""""""""
" By default the window floats
"let g:floaterm_wintype = 'normal'
let g:floaterm_width = 0.9
let g:floaterm_height = 0.5
let g:floaterm_position='bottom'
let g:floaterm_keymap_toggle = '<C-Space>' " Replaces alternate backspace
"let g:floaterm_autoinsert = v:false
let g:floaterm_keymap_new = '<Leader>to'
let g:floaterm_keymap_next = '<Leader>tn'
let g:floaterm_keymap_prev = '<Leader>tp'

""""""""""""""""""""""""""""""""""""""
" ----- Latex Vim configs {{{1
""""""""""""""""""""""""""""""""""""""
let g:tex_flavor = 'latex'
if has('nvim')
  let g:vimtex_compiler_progname = 'nvr'
endif
let g:vimtex_fold_manual = 1
let g:vimtex_latexmk_continuous = 1
"use SumatraPDF if you are on Windows
let g:vimtex_view_method = 'zathura'

""""""""""""""""""""""""""""""""""""""
" ----- Nvim-r configs {{{1
""""""""""""""""""""""""""""""""""""""
" '__' to convert into '<-'
let g:R_assign = 2

""""""""""""""""""""""""""""""""""""""
" ----- ALE configs {{{1
""""""""""""""""""""""""""""""""""""""
map <leader>at :ALEToggle<CR>
map <leader>an :ALENext<CR>
map <leader>ap :ALEPrevious<CR>
"read .tsx files as .ts
let g:ale_linter_aliases = {'typescriptreact': 'typescript'}

" Note to future self, there may be unnecessry double checking with clangtidy's static-analser and clang
let g:ale_linters = {'cpp': ['clangtidy', 'cppcheck'], 'haskell': ['hlint', 'hdevtools', 'hfmt']}
" Still don't know if i really need clangcheck
"let g:ale_linters = {'cpp': ['clangtidy','clangcheck','cppcheck']}
"let g:ale_cpp_clangcheck_executable = 'clang-check'
"let g:ale_cpp_clangcheck_options = ''
let g:ale_cpp_clangtidy_checks = ['*', 'cppcoreguidelines-*']
let g:ale_cpp_clangtidy_executable = 'clang-tidy'
let g:ale_cpp_clangtidy_options = ''
let g:ale_cpp_cppcheck_executable = 'cppcheck'
let g:ale_cpp_cppcheck_options = '--enable=style'
" Still haven't figured out how to make this work or if i need it whil Coc is running
"let g:ale_fixers = {'cpp': ['clangtidy','clang-format']}

""""""""""""""""""""""""""""""""""""""
" ----- COC.nvim config {{{1
""""""""""""""""""""""""""""""""""""""
" List of extensions used for book keeping
" coc-snippets, coc-prettier, coc-marketplace, coc-lists, coc-eslint
" coc-emmet, coc-vimtex, coc-tsserver, coc-python, coc-json
" coc-java-debug, coc-java, coc-css, coc-clangd, coc-r-lsp

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
" decided to keep gi to its default mapping coc implemenation not available for most of my
" LS
"nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <S-TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList - Commented out lines means use fzf instead
" Show all diagnostics.
nnoremap <silent> ,a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> ,e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> ,c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> ,o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> ,s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> ,j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> ,k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> ,p  :<C-u>CocListResume<CR>
" Files list
"nnoremap <silent> ,f  :<C-u>CocList files<CR>
" Buffer list
"nnoremap <silent> ,b  :<C-u>CocList buffers<CR>
" grep search for phrase in cwd
"nnoremap <silent> ,g  :<C-u>CocList -I grep<CR>

