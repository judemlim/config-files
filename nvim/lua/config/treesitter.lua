local M = {}

function M.setup()
  local status_ok, actions = pcall(require, "nvim-treesitter.configs")
  if not status_ok then
    print("Error loading treesitter")
    return
  end
  require'nvim-treesitter.configs'.setup {
    nsure_installed = {"javascript","typescript", "lua", "haskell", "graphql"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
      enable = true,
    },
    autotag = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    -- Comment based on node context
    context_commentstring = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
    },
    rainbow = {
      enable = false,
      -- extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
      -- Check performance?
      -- max_file_lines = 2000, -- Do not enable for files with more than 1000 lines, int
      -- TODO fill with dark colours
      -- colors = {
      --   -- Purple
      --   '#A020F0',
      --   -- Dark orange
      --   '#ff8c00',
      --   -- Navy blue
      --   '#000080',
      --   -- Dark red
      --   '#8b0000',
      -- }, -- table of hex strings
      --termcolors = {} -- table of colour name strings
    }
  }

end

return M
