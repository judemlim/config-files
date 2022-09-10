local M = {}

function M.setup()
  local status_ok, actions = pcall(require, "dap")
  if not status_ok then
    -- TODO Better error handling
    print("Error loading dap")
    return
  end
  -- Not working and I don't know why!!
  local dap = require("dap")
  dap.adapters.node2 = {
    type = 'executable',
    command = 'node',
    args = {os.getenv('HOME') .. '/vscode-node-debug2/out/src/nodeDebug.js'},
    --args = {'test'},
    --args = {os.getenv('HOME') .. '/vscode-node-debug2/out/src/nodeDebug.js'},
  }
  dap.configurations.typescript = {
    {
      host = '127.0.0.1',
      -- Check if I can dynamicall change the port?
      -- Is it possible to have multiple
      port = function()
        local path = vim.api.nvim_buf_get_name(0)
        if string.find(path, 'scheduler')
        then
          return 9231
        elseif string.find(path, 'worker')
        then
          return 9229
        else
          return 9229
        end
      end,
      -- port = 9229,
      type = 'node2',
      request = 'attach',
      name = 'debug',
      --program = '~/debug/test.js',
      -- program = '${workspaceFolder}/${file}',
      -- program = '${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      console = 'integratedTerminal',
    },
  }
  dap.configurations.javascript = {
    {
      host = '127.0.0.1',
      -- Check if I can dynamicall change the port?
      -- Is it possible to have multiple
      port = 9229,
      type = 'node2',
      request = 'attach',
      name = 'debug',
      --program = '~/debug/test.js',
      --program = '${workspaceFolder}/${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      console = 'integratedTerminal',
    },
  }

  --attach_dap = function()
  --print("attaching")
  --dap.run({
  --type = 'node2',
  --request = 'attach',
  --cwd = vim.fn.getcwd(),
  --sourceMaps = true,
  --protocol = 'inspector',
  ----skipFiles = {'<node_internals>/**/*.js'},
  --})
--print("finished")
  --end

  vim.api.nvim_set_keymap('n', '<leader>dt', [[<cmd>lua require'dap'.toggle_breakpoint()<cr>]], {})
vim.api.nvim_set_keymap('n', '<leader>da', [[<cmd>lua require'dap'.list_breakpoints()<CR>]], {})
  --vim.api.nvim_set_keymap('n', '<leader>da', [[<cmd>lua attach_dap()<cr>]], {})
  vim.api.nvim_set_keymap('n', '<leader>dc', [[<cmd>lua require'dap'.continue()<cr>]], {})
  vim.api.nvim_set_keymap('n', '<leader>ds', [[<cmd>lua require'dap'.close()<cr>]], {})
  vim.api.nvim_set_keymap('n', '<leader>d_', [[<cmd>lua require'dap'.disconnect();require'dap'.close();require'dap'.run_last()<CR>]], {})
  vim.api.nvim_set_keymap('n', '<leader>dn', [[<cmd>lua require'dap'.step_over()<CR>]], {})
  vim.api.nvim_set_keymap('n', '<leader>dk', [[<cmd>lua require'dap'.up()<CR>]], {})
  vim.api.nvim_set_keymap('n', '<leader>dj', [[<cmd>lua require'dap'.down()<CR>]], {})
  vim.api.nvim_set_keymap('n', '<leader>dh', [[<cmd>lua require'dap'.step_out()<CR>]], {})
  vim.api.nvim_set_keymap('n', '<leader>dl', [[<cmd>lua require'dap'.step_into()<CR>]], {})
  vim.api.nvim_set_keymap('n', '<leader>di', [[<cmd>lua require'dap.ui.variables'.hover()<CR>]], {})
  vim.api.nvim_set_keymap('n', '<leader>di', [[<cmd>lua require'dap.ui.variables'.visual_hover()<CR>]], {})
  vim.api.nvim_set_keymap('n', '<leader>di', [[<cmd>lua require'dap.ui.widgets'.hover()<CR>]], {})
  vim.api.nvim_set_keymap('n', '<leader>d?', [[<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>]], {})
  vim.api.nvim_set_keymap('n', '<leader>dr', [[<cmd>lua require'dap'.repl.open()<CR>]], {})
  vim.api.nvim_set_keymap('n', '<leader>dD', [[<cmd>lua require'dap.breakpoints'.clear()<CR>]], {})

  -- TODO make its own file
  --require("dapui").setup({
  --icons = {
  --expanded = "▾",
  --collapsed = "▸"
  --},
  --mappings = {
  ---- Use a table to apply multiple mappings
  --expand = {"<CR>", "<2-LeftMouse>"},
  --open = "o",
  --remove = "d",
  --edit = "e",
  --},
  --sidebar = {
  --open_on_start = true,
  --elements = {
  ---- You can change the order of elements in the sidebar
  --"scopes",
  --"breakpoints",
  --"stacks",
  --"watches"
  --},
  --width = 40,
  --position = "left" -- Can be "left" or "right"
  --},
  --tray = {
  --open_on_start = true,
  --elements = {
  --"repl"
  --},
  --height = 10,
  --position = "bottom" -- Can be "bottom" or "top"
  --},
  --floating = {
  --max_height = nil, -- These can be integers or a float between 0 and 1.
  --max_width = nil   -- Floats will be treated as percentage of your screen.
--}
  --})
end


return M
