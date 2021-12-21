-------------------------------- General LSP settings
local lspconfig = require("lspconfig")
-- additional typescript functionality not yet in typescript server but in vscode and tsservr
-- still testing

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

-- If gruvbox exists link the colours - it just becomes  a matter if what's loaded first
vim.cmd[[highlight DiagnosticError guifg='Pink']]

-- The lsps don't format location information in the diagnostic object the way nvim 0.6
-- expects it to be in its documentation
add_diagnostic_locations = function (original_diagnostics_table, index, diagnostics_value)
  original_diagnostics_table[index].lnum = diagnostics_value.range.start.line
  original_diagnostics_table[index].end_lnum = diagnostics_value.range['end'].line
  original_diagnostics_table[index].col = diagnostics_value.range.start.character
  original_diagnostics_table[index].end_col = diagnostics_value.range['end'].character
  original_diagnostics_table[index].message = diagnostics_value.message
  original_diagnostics_table[index].source = diagnostics_value.source
  original_diagnostics_table[index].user_data = {
    lsp = {
      code = diagnostics_value.code,
      codeDescription = diagnostics_value.codeDescription,
      tags = diagnostics_value.tags,
      relatedInformation = diagnostics_value.relatedInformation,
      data = diagnostics_value.data,
    },
  }
end



-- Adding a wrapper around `vim.lsp.diagnostic.on_publish_diagnostics` since
prefix_diagnostic_line_with_lsp = function (_, params, ctx, config)
    local diagnostics = params.diagnostics
    for i, v in ipairs(diagnostics) do
      local related_info_presentation = ""
      local relatedInformation = v.relatedInformation

      -- If there is additional related information then append to the end of the message
      -- NOTE: This is screwing up the quickfix list results somehow
      -- NOTE: There is room for improvement for formatting. I may want to have a different formatting
      -- function for each language server.
      -- NOTE: Next statement below checks if the table is empty
      if relatedInformation and next(relatedInformation) ~= nil then
        for _, v in ipairs(relatedInformation) do
          local start_line = v.location.range.start.line

          local file_path = v.location.uri
          -- If uri doesn't exist on the filepath then the error message is not what I expect
          if file_path == nil then
            local message = v.message
            local line = string.format("\n%s", message)
            related_info_presentation = related_info_presentation .. line
          else
            local related_uri = string.match(file_path, "file://(.*)")
            -- Failed to find match
            if not related_uri or related_uri == nil then
              -- Analogue of `continue` in other languages for loops
               goto skip_to_next
            end
            local message = v.message
            local line = string.format("\n%s: %s:%s", message, related_uri, start_line)
            related_info_presentation = related_info_presentation .. line
          end
          ::skip_to_next::
        end
      end
      diagnostics[i].message = string.format("%s: %s%s", v.source, v.message, related_info_presentation)

    end
    vim.lsp.diagnostic.on_publish_diagnostics({}, params, ctx, config)
end

-- Inject 'efm' prefix info into the diagnostics line
efm_diagnostics = function (_, params, ctx, config) 
    local diagnostics = params.diagnostics
    for i, v in ipairs(diagnostics) do
      diagnostics[i].message = string.format("efm: %s", v.message)
    end
    prefix_diagnostic_line_with_lsp({}, params, ctx, config)
end

tsserver_diagnostics = function (_, params, ctx, config) 
    local uri = params.uri
    local bufnr = vim.uri_to_bufnr(uri)
    -- NOTE: I want to use tsserver's definitions/implementation functionality on js files
    -- But I don't want to publish it's diagnostics on js files
    local isBufferJavascript = function(bufnr)
      return vim.bo[bufnr].filetype == 'javascript'
    end
    if isBufferJavascript(bufnr) then
      return
    end
    prefix_diagnostic_line_with_lsp({}, params, ctx, config)
end

lsp_diagnostic_display_config = {
  -- Enable underline, use default values
  underline = true,
  -- Enable virtual text, override spacing to 4
  virtual_text = false,
  signs = true,
  update_in_insert = false,
}

simple_diagnostic_info = vim.lsp.with(
  prefix_diagnostic_line_with_lsp, lsp_diagnostic_display_config
)


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
  buf_set_keymap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
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

-- NOTE: That this will probably break after the new changes
-- is_cfg_present = function(cfg_name)
--   -- this returns 1 if it's not present and 0 if it's present
--   -- we need to compare it with 1 because both 0 and 1 is `true` in lua
--   return vim.fn.empty(vim.fn.glob(vim.loop.cwd() .. cfg_name)) ~= 1
-- end
-- use eslint if the eslint config file present
-- local is_using_eslint = function(_, _, result, client_id)
--   if is_cfg_present("/.eslintrc.json") or is_cfg_present("/.eslintrc.js") then
--     return
--   end

--   return vim.lsp.handlers["textDocument/publishDiagnostics"](_, _, result, client_id)
-- end

local eslint = {
  -- lintCommand = "./node_modules/.bin/eslint --fix './src/**/*'",
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
    ["textDocument/publishDiagnostics"] = simple_diagnostic_info,
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
    ["textDocument/publishDiagnostics"] = vim.lsp.with(efm_diagnostics, lsp_diagnostic_display_config)
  },
}

local isBufferJavascript = function(bufnr)
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
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      tsserver_diagnostics, lsp_diagnostic_display_config
    )
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
    ["textDocument/publishDiagnostics"] = simple_diagnostic_info
  },
  -- on_attach = require'flow'.on_attach,
  on_attach = on_attach
}

------------------ Haskell setup
lspconfig.hls.setup{
  on_attach = on_attach,
  handlers = {
    ["textDocument/publishDiagnostics"] = simple_diagnostic_info
  }
}

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

-- require'lspconfig'.graphql.setup{
--   on_attach = on_attach,
-- }

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


-- load eslint diagnostics into quickfix list
-- :cexpr system("./node_modules/.bin/eslint --format unix --fix './src/**/*'")
-- vim.lsp.buf.execute_command({command = "_typescript.organizeImports", arguments = {vim.fn.expand("%:p")}})
-- TODO: FIX Issue with dignostics that have related information attached to them
function get_project_diagnostics()
  local diagnostics = vim.lsp.diagnostic.get_all()
  local qflist = {}
  for bufnr, diagnostic in pairs(diagnostics) do
    for _, d in ipairs(diagnostic) do
      d.bufnr = bufnr
      d.lnum = d.range.start.line + 1
      d.col = d.range.start.character + 1
      d.text = d.message
      table.insert(qflist, d)
    end
  end
  vim.lsp.util.set_qflist(qflist)
end

