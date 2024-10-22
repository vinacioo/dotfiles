return {
	"jellydn/hurl.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	ft = "hurl",
	opts = {
		-- Show debugging info
		debug = false,
		-- Show notification on run
		show_notification = false,
		-- Show response in popup or split
		mode = "split",
		-- Default formatter
		formatters = {
			json = { "jq" }, -- Make sure you have install jq in your system, e.g: brew install jq
			html = {
				"prettier", -- Make sure you have install prettier in your system, e.g: npm install -g prettier
				"--parser",
				"html",
			},
			xml = {
				"tidy", -- Make sure you have installed tidy in your system, e.g: brew install tidy-html5
				"-xml",
				"-i",
				"-q",
			},
		},
		-- Default mappings for the response popup or split views
		mappings = {
			close = "q", -- Close the response popup or split view
			next_panel = "<C-n>", -- Move to the next response popup window
			prev_panel = "<C-p>", -- Move to the previous response popup window
		},
	},
	keys = {
		-- Run API request
		{ "<leader>A", "<cmd>HurlRunner<CR>", desc = "Run All requests" },
		{ "<leader>a", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request" },
		{ "<leader>te", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
		{ "<leader>tm", "<cmd>HurlToggleMode<CR>", desc = "Hurl Toggle Mode" },
		{ "<leader>tv", "<cmd>HurlVerbose<CR>", desc = "Run Api in verbose mode" },
		-- Run Hurl request in visual mode
		{ "<leader>h", ":HurlRunner<CR>", desc = "Hurl Runner", mode = "v" },
	},
}
-- return {
-- 	"mistweaverco/kulala.nvim", -- HTTP REST-Client Interface
-- 	ft = "http",
-- 	opts = {},
-- 	dependencies = {
-- 		{
-- 			"nvim-treesitter/nvim-treesitter",
-- 			opts = {
-- 				ensure_installed = { "http", "graphql" },
-- 			},
-- 		},
-- 	},
--     -- stylua: ignore
--     keys = {
--       {"<leader>r", "", desc = "+[R]est"},
--       {"<leader>rr", function () require('kulala').run() end, desc = 'Run request'},
--       {"<leader>rR", function () require('kulala').replay() end, desc = 'Replay last request'},
--       {"<leader>r[", function () require('kulala').jump_prev() end, desc = 'Jump to previous'},
--       {"<leader>r]", function () require('kulala').jump_next() end, desc = 'Jump to next'},
--       {"<leader>rv", function () require('kulala').toggle_view() end, desc = 'Toggle view'},
--       {"<leader>r/", function () require('kulala').search() end, desc = 'Search request files'},
--     },
-- }
-- return {
-- 	{
-- 		"vhyrro/luarocks.nvim",
-- 		branch = "go-away-python",
-- 		opts = {
-- 			rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" }, -- Specify LuaRocks packages to install
-- 		},
-- 	},
-- 	{
-- 		"rest-nvim/rest.nvim",
-- 		event = "VeryLazy",
-- 		ft = { "http" },
-- 		dependencies = {
-- 			{
-- 				"luarocks.nvim",
-- 			},
-- 			{
-- 				"folke/which-key.nvim",
-- 				optional = true,
-- 				opts = {
-- 					defaults = {
-- 						["<leader>r"] = { name = "+rest" },
-- 					},
-- 				},
-- 			},
-- 		},
-- 		config = function()
-- 			require("rest-nvim").setup()
-- 			require("telescope").load_extension("rest")
-- 		end,
-- 		keys = {
-- 			{ "<leader>rr", "<cmd>Rest run<cr>", desc = "Run rest http request under cursor" },
-- 			{ "<leader>re", "<cmd>Telescope rest select_env<cr>", desc = "Select environment file for rest testing" },
-- 		},
-- 	},
-- }
