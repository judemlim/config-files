-------------------------------- General LSP settings
-- Heavily copied Folke's .config layout https://github.com/folke/dot/blob/master/config/nvim/lua/config/lsp/init.lua
local function on_attach(client, bufnr)
  -- require("nvim-navic").attach(client, bufnr)
  require("lsp.formatting").setup(client, bufnr)
  require("lsp.diagnostics").setup(client, bufnr)
  require("lsp.keys").setup(client, bufnr)
end

---@type LspConfigSettings
local servers = {
  bashls = {},
  cssls = {},
  dockerls = {},
  tsserver = {},
  clangd = {},
  -- yamlls = {},
  -- eslint = {},
  html = {},
  -- jsonls = {
  --   settings = {
  --     json = {
  --       schemas = require("schemastore").json.schemas(),
  --       validate = { enable = true },
  --     },
  --   },
  -- },
  pyright = {},
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        checkOnSave = {
          command = "clippy",
          extraArgs = { "--no-deps" },
        },
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  },
    -- sumneko_lua = {
  --   single_file_support = true,
  --   settings = {
  --     Lua = {
  --     runtime = {
	-- -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
	-- version = 'LuaJIT',
	-- -- Setup your lua path
	-- path = vim.split(package.path, ';')
  --     },
  --     diagnostics = {
	-- -- Get the language server to recognize the `vim` global
	-- globals = {'vim'}
  --     },
  --     workspace = {
	-- -- Make the server aware of Neovim runtime files
	-- library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
  --     }
  --     },
  --   },
  -- },
  vimls = {},
  -- tailwindcss = {},
}

local options = {
  on_attach = on_attach,
  -- capabilities = capabilities, -- FIX
  flags = {
    debounce_text_changes = 150,
  },
}

for server, opts in pairs(servers) do
  opts = vim.tbl_deep_extend("force", {}, options, opts or {})
  -- require("lspconfig")[server].setup(opts)
  if server == "tsserver" then
      require("typescript").setup({ server = opts })
  else
    require("lspconfig")[server].setup(opts)
  end


  -- Issue with Clangd and utf-16 encoding
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.offsetEncoding = { "utf-16" }
  require("lspconfig").clangd.setup({ capabilities = capabilities })

end


-- Currently manually starting the motoko lsp
require "lsp.motoko_manual"



