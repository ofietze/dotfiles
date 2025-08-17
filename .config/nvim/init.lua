-- Basic Neovim configuration with sensible defaults

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Show relative line numbers
vim.opt.mouse = "a"            -- Enable mouse support
vim.opt.ignorecase = true      -- Case insensitive searching
vim.opt.smartcase = true       -- Case sensitive if uppercase present
vim.opt.hlsearch = false       -- Don't highlight search results
vim.opt.wrap = false           -- Don't wrap lines
vim.opt.breakindent = true     -- Enable break indent
vim.opt.undofile = true        -- Save undo history
vim.opt.signcolumn = "yes"     -- Always show sign column
vim.opt.updatetime = 250       -- Decrease update time
vim.opt.timeoutlen = 300       -- Decrease timeout for key sequences
vim.opt.completeopt = "menuone,noselect"  -- Better completion experience
vim.opt.termguicolors = true   -- Enable 24-bit RGB colors

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Split windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup("plugins", {
  change_detection = {
    notify = false,
  },
})

-- Basic keymaps for learning vim movements
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Movement practice helpers
vim.keymap.set("n", "<leader>h", "<cmd>echo 'Use h to move left'<cr>", { desc = "Hint: h for left" })
vim.keymap.set("n", "<leader>j", "<cmd>echo 'Use j to move down'<cr>", { desc = "Hint: j for down" })
vim.keymap.set("n", "<leader>k", "<cmd>echo 'Use k to move up'<cr>", { desc = "Hint: k for up" })
vim.keymap.set("n", "<leader>l", "<cmd>echo 'Use l to move right'<cr>", { desc = "Hint: l for right" })