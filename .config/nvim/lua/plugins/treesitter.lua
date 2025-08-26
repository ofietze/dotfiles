return {
  -- Treesitter for syntax highlighting and more
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Languages to install
        ensure_installed = {
          "javascript",
          "typescript",
          "tsx",
          "json",
          "html",
          "css",
          "scss",
          "lua",
          "vim",
          "vimdoc",
          "bash",
          "markdown",
          "markdown_inline",
          "regex",
          "yaml",
          "toml",
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        -- Highlight configuration
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        -- Indentation based on treesitter
        indent = {
          enable = true,
        },

        -- Incremental selection
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = "<C-s>",
            node_decremental = "<C-backspace>",
          },
        },

        -- Text objects
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              -- Function selections
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              -- Class selections
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              -- Parameter selections
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              -- Conditional selections
              ["ai"] = "@conditional.outer",
              ["ii"] = "@conditional.inner",
              -- Loop selections
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]a"] = "@parameter.inner",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
              ["]A"] = "@parameter.inner",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[a"] = "@parameter.inner",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
              ["[A"] = "@parameter.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>sn"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>sp"] = "@parameter.inner",
            },
          },
        },

        -- Folding
        fold = {
          enable = true,
        },
      })

      -- Set foldmethod to use treesitter
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = false -- Don't fold by default
    end,
  },

  -- Text objects for treesitter
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}