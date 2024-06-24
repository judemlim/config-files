require "general"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require "plugins"

-- require "lsp"

-- require("notify").setup({
--   background_colour = "#000000",
-- })
-- vim.notify = require("notify")

-- Neorg setup
-- Function to sync Dropbox Neorg directory to local
function SyncDropboxToNeorg()
  vim.cmd('silent !rclone sync dropbox:neorg ~/neorg > /dev/null 2>&1 &')
end
-- Function to sync local Neorg directory to Dropbox
function SyncNeorgToDropbox()
  vim.cmd('silent !rclone sync ~/neorg dropbox:neorg > /dev/null 2>&1 &')
end

-- Autocommand to run SyncDropboxToNeorg when Neovim starts
vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = SyncDropboxToNeorg
})
-- Autocommand to run SyncNeorgToDropbox when a .norg file is saved
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.norg",
    callback = SyncNeorgToDropbox
})

