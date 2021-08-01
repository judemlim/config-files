-------------------------------- General LSP settings
local lspconfig = require("lspconfig")

--vim.lsp.set_log_level("info")
--vim.lsp.set_log_level("debug")
--vim.lsp.callbacks["textDocument/publishDiagnostics"] = function() end
--vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  ----virtual_text = {
    ----prefix = "🔥",
    ----spacing = 1,
  ----},
  --virtual_text = false,
  --signs = true,
  --underline = true,

--})
-- Apply project wide diagnostics
lsp_handler =  function(_, _, params, client_id, _)
    local config = { -- your config
      underline = true,
      --virtual_text = {
        --prefix = "■ ",
        --spacing = 4,
      --},
      virtual_text = false,
      signs = true,
      update_in_insert = false,
    }
    local uri = params.uri
    local bufnr = vim.uri_to_bufnr(uri)

    if not bufnr then
      return
    end

    local diagnostics = params.diagnostics

    for i, v in ipairs(diagnostics) do
      diagnostics[i].message = string.format("%s: %s", v.source, v.message)
    end

    vim.lsp.diagnostic.save(diagnostics, bufnr, client_id)

    if not vim.api.nvim_buf_is_loaded(bufnr) then
      return
    end

    vim.lsp.diagnostic.display(diagnostics, bufnr, client_id, config)
  end

--buf_set_keymap('n', '<C-n>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
--capabilities.textDocument.publishDiagnostics = false
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  require "lsp_signature".on_attach()

  client.resolved_capabilities.document_formatting = true

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true }
  --local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  -- Use telescope instead
  --buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-space>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- Conflicting with nerd commenter
  --buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- Use telescope instead once I learn how to add to quickfix list
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  -- Jump to diagnostic and save into jumplist
  buf_set_keymap('n', '<C-p>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR><cmd> normal m\'<CR>', opts)
  buf_set_keymap('n', '<C-n>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR><cmd> normal m\'<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  --buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts) -- let plugin handle basic formatting for now

  buf_set_keymap('n', 'gd', "<cmd>Telescope lsp_definitions<CR>", {})
  buf_set_keymap('n', 'gr', "<cmd>Telescope lsp_references<CR>", {})
end
is_cfg_present = function(cfg_name)
  -- this returns 1 if it's not present and 0 if it's present
  -- we need to compare it with 1 because both 0 and 1 is `true` in lua
  return vim.fn.empty(vim.fn.glob(vim.loop.cwd() .. cfg_name)) ~= 1
end
-- use eslint if the eslint config file present
local is_using_eslint = function(_, _, result, client_id)
  if is_cfg_present("/.eslintrc.json") or is_cfg_present("/.eslintrc.js") then
    return
  end

  return vim.lsp.handlers["textDocument/publishDiagnostics"](_, _, result, client_id)
end

local eslint = {
  lintCommand = "eslint_d -f visualstudio  --stdin --stdin-filename ${INPUT}",
  lintFormats = {
    "%f(%l,%c): %tarning %m",
    "%f(%l,%c): %rror %m"
  },
  --lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  --lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  lintStdin = true,
}

local prettier = {
  formatStdin = true,
  formatCommand = (
  function()
    if not vim.fn.empty(vim.fn.glob(vim.loop.cwd() .. '/.prettierrc')) then
      return "prettier --config ./.prettierrc --stdin-filepath ${INPUT}"
    else
      return "prettier --config ~/.config/nvim/.prettierrc --stdin-filepath ${INPUT}"
    end
  end
  )()
}

------------------ Lua setup
-- https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
USER = vim.fn.expand('$USER')

local sumneko_root_path = ""
local sumneko_binary = ""

if vim.fn.has("mac") == 1 then
    sumneko_root_path = "/Users/" .. USER .. "/.config/nvim/lua-language-server"
    sumneko_binary = "/Users/" .. USER .. "/.config/nvim/lua-language-server/bin/macOS/lua-language-server"
elseif vim.fn.has("unix") == 1 then
    sumneko_root_path = "/home/" .. USER .. "/.config/nvim/lua-language-server"
    sumneko_binary = "/home/" .. USER .. "/.config/nvim/lua-language-server/bin/Linux/lua-language-server"
else
    print("Unsupported system for sumneko")
end

lspconfig.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
  settings = {
    Lua = {
      runtime = {
	-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
	version = 'LuaJIT',
	-- Setup your lua path
	path = vim.split(package.path, ';')
      },
      diagnostics = {
	-- Get the language server to recognize the `vim` global
	globals = {'vim'}
      },
      workspace = {
	-- Make the server aware of Neovim runtime files
	library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
      }
    }
  },
  on_attach = on_attach,
  handlers = {
    ["textDocument/publishDiagnostics"] = lsp_handler
  }
}

