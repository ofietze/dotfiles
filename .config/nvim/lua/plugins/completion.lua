return {
  -- Autocompletion engine
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP completion source
      "hrsh7th/cmp-buffer", -- Buffer completion source
      "hrsh7th/cmp-path", -- Path completion source
      "hrsh7th/cmp-cmdline", -- Command line completion
      "saadparwaiz1/cmp_luasnip", -- Snippet completion source
      "L3MON4D3/LuaSnip", -- Snippet engine
      "rafamadriz/friendly-snippets", -- Collection of snippets
      "onsails/lspkind.nvim", -- VS Code-like icons
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- Load snippets from friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Custom snippet for JavaScript/TypeScript
      luasnip.add_snippets("javascript", {
        luasnip.snippet("cl", {
          luasnip.text_node("console.log("),
          luasnip.insert_node(1),
          luasnip.text_node(");"),
        }),
        luasnip.snippet("fn", {
          luasnip.text_node("function "),
          luasnip.insert_node(1, "name"),
          luasnip.text_node("("),
          luasnip.insert_node(2),
          luasnip.text_node(") {"),
          luasnip.text_node({ "", "  " }),
          luasnip.insert_node(0),
          luasnip.text_node({ "", "}" }),
        }),
        luasnip.snippet("af", {
          luasnip.text_node("const "),
          luasnip.insert_node(1, "name"),
          luasnip.text_node(" = ("),
          luasnip.insert_node(2),
          luasnip.text_node(") => {"),
          luasnip.text_node({ "", "  " }),
          luasnip.insert_node(0),
          luasnip.text_node({ "", "};" }),
        }),
      })

      luasnip.add_snippets("typescript", {
        luasnip.snippet("cl", {
          luasnip.text_node("console.log("),
          luasnip.insert_node(1),
          luasnip.text_node(");"),
        }),
        luasnip.snippet("fn", {
          luasnip.text_node("function "),
          luasnip.insert_node(1, "name"),
          luasnip.text_node("("),
          luasnip.insert_node(2),
          luasnip.text_node("): "),
          luasnip.insert_node(3, "void"),
          luasnip.text_node(" {"),
          luasnip.text_node({ "", "  " }),
          luasnip.insert_node(0),
          luasnip.text_node({ "", "}" }),
        }),
        luasnip.snippet("af", {
          luasnip.text_node("const "),
          luasnip.insert_node(1, "name"),
          luasnip.text_node(" = ("),
          luasnip.insert_node(2),
          luasnip.text_node("): "),
          luasnip.insert_node(3, "void"),
          luasnip.text_node(" => {"),
          luasnip.text_node({ "", "  " }),
          luasnip.insert_node(0),
          luasnip.text_node({ "", "};" }),
        }),
        luasnip.snippet("int", {
          luasnip.text_node("interface "),
          luasnip.insert_node(1, "Name"),
          luasnip.text_node(" {"),
          luasnip.text_node({ "", "  " }),
          luasnip.insert_node(0),
          luasnip.text_node({ "", "}" }),
        }),
        luasnip.snippet("type", {
          luasnip.text_node("type "),
          luasnip.insert_node(1, "Name"),
          luasnip.text_node(" = "),
          luasnip.insert_node(0),
          luasnip.text_node(";"),
        }),
      })

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered({
            winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            winhighlight = "Normal:CmpDoc",
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            before = function(entry, vim_item)
              -- Show source name
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
              })[entry.source.name]
              return vim_item
            end,
          }),
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
      })

      -- Command line completion
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      -- Set up completion highlight groups
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    end,
  },

  -- Snippet engine
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    config = function()
      local luasnip = require("luasnip")
      
      -- Enable autotrigger
      luasnip.config.setup({
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
      })

      -- Keymaps for snippets
      vim.keymap.set({ "i", "s" }, "<C-l>", function()
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end, { desc = "Change snippet choice" })

      vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/plugins/completion.lua<CR>", { desc = "Reload snippets" })
    end,
  },

  -- VS Code-like icons for completion
  {
    "onsails/lspkind.nvim",
    opts = {
      symbol_map = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
      },
    },
  },

  -- Collection of useful snippets
  {
    "rafamadriz/friendly-snippets",
  },
}