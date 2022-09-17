local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local function readFile(filePath)
  local file = io.open(filePath, 'r')
  local data = file:read '*a'
  file.close()
  return data
end

local function getCanisterNames(json)
  local canister_names = {}
  local n = 0
  for k, _ in pairs(json['canisters']) do
    n = n + 1
    canister_names[n] = k
  end
  return canister_names
end

local startMotoko = function (canisterName)
  local client = vim.lsp.start({
     name = 'motoko',
     cmd = {'/home/judemlim/.local/bin/dfx', '_language-service', canisterName},
     root_dir = vim.fs.dirname(vim.fs.find({'dfx.json', '.git'}, { upward = true })[1])
  })
  if client ~= nil then
    local bufnr = vim.api.nvim_get_current_buf()
    require("lsp.keys").setup(client, bufnr)
  end
end

Start_Motoko_LSP = function(opts)
  opts = opts or {}
  local json = vim.json.decode(readFile(vim.loop.cwd() .. '/dfx.json'))
  local canisterNames = getCanisterNames(json)

  -- Stop motoko language servers first
  vim.lsp.stop_client(vim.lsp.get_active_clients({name = 'motoko'}), true)

  pickers.new(require("telescope.themes").get_dropdown{}, {
    prompt_title = "Select canisters",
    finder = finders.new_table {
      results = canisterNames
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        startMotoko(selection[1])
      end)
      return true
    end,
  }):find()
end

Force_Stop_Motoko = function ()
  vim.lsp.stop_client(vim.lsp.get_active_clients({name = 'motoko'}), true)
end

vim.api.nvim_create_user_command(
  'RestartMotoko',
  "lua Start_Motoko_LSP()",
  {}
)

