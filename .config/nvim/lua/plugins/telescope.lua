return {
  -- Telescope for fuzzy finding
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    dependencies = { 
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      
      -- Setup telescope with enhanced configuration
      telescope.setup({
        defaults = {
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            ".DS_Store",
            "*.jpg",
            "*.jpeg",
            "*.png",
            "*.svg",
            "*.otf",
            "*.ttf",
            "target/",
            "build/",
            "dist/",
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git/",
          },
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          sorting_strategy = "ascending",
          prompt_prefix = " ",
          selection_caret = " ",
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
          live_grep = {
            additional_args = function()
              return { "--hidden", "--glob", "!**/.git/*" }
            end,
          },
          grep_string = {
            additional_args = function()
              return { "--hidden", "--glob", "!**/.git/*" }
            end,
          },
        },
      })
      
      -- Load fzf extension for better performance
      pcall(telescope.load_extension, "fzf")
      
      -- Enhanced keymaps
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
      
      -- Additional useful search commands
      vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Find word under cursor" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Find recent files" })
      vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Find commands" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })
      vim.keymap.set("n", "<leader>fs", builtin.git_status, { desc = "Find git status" })
      vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Find diagnostics" })
      
      -- Search in current buffer
      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find({
          winblend = 10,
          previewer = false,
        })
      end, { desc = "Search in current buffer" })
      
      -- Search with visual selection
      vim.keymap.set("v", "<leader>fg", function()
        local function get_visual_selection()
          vim.cmd('noau normal! "vy"')
          local text = vim.fn.getreg('v')
          vim.fn.setreg('v', {})
          text = string.gsub(text, "\n", "")
          if #text > 0 then
            return text
          else
            return ''
          end
        end
        
        local text = get_visual_selection()
        builtin.live_grep({ default_text = text })
      end, { desc = "Grep selection" })
    end
  },
}