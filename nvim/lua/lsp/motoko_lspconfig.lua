-- Copied from Cris' PR
local configs = require 'lspconfig.configs'
local util = require 'lspconfig.util'

bin_name = "/home/judemlim/.local/bin/dfx"

local util = require 'lspconfig.util'

local bin_name = 'dfx'

local function readFile(filePath)
  local file = io.open(filePath, 'r')
  local data = file:read '*a'
  file.close()
  return data
end

local function get_canister()
  local json = vim.json.decode(readFile(vim.loop.cwd() .. '/dfx.json'))

  local canister_names = {}
  local n = 0

  for k, _ in pairs(json['canisters']) do
    n = n + 1
    canister_names[n] = k
  end

  local CANISTER_NAME = ''

  vim.ui.select(canister_names, { prompt = 'Choose Canister' }, function(selection)
    if selection == nil then
      vim.notify 'No canister chosen, language server will not start'
      return
    end
    -- TODO: find a better way to do this
    CANISTER_NAME = selection
  end)

  return CANISTER_NAME
end


configs.motoko = {
  default_config = {
    on_new_config = function(new_config, _)
      if not new_config.cmd then
          new_config.cmd = { bin_name, '_language-service',  get_canister() }
      end
    end,
    cmd = {bin_name, "_language-service", "channel"},
    filetypes = { "motoko", "mo", "gdmo"},
    root_dir = util.root_pattern('.git', 'dfx.json'),
    single_file_support = true,
    settings={}
  },
  docs = {
    description = [[]],
    default_config = {
      root_dir = [[root_pattern("dfx.json", ".git")]],
    },
  },
}

configs.motoko.setup{
  on_attach = on_attach,
}
