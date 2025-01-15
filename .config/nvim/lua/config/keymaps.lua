-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- Change NeoTree's root to the current file's directory
map("n", "<leader>h", function()
  -- Get the directory of the current file
  local file_dir = vim.fn.expand("%:p:h")
  -- Change Neovim's local working directory to the file's directory
  vim.cmd("lcd " .. file_dir)
  -- Print the current working directory (optional)
  vim.cmd("pwd")
  -- Update neo-tree to show the new root directory
  require("neo-tree.command").execute({ action = "focus", dir = file_dir })
end, { desc = "Change NeoTree root to current file's directory" })

map("n", "<leader>lw", "<cmd>set wrap!<CR>", { desc = "Toogle wrap" })

-- Change word with Ctrl-C
map("n", "<C-c>", "ciw")

map("n", "<leader><leader>/", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer]" })

-- Colorscheme
map("n", "<leader>uCC", "<cmd>Telescope themes<CR>", { desc = "Telescope Nvchad themes" })

-- Colorscheme with theme picker
map("n", "<leader>uCP", function()
  require("nvchad.themes").open({ style = "flat" })
end, { desc = "Open theme picker" })
