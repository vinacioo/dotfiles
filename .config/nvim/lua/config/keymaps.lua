local map = vim.keymap.set

-- Delete without yanking and stay in normal mode
map("n", "c", '"_d', { desc = "Delete without copy", silent = true })
map("n", "C", '"_D', { desc = "Delete line without copy", silent = true })
map("v", "c", '"_d', { desc = "Delete without copy", silent = true })

-- Change word with Ctrl-C
map("n", "<C-c>", "ciw")

-- Copy whole text to clipboard
map("n", "<C-a>", ":%y+<CR>", { desc = "Copy whole text to clipboard", silent = true })

-- Json format
map("n", "<leader>js", "<cmd>silent %!jq .<cr>", { desc = "Json format", silent = true })

--change root
map("n", "<leader>h", "<cmd>lcd %:p:h<cr><cmd>pwd<cr>", { desc = "change root" })

-- Copy text between quotes to clipboard
map("n", "<C-]>", function()
  vim.cmd('normal! yi"')
  vim.fn.setreg("+", vim.fn.getreg('"'))
end, { desc = "Copy text between quotes to clipboard", silent = true })
