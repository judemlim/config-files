" C++ mappings
map <F5> :w <CR>:!g++ -g % -Wall -Werror -o %< <CR>
let g:syntastic_c_compiler_options = ' --std=c++17'
nmap <leader>dd :GdbStart gdb -q %< <CR>
tnoremap <leader>dt a<CR>tbreak main <CR>run <CR>

" For semi colon plugin
nmap <silent> <Leader>; <Plug>(cosco-commaOrSemiColon)
imap <silent> <Leader>; <c-o><Plug>(cosco-commaOrSemiColon)

" clang-format
setlocal shiftwidth=2
setlocal tabstop=2
