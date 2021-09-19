""""""""""""""""""""""""""""""""""""""
" ----- Plugins {{{1
""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.local/share/nvim/plugged')

""" --- General --- 
" Improved cursor movement
Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'unblevable/quick-scope'

" Snippets
"Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'

" Github codereviews
Plug 'junkblocker/patchreview-vim'
Plug 'codegram/vim-codereview'

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

" Extra useful shortcuts
Plug 'tpope/vim-unimpaired'

" Ability to apply repeat '.' to some commands
Plug 'tpope/vim-repeat'

" Improved Find and replace (still learning how to use)
Plug 'brooth/far.vim'

""" --- File navigation ---
"Plug 'scrooloose/nerdTree'
Plug 'tpope/vim-vinegar'
" very useful fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Ranger
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'

""" --- Aesthetics --- 
" Aesthetic bar for mode tracking
Plug 'vim-airline/vim-airline'
"Plug 'itchyny/lightline.vim'

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

""" --- React/webdev plugins ---  
" Typescript highlighting
"Plug 'HerringtonDarkholme/yats.vim'
" React Syntax Highlighting
Plug 'maxmellon/vim-jsx-pretty'
" Javascript syntax highlighting
Plug 'yuezk/vim-js'
Plug 'pangloss/vim-javascript'    " JavaScript support

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

""" --- All syntax hightlighting ---
Plug 'sheerun/vim-polyglot'

""" --- Note taking ---
Plug 'vimwiki/vimwiki'

""" --- Intutive book marks ---
Plug 'MattesGroeger/vim-bookmarks'


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
" keeps undo history when changing buffers I think
set hidden

" Disable cursor blinking
set guicursor+=a:blinkon0

let mapleader = "\<Space>"
" Map leader '\' to space
"nmap <Space> <Leader>
"vmap <Space> <Leader>

set encoding=utf-8
" Turn of highlighting
"map <esc> :noh<cr>
nnoremap <leader>n :noh<CR>

" open new terminal window in directory
command T execute '!kitty &'
command R execute '!kitty -e ranger&'

map <leader>v :vsp<CR>
map <leader>s :sp<CR>
map <leader>t :tabnew<CR>
map <leader>T <C-W>T<CR>

" Fast saving
nmap <C-s> :w!<cr>

"" Speed up scrolling in Vim
set ttyfast

" Ignore case when searching
set ignorecase

" *** Buffer management
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

" when the pop up appears it allows <C-j> to move selection cursor - I don't  think I use this at all
"inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
"inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

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

function! DeleteHiddenBuffers()
  let tpbl=[]
  let closed = 0
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    if getbufvar(buf, '&mod') == 0
      silent execute 'bwipeout' buf
      let closed += 1
    endif
  endfor
  echo "Closed ".closed." hidden buffers"
endfunction
command! DeleteHiddenBuffers :call DeleteHiddenBuffers()<CR>


"Set python3 location
let g:python3_host_prog = "/bin/python3"

" make zsh invocation in vim interactive - disabled because it made one of the plugins very slow
"set shell=zsh\ -i

nmap <Leader>= <C-W>= 

map <silent> <A-h> <C-w>5<
map <silent> <A-j> <C-W>5-
map <silent> <A-k> <C-W>5+
map <silent> <A-l> <C-w>5>


""" Toggle location and buffer list
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

nmap <silent> <backspace>l :call ToggleList("Location List", 'l')<CR>
nmap <silent> <backspace>q :call ToggleList("Quickfix List", 'c')<CR>
nmap <silent> <backspace>o :only<CR>

" **attemp to add closing tags - currently using snippets
iabbrev </ </<C-X><C-O>

" ** Goyo (zen mode copy) - There is a new zen mode for nvim 0.5, should check it out
let g:goyo_width = 120
map <silent><Leader>z :Goyo<Cr>


" ----- FZF configs {{{1

