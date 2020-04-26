""""""""""""""""""""""""""""""""""""""
" ----- Plugins {{{1
""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.local/share/nvim/plugged')
""" --- File navigation ---
Plug 'scrooloose/nerdTree'
" fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Improved cursor movement - some conflicts with coc, consider removing
Plug 'easymotion/vim-easymotion'

" Snippets
Plug 'honza/vim-snippets'

" Git integration
Plug 'tpope/vim-fugitive'

" FZF, buffer switcher, directory manager
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }

"Pair up enclosing characters
Plug 'jiangmiao/auto-pairs'

" Insert/replace/delete typeof brackets
Plug 'tpope/vim-surround'

" Multi line commentor
Plug 'scrooloose/nerdcommenter'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'

" Debugger
Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }

"  repeat macros/plugins (I think)
Plug 'tpope/vim-repeat'

" Terminal improvements
Plug 'voldikss/vim-floaterm'

" language server for intellisense code completion
" relies on node
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" linter - better linter than coc.nvim
Plug 'dense-analysis/ale'

""" --- Aesthetics --- 
" Aesthetic bar for mode tracking
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'itchyny/lightline.vim'
"" Color schemes
Plug 'flazz/vim-colorschemes'
" Bracket colors - might get rid of these
Plug 'frazrepo/vim-rainbow'

""" Latex Plugins 
Plug 'lervag/vimtex'
Plug 'Konfekt/FastFold'
Plug 'matze/vim-tex-fold'

""" C Plugins 
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

call plug#end()

""""""""""""""""""""""""""""""""""""""
" ----- Aliases {{{1
""""""""""""""""""""""""""""""""""""""
" open new terminal window in directory
command T silent execute '!urxvt &'
command R silent execute '!urxvt -e ranger&'

""""""""""""""""""""""""""""""""""""""
" ---- Simple plugin mappings {{{1
""""""""""""""""""""""""""""""""""""""
map <C-o> :NERDTreeToggle<CR>
nmap <leader>m <Plug>(easymotion-prefix)
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name

""""""""""""""""""""""""""""""""""""""
" ----- General{{{1
""""""""""""""""""""""""""""""""""""""
syntax on
set number

" Map leader '\' to space
nmap <Space> <Leader>
vmap <Space> <Leader>
"let mapleader=" "

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

" More natural split opening
set splitbelow
set splitright

" Enable file specific key bindings and features defined in the ftplugin folder
filetype plugin indent on

" when the pop up appears it allows <C-j> to move selection cursor
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

" More natural terminal mode escape
tnoremap <Esc> <C-\><C-n> <bar> :FloatermToggle <CR>
" Easy open and close terminal
"tnoremap <Space> <Leader>

"""""""""""""""""""""""""""""""""""""
" ----- Theme/Color settings {{{1
""""""""""""""""""""""""""""""""""""""
" Color Scheme
colorscheme gruvbox

" vim-color brackets on globally
let g:rainbow_active = 1

""""""""""""""""""""""""""""""""""""""
" ----- Text, tab, folds, and index related {{{1
""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

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
"""
" ----- Debugger Config {{{1
"""
nmap <leader>ds :GdbDebugStop <CR>

""""""""""""""""""""""""""""""""""""""
" ----- Denite configs {{{1
""""""""""""""""""""""""""""""""""""""
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction

""""""""""""""""""""""""""""""""""""""
" ----- Floaterm configs {{{1
""""""""""""""""""""""""""""""""""""""
" By default the window floats
"let g:floaterm_wintype = 'normal'
let g:floaterm_width = 0.9
let g:floaterm_height = 0.5
let g:floaterm_position='bottom'
let g:floaterm_keymap_toggle = '<Leader>t'
"let g:floaterm_autoinsert = v:false
"let g:floaterm_keymap_new = '<Leader>to'
"let g:floaterm_keymap_next = '<Leader>tn'
"let g:floaterm_keymap_prev = '<Leader>tp'

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
" ----- ALE customisations {{{1
""""""""""""""""""""""""""""""""""""""
map <leader>at :ALEToggle<CR>
map <leader>an :ALENext<CR>
"read .tsx files as .ts
let g:ale_linter_aliases = {'typescriptreact': 'typescript'}
let g:ale_linters = {'cpp': ['clang']}

""""""""""""""""""""""""""""""""""""""
" ----- COC.nvim config {{{1
""""""""""""""""""""""""""""""""""""""
let g:python3_host_prog = "/home/judemlim/miniconda3/envs/baby-snake/bin/python"
"let g:python3_host_prog = "/home/judemlim/anaconda3/bin/python"
" coc-smartf
nmap f <Plug>(coc-smartf-forward)
nmap F <Plug>(coc-smartf-backward)
nmap ; <Plug>(coc-smartf-repeat)
"nmap , <Plug>(coc-smartf-repeat-opposite)

augroup Smartf
  autocmd User SmartfEnter :hi Conceal ctermfg=220 guifg=#8b0000
  autocmd User SmartfLeave :hi Conceal ctermfg=239 guifg=#504945
augroup end

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
nmap <silent> gi <Plug>(coc-implementation)
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
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

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

" Mappings using CoCList:
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
nnoremap <silent> ,f  :<C-u>CocList files<CR>
" Buffer list
nnoremap <silent> ,b  :<C-u>CocList buffers<CR>
" grep search for phrase in cwd
nnoremap <silent> ,g  :<C-u>CocList -I grep<CR>

"function! StatusDiagnostic() abort
  "let info = get(b:, 'coc_diagnostic_info', {})
  "if empty(info) | return '' | endif
  "let msgs = []
  "if get(info, 'error', 0)
    "call add(msgs, 'E' . info['error'])
  "endif
  "if get(info, 'warning', 0)
    "call add(msgs, 'W' . info['warning'])
  "endif
  "return join(msgs, ' '). ' ' . get(g:, 'coc_status', '')
"endfunction
"function! CocCurrentFunction()
        "return get(b:, 'coc_current_function', '')
    "endfunction

"let g:lightline = {
      "\ 'colorscheme': 'wombat',
      "\ 'active': {
      "\   'left': [ [ 'mode', 'paste' ],
      "\             [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]
      "\ },
      "\ 'component_function': {
      "\   'cocstatus': 'coc#status',
      "\   'currentfunction': 'StatusDiagnostic'
      "\ },
      "\ }