------------------ efm setup (currently used for linting) : could probably just put all the linter configs
-- into tsserver? https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c
lspconfig.efm.setup{
  cmd = { "efm-langserver" },
  on_attach = function(client)
    client.resolved_capabilities.rename = false
    client.resolved_capabilities.hover = false
    client.resolved_capabilities.document_formatting = true
    client.resolved_capabilities.completion = false
  end,
  --on_attach = on_attach,
  flags = {
    debounce_text_changes = 500,
  },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" },
  --filetypes = { "javascript", "javascriptreact", "svelte" },
  root_dir = lspconfig.util.root_pattern("package.json"),
  settings = {
    --rootMarkers = { "package.json" },
    languages = {
      javascript = { eslint, prettier  },
      typescript = { eslint, prettier },
      typescriptreact = { eslint, prettier },
    },
  },
  handlers = {
    ["textDocument/publishDiagnostics"] = function(_, _, params, client_id, _)
      local config = { -- your config
        underline = true,
        --virtual_text = {
        --prefix = "■ ",
        --spacing = 4,
        --},
        virtual_text = false,
        signs = true,
        update_in_insert = false,
      }
      local uri = params.uri
      local bufnr = vim.uri_to_bufnr(uri)

      if not bufnr then
        return
      end

      local diagnostics = params.diagnostics

      for i, v in ipairs(diagnostics) do
        -- efm v.source in null, it is using eslint to perform diagnostics
        diagnostics[i].message = string.format("efm: %s", v.message)
      end

      vim.lsp.diagnostic.save(diagnostics, bufnr, client_id)

      if not vim.api.nvim_buf_is_loaded(bufnr) then
        return
      end

      vim.lsp.diagnostic.display(diagnostics, bufnr, client_id, config)
    end
  }
  --handlers = {
    --["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      --virtual_text = {
	--prefix = "ⓔ",
      --},
    --}),
  --},
}

local isBufferJavascript = function(bufnr, _)
  return vim.bo[bufnr].filetype == 'javascript'
end
------------------ typescript setup
-- use eslint to handle diagnostics
local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = {vim.api.nvim_buf_get_name(0)},
    title = ""
  }
  vim.lsp.buf.execute_command(params)
end
lspconfig.tsserver.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
  handlers = {
    root_dir = lspconfig.util.root_pattern("package.json"),
    on_new_config = function(new_config, new_root_dir)
      new_config.cmd_cwd = new_root_dir
    end,
    ["textDocument/publishDiagnostics"] = function(_, _, params, client_id, _)
      local uri = params.uri
      local bufnr = vim.uri_to_bufnr(uri)
      if isBufferJavascript(bufnr) then
        return
      end

      local config = { -- your config
        underline = true,
        --virtual_text = {
        --prefix = "■ ",
        --spacing = 4,
        --},
        virtual_text = false,
        signs = true,
        update_in_insert = false,
      }
      if not bufnr then
        return
      end

      local diagnostics = params.diagnostics

      for i, v in ipairs(diagnostics) do
        diagnostics[i].message = string.format("%s: %s", v.source, v.message)
      end

      if vim.bo.filetype ~= 'javascript' then
        vim.lsp.diagnostic.save(diagnostics, bufnr, client_id)
      else
        vim.lsp.diagnostic.save({}, bufnr, client_id)
      end

      if not vim.api.nvim_buf_is_loaded(bufnr) then
        return
      end

      vim.lsp.diagnostic.display(diagnostics, bufnr, client_id, config)
    end
    ,
  },
  commands = {
    OrganizeImports = {
      organize_imports,
      description = "Organize Imports"
    }
  },
}

