local M = {}

function M.setup()
  local status_ok, actions = pcall(require, "nvim-web-devicons")
  if not status_ok then
    print("Error loading nvim-web-devicons")
    return
  end
  require'nvim-web-devicons'.setup {
   -- your personnal icons can go here (to override)
   -- you can specify color or cterm_color instead of specifying both of them
   -- DevIcon will be appended to `name`
   override = {
    zsh = {
      icon = "",
      color = "#428850",
      cterm_color = "65",
      name = "Zsh"
    }
   };
   -- globally enable default icons (default to false)
   -- will get overriden by `get_icons` option
   default = true;
  }
end


return M
