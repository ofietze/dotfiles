return {
  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })
      vim.keymap.set("n", "<leader>ef", "<cmd>Neotree focus<cr>", { desc = "Focus file explorer" })
      vim.keymap.set("n", "<leader>ec", "<cmd>Neotree close<cr>", { desc = "Close file explorer" })
      
      -- File explorer tips
      vim.keymap.set("n", "<leader>te", function()
        vim.notify([[
File Explorer Navigation Tips:
• <leader>e - Toggle Neo-tree
• <leader>ef - Focus Neo-tree
• <leader>ec - Close Neo-tree

In Neo-tree:
• Enter/o - Open file/folder
• a - Add file/folder
• d - Delete
• r - Rename
• c - Copy
• x - Cut
• p - Paste
• R - Refresh
• H - Toggle hidden files
• / - Filter/search
• q - Close Neo-tree
]], vim.log.levels.INFO, { title = "File Explorer Tips" })
      end, { desc = "Show file explorer tips" })
    end
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight"
        }
      })
    end
  },

  -- Which-key for learning keybindings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {}
  },
}