------------------ Javascript setup
lspconfig.flow.setup{
  capabilities = capabilities,
  cmd = { "npx", "flow", "lsp" },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx" },
  root_dir = lspconfig.util.root_pattern(".flowconfig"),
  on_new_config = function(new_config, new_root_dir)
    new_config.cmd_cwd = new_root_dir -- npx looks for a flow file so it has to be in the same directory as root
  end,
  flags = {
    debounce_text_changes = 500,
  },
  settings = {
    enabled = false
  },
  handlers = {
    ["textDocument/publishDiagnostics"] = lsp_handler
  }
  --on_attach = on_attach
}

------------------ Haskell setup
lspconfig.hls.setup{
  on_attach = on_attach,
  handlers = {
    ["textDocument/publishDiagnostics"] = lsp_handler
  }
}
--vim.api.nvim_set_keymap(
    --'n',
    --'<Leader>lv',
    --'<Cmd>lua require("virtual-text").toggle()<CR>',
    --{silent=true, noremap=true}
--)

-- TODO: Refactor  and utilise the code below as this file gets bigger. Consider running server depending on filetype as well - ftplugin
--local servers = {"flow"}
--for _, lsp in ipairs(servers) do
  --lspconfig[lsp].setup {
    --on_attach = on_attach,
    --flags = {
      --debounce_text_changes = 150,
    --}
  --}
--end

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
 end

 --s:lua print(vim.inspect(vim.lsp.get_active_clients())
getServerCapabilities = function()
  local table = (vim.lsp.protocol.make_client_capabilities())
  local result = dump(table)
  print(result)
end


-- TODO (get formatter working) - currently 'mhartington/formatter.nvim'
--function format_range_operator()
  --local old_func = vim.go.operatorfunc
  --_G.op_func_formatting = function()
    --local start = vim.api.nvim_buf_get_mark(0, '[')
    --local finish = vim.api.nvim_buf_get_mark(1, ']')
    --vim.lsp.buf.range_formatting({}, start, finish)
    --vim.go.operatorfunc = old_func
    --_G.op_func_formatting = nil
  --end
  --vim.go.operatorfunc = 'v:lua.op_func_formatting'
  --vim.api.nvim_feedkeys('g@', 'n', false)
--end
--vim.api.nvim_set_keymap("n", "gm", "<cmd>lua format_range_operator()<CR>", {noremap = true})

-- TODO make function to get projec diagnostics
--function get_project_diagnostics()
  --local method = "textDocument/publishDiagnostics"
  --local default_handler = vim.lsp.handlers[method]
  --vim.lsp.handlers[method] = function(err, method, result, client_id, bufnr, config)
    --default_handler(err, method, result, client_id, bufnr, config)
    --local diagnostics = vim.lsp.diagnostic.get_all()
    --local qflist = {}
    --for bufnr, diagnostic in pairs(diagnostics) do
      --for _, d in ipairs(diagnostic) do
        --d.bufnr = bufnr
        --d.lnum = d.range.start.line + 1
        --d.col = d.range.start.character + 1
        --d.text = d.message
        --table.insert(qflist, d)
      --end
    --end
    --vim.lsp.util.set_qflist(qflist)
  --end
--end

-- TODO organise imports
-- vim.lsp.buf.execute_command({command = "_typescript.organizeImports", arguments = {vim.fn.expand("%:p")}})
--
