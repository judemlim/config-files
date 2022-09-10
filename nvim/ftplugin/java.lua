-- see `:help vim.lsp.start_client` Understand the supported `config` Overview of options .
local config = {

-- Command to start the language server 
-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
cmd = {

-- 
'java', -- Or the absolute path '/path/to/java11_or_newer/bin/java'
-- Depending on `java` Whether in your $PATH Environment variable and whether it points to the correct version .
'-Declipse.application=org.eclipse.jdt.ls.core.id1',
'-Dosgi.bundles.defaultStartLevel=4',
'-Declipse.product=org.eclipse.jdt.ls.core.product',
'-Dlog.protocol=true',
'-Dlog.level=ALL',
'-Xms1g',
'--add-modules=ALL-SYSTEM',
'--add-opens', 'java.base/java.util=ALL-UNNAMED',
'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
-- 
--'-jar', '/home/judemlim/.config/nvim/jdt-language-server/plugins/org.eclipse.equinox.launcher_VERSION_NUMBER.jar',
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ^^^^^^^^^^^^^^
-- Must point to Change this to 
-- eclipse.jdt.ls The installation path The actual version 
'-jar', '/home/judemlim/.config/nvim/jdt-language-server/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
-- 
--'-configuration', '/path/to/jdtls_install_location/config_SYSTEM',
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ^^^^^^
-- Must point to the Change to one of `linux`, `win` or `mac`
-- eclipse.jdt.ls installation Depending on your system.
-- Here is what we unzipped above jdt-language-server Absolute path , I am here linux, Please adjust according to the system type 
'-configuration', '/home/judemlim/.config/nvim/jdt-language-server/config_linux',
-- 
-- see also README Medium “ Data directory configuration ” part 
'-data', '/home/judemlim/.config/nvim/jdt-language-server/workspace'
},
-- 
-- This is the default setting , If not provided , You can delete it . Or adjust as needed .
-- Each unique root_dir A dedicated... Will be started LSP Servers and clients 
root_dir = require('jdtls.setup').find_root({
'.git', 'mvnw', 'gradlew'}),
-- It can be configured here eclipse.jdt.ls Specific settings 
-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
-- A list of options 
settings = {

java = {

}
},
-- Language server `initializationOptions`
-- You need to use jar File path extension `bundles`
-- If you want to use additional eclipse.jdt.ls plug-in unit .
--
-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
--
-- If you're not going to use a debugger or something eclipse.jdt.ls plug-in unit , You can delete it 
init_options = {

bundles = {
}
},
}
-- This will start a new client and server ,
-- Or according to `root_dir` Attach to existing clients and servers .
require('jdtls').start_or_attach(config)

local current_buff = vim.api.nvim_get_current_buf()

-- After the language server attaches to the current buffer 
-- Use on_attach The function maps only the following keys 
local java_on_attach = function(client, bufnr)

local function buf_set_keymap(...)
  vim.api.nvim_buf_set_keymap(bufnr, ...)
end
local function buf_set_option(...)
vim.api.nvim_buf_set_option(bufnr, ...)
end
--Enable completion triggered by <c-x><c-o>
buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- Mappings.
local opts = {
noremap = true, silent = true}
-- See `:help vim.lsp.*` for documentation on any of the below functions

buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
--buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
--buf_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
-- rename 
buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
-- Intelligent reminders , such as ： Automatic guiding package Has been used lspsaga The function in is replaced by 
buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
--buf_set_keymap('n', '<C-j>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
buf_set_keymap("n", "<S-C-j>", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
-- Code formatting 
buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
buf_set_keymap("n", "<leader>l", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
buf_set_keymap("n", "<leader>l", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
-- Automatically import all missing packages , Automatically delete redundant and unused packages 
buf_set_keymap("n", "<A-o>", "<cmd>lua require'jdtls'.organize_imports()<CR>", opts)
-- Functions that introduce local variables function to introduce a local variable
buf_set_keymap("n", "crv", "<cmd>lua require('jdtls').extract_variable()<CR>", opts)
buf_set_keymap("v", "crv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
--function to extract a constant
buf_set_keymap("n", "crc", "<Cmd>lua require('jdtls').extract_constant()<CR>", opts)
buf_set_keymap("v", "crc", "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", opts)
-- Extract a piece of code into an additional function function to extract a block of code into a method
buf_set_keymap("v", "crm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)
-- Code saving and automatic formatting formatting
-- vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]

vim.pretty_print("*aoeu aoeu aoeu aeou")

end

java_on_attach(nil, current_buff)
