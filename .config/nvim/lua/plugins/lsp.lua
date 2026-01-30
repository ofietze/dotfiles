return {
  -- Mason for LSP server management
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- Mason LSP config bridge
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls", -- TypeScript/JavaScript
          "eslint", -- ESLint
          "html", -- HTML
          "cssls", -- CSS
          "jsonls", -- JSON
        },
        automatic_installation = true,
      })
    end,
  },

  -- JSON Schema store
  {
    "b0o/schemastore.nvim",
  },
    }
