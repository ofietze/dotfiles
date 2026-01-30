return {
  -- Flash.nvim for enhanced movement and search
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- Leap.nvim for quick navigation
  {
    url = "https://codeberg.org/andyg/leap.nvim",
    config = function()
      require('leap').add_default_mappings()
    end
  },

  -- vim-hardtime to discourage bad habits
  {
    "takac/vim-hardtime",
    config = function()
      vim.g.hardtime_default_on = 1
      vim.g.hardtime_showmsg = 1
      vim.g.hardtime_allow_different_key = 1
    end
  },
}
