
vim.pretty_print("running moto server")
vim.lsp.start({
  name = 'Motoko LSP',
  cmd = {'dfx _language-service channel'},
  root_dir = vim.fs.dirname(vim.fs.find({'dfx.json'}, { upward = true })[1]),
})
