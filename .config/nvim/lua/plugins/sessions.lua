return {
	{
		"rmagatti/auto-session",
		config = function()
			require("auto-session").setup({
				log_level = "error",
				auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
				auto_restore_enabled = false,
				auto_session_enable_last_session = false,
				auto_session_use_git_branch = false,
				auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
				session_lens = {
					buftypes_to_ignore = {}, -- list of buffer types what should not be deleted from current session
					load_on_setup = true,
					theme_conf = { border = true },
					previewer = false,
				},
			})
		end,
		keys = {
			{
				"<Leader>S",
				function()
					require("auto-session.session-lens").search_session()
				end,
				desc = "Search sessions",
				noremap = true,
			},
		},
	},
	{
		"olimorris/persisted.nvim",
		opts = {
			save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
			use_git_branch = true,
			autosave = true,
			should_autosave = function()
				if vim.bo.filetype == "dashboard" then
					return false
				end
				return true
			end,
		},
		keys = {
			{ "<leader>ss", "<cmd>SessionSave<cr>", desc = "persisted Save session" },
			{ "<leader>sl", "<cmd>SessionLoad<cr>", desc = "persisted Load session" },
			{ "<leader>sd", "<cmd>SessionDelete<cr>", desc = "persisted Delete session" },
			{ "<leader>sf", "<cmd>Telescope persisted<cr>", desc = "persisted Find session" },
		},
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		opts = {
			-- add any custom options here
		},
	},
}