nnoremap ,g :GFiles<CR>
nnoremap ,f :Files<CR>
nnoremap ,b :Buffers<CR>
nnoremap ,C :Commands<CR>
nnoremap ,M :Maps<CR>
nnoremap ,m :Marks<CR>
nnoremap ,w :Windows<cr>
nnoremap ,l :Lines<cr>
" ripgrep
nnoremap ,rg :Rg<cr>
" Ripgrep word on cursor
nnoremap ,rs :Rg <c-r><c-w><CR>
" Buffer history
nnoremap ,h :History<CR>
" Command history
nnoremap ,Hc :History:<CR>
" Search History
nnoremap ,Hs :History/<CR>

command! Directories :call fzf#run(fzf#wrap({'source': 'find * -type d'}))<CR>
nnoremap ,d :Directories<CR>

" Extend all fuzzy commands to the quick fix list
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'
command! -bang -nargs=* Rg call fzf#vim#grep("rg  --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

" ----- Nerd Commenter configs {{{1

let g:NERDCustomDelimiters={
      \ 'javascript': { 'left': '//', 'right': '', 'leftAlt': '{/*', 'rightAlt': '*/}' },
      \}


" ----- Theme/Color settings {{{1

" Color Scheme
colorscheme gruvbox
set bg=light
set termguicolors

" vim-color brackets on globally - vim rainbow
let g:rainbow_active = 1
let g:rainbow_conf = {
\	'separately': {
\		'nerdtree': 0,
\   'cmake':0,
\	}
\}
let g:vim_jsx_pretty_colorful_config = 1

" Allow powerline font
let g:airline_powerline_fonts = 1
let g:airline#extensions#coc#enabled = 0


" ----- Navigation {{{1

let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_keys='idasonetuhjkcr'

" Using owerviw motion because they don't take up 
" as much cpu for some reason
nmap <backspace>s <Plug>(easymotion-overwin-f2)
"nmap s <Plug>(easymotion-s)
"nmap f <Plug>(easymotion-overwin-f)
"map <Leader>l <Plug>(easymotion-sol-j)
"map <Leader>e <Plug>(easymotion-overwin-w)
"map <Leader>w <Plug>(easymotion-bd-W)

"omap t <Plug>(easymotion-bd-tl)
"nmap t <Plug>(easymotion-t2)
"nmap T <Plug>(easymotion-T2)
"nmap <leader>m <Plug>(easymotion-repeat)
" Move to line
"map <Leader>L <Plug>(easymotion-bd-jk)
"nmap <Leader>L <Plug>(easymotion-overwin-line)

" Jump to anywhere you want with minimal keystrokes, with just one key bindC-n `s{char}{label}`
"nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, bu on average, it may be more comfortable.
"nmap s <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
"let g:EasyMotion_smartcase = 1

" Different colours for if 1 or 2 keys are needed to be pressed
"hi EasyMotionTarget ctermbg=none ctermfg=red 
"hi EasyMotionTarget2 ctermbg=none ctermfg=yellow

"hi EasyMotionTarget2First ctermbg=none ctermfg=red
"hi EasyMotionTarget2Second ctermbg=none ctermfg=yellow

" Line motions - disabled because it seems to take up alot of resources 
"map <Leader>j <Plug>(easymotion-j)
"map <Leader>k <Plug>(easymotion-k)
"map <Leader>w <Plug>(easymotion-w)
"map <Leader>e <Plug>(easymotion-e)
"map <Leader>b <Plug>(easymotion-b)
"map <Leader>ge <Plug>(easymotion-ge)

" Hack to prevent linting errors when using motions
"autocmd User EasyMotionPromptBegin silent! CocDisable
"autocmd User EasyMotionPromptEnd silent! CocEnable

" Easy motion labelling
let g:sneak#label = 1

" Contrls whether vims 'ignorecase' or 'smartcase' are respected
let g:sneak#use_ic_scs = 1

" immediately move to the next instance of search, if you move the cursor sneak is back to default behavior
let g:sneak#s_next = 1

" Cool prompts
 let g:sneak#prompt = '🔎'

" remap so I can use , and ; with f and t
map gS <Plug>Sneak_,
map gs <Plug>Sneak_;

highlight Sneak guifg=black guibg=#00C7DF ctermfg=black ctermbg=cyan
15
highlight SneakScope guifg=red guibg=yellow ctermfg=red ctermbg=yellow

