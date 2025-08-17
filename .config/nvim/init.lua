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

-- Window splitting and navigation
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Window resizing
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Tips display functions
vim.keymap.set("n", "<leader>ts", function()
  vim.notify([[
Window Splitting Tips:
• <leader>sv - Split vertically (side by side)
• <leader>sh - Split horizontally (top/bottom)
• <leader>se - Make all splits equal size
• <leader>sx - Close current split
• <C-w>o - Close all other windows (keep current)
]], vim.log.levels.INFO, { title = "Splitting Tips" })
end, { desc = "Show splitting tips" })

vim.keymap.set("n", "<leader>tn", function()
  vim.notify([[
Window Navigation Tips:
• <C-h/j/k/l> - Move between windows (like vim motions)
• <C-w>w - Cycle through windows
• <C-w>p - Go to previous window
• <C-w>r - Rotate windows downward/rightward
• <C-w>R - Rotate windows upward/leftward
• <C-w>x - Exchange current window with next one
]], vim.log.levels.INFO, { title = "Navigation Tips" })
end, { desc = "Show navigation tips" })

vim.keymap.set("n", "<leader>tr", function()
  vim.notify([[
Window Resizing Tips:
• <C-Up/Down> - Resize height
• <C-Left/Right> - Resize width
• <C-w>+ - Increase height by 1
• <C-w>- - Decrease height by 1
• <C-w>> - Increase width by 1
• <C-w>< - Decrease width by 1
]], vim.log.levels.INFO, { title = "Resizing Tips" })
end, { desc = "Show resizing tips" })