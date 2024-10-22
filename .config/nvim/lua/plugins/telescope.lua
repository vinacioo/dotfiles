return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- Fuzzy Finder Algorithm which requires local dependencies to be built.
			-- Only load if `make` is available. Make sure you have the system
			-- requirements installed.
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				-- NOTE: If you are having trouble with this installation,
				--       refer to the README for telescope-fzf-native for more instructions.
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
		},
		keys = {
			{ "<leader>fw", ":Telescope live_grep<CR>", { desc = "telescope live grep" } },
			{ "<leader>fb", ":Telescope buffers<CR>", { desc = "telescope find buffers" } },
			{ "<leader>fh", ":Telescope help_tags<CR>", { desc = "telescope help page" } },
			{ "<leader>fm", ":Telescope marks<CR>", { desc = "telescope find marks" } },
			{ "<leader>fo", ":Telescope oldfiles<CR>", { desc = "telescope find oldfiles" } },
			{ "<leader>fz", ":Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" } },
			{ "<leader>cm", ":Telescope git_commits<CR>", { desc = "telescope git commits" } },
			{ "<leader>tk", ":Telescope keymaps<CR>", { desc = "telescope keymaps" } },
			{ "<leader>tr", ":Telescope resume<CR>", { desc = "telescope resume" } },
			{ "<leader>th", ":Telescope themes<CR>", { desc = "telescope themes" } },
			{ "<leader>ff", ":Telescope find_files<CR>", { desc = "telescope find files" } },
			{
				"<leader>fa",
				":Telescope find_files follow=true no_ignore=true hidden=true<CR>",
				{ desc = "telescope find all files" },
			},
		},
		config = function()
			local builtin = require("telescope.builtin")
			require("telescope").setup({
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
			require("telescope").load_extension("fzf")
			vim.keymap.set("n", "<leader>jc", function()
				builtin.colorscheme({ enable_preview = true })
			end, { desc = "Colorschemes" })
		end,
	},
}