" Quick scope
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
highlight QuickScopePrimary guifg='#00C7DF' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#FF1493' gui=underline ctermfg=81 cterm=underline
let g:qs_max_chars=150

" ----- Text, tab, folds, and index related {{{1

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
nmap <leader>gf :GitGutterFold<CR>



" ----- Navigation configs {{{1

" Trying out netrw
let g:netrw_liststyle=3
autocmd FileType netrw setl bufhidden=wipe

"map <leader>l :NERDTreeToggle %<CR>
"map <leader>L :NERDTreeToggle<CR>


" ----- Debugger config {{{1

nmap <leader>ds :GdbDebugStop <CR>


" ----- Floaterm configs {{{1
" TODO: Add open terminal in current file
" By default the window floats
"let g:floaterm_wintype = 'normal'
let g:floaterm_width = 0.95
let g:floaterm_height = 0.95
let g:floaterm_position='bottom'
let g:floaterm_keymap_toggle = '<C-t>' " Replaces alternate backspace
"let g:floaterm_autoinsert = v:false
let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_toggle = '<F12>'
let g:floaterm_keymap_kill = '<F4>'

map <F6> :FloatermNew! cd %:p:h<CR>

" ----- Latex Vim configs {{{1

let g:tex_flavor = 'latex'
if has('nvim')
  let g:vimtex_compiler_progname = 'nvr'
endif
let g:vimtex_fold_manual = 1
let g:vimtex_latexmk_continuous = 1
"use SumatraPDF if you are on Windows
let g:vimtex_view_method = 'zathura'


" ----- Nvim-r configs {{{1
" '__' to convert into '<-'
let g:R_assign = 2


" ----- ALE configs {{{1
map <leader>a :ALEToggle<CR>
map <C-n> :ALENext<CR>
map <C-p> :ALEPrevious<CR>
"read .tsx files as .ts
let g:ale_linter_aliases = {'typescriptreact': 'typescript'}

" Note to future self, there may be unnecessry double checking with clangtidy's static-analser and clang
let g:ale_linters = {'cpp': ['clangtidy', 'cppcheck'], 'haskell': ['hlint', 'hdevtools', 'hfmt'], 'javascript':['flow'] }
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
"" Use coc-nvim lsp instead
let g:ale_disable_lsp = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_linters_ignore = {'typescript': ['tslint']}
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" ----- COC.nvim config {{{1
let g:coc_global_extensions = [
      \'coc-json',
      \'coc-prettier',
      \'coc-marketplace',
      \'coc-lists',
      \'coc-eslint',
      \'coc-emmet',
      \'coc-vimtex',
      \'coc-python',
      \'coc-java-debug',
      \'coc-java',
      \'coc-css',
      \'coc-cmake',
      \'coc-clangd',
      \'coc-r-lsp',
      \'coc-tsserver',
      \'coc-snippets',
      \]


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
" I got use to C-p and C-n - less pinky movement
"inoremap <silent><expr> <TAB>
      "\ pumvisible() ? "\<C-n>" :
      "\ <SID>check_back_space() ? "\<TAB>" :
      "\ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

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

" Symbol renaming. TODO: Remove the autoformatting that happens
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

if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

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

" Show function hints
inoremap <C-P> <C-\><C-O>:call CocActionAsync('showSignatureHelp')<cr>

" ----- Vim wiki configs {{{1
"let g:vimwiki_map_prefix = '<Leader>W'
let g:vimwiki_table_auto_fmt = 1
nmap <Leader>wl <Plug>VimwikiNextLink

" ----- Git shortcuts {{{1
nnoremap <leader>G :Git 
nnoremap <leader>gd :Gvdiffsplit<CR>
nnoremap <leader>gs :Git<CR> 
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gt :Git difftool<CR>
nnoremap <leader>gl :Gclog -- %<CR>
" Show history of current file
nnoremap <leader>gh :0Gclog<CR>


" ----- Ranger shortcuts {{{1
let g:ranger_map_keys = 0
let g:no_plugin_maps = 1
map <leader>ra :Ranger<CR>

" ----- Bclose {{{1
nnoremap ZC :Bclose<CR>

 "----- Coc Snippets {{}{1
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)
