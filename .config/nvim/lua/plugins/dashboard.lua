local header = {
	"                                                       ",
	"                                                       ",
	"                                                       ",
	" ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
	" ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
	" ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
	" ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
	" ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
	" ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
	"                                                       ",
	"                                                       ",
}

local center = {
	{
		desc = "New File ",
		key = "n",
		icon = " ",
		action = "enew",
		group = "Include",
	},
	{
		icon_hl = "@variable",
		desc = "Recent Files",
		group = "Function",
		action = "Telescope oldfiles",
		key = "r",
		icon = " ",
	},
	{
		desc = " Restore Session",
		key = "s",
		icon = " ",
		action = 'lua require("persistence").load()',
		group = "Function",
	},
	{
		desc = "Lazy ",
		key = "l",
		icon = "󰒲 ",
		action = "Lazy",
		group = "Define",
	},
	{
		desc = "Config ",
		key = "c",
		icon = " ",
		action = "e $MYVIMRC",
		group = "Constant",
	},
	{
		desc = "Exit ",
		key = "q",
		icon = " ",
		action = "exit",
		group = "Special",
	},
}

local version = vim.version()

local footer = {
	"",
	"Neovim " .. version.major .. "." .. version.minor,
}

return {
	"nvimdev/dashboard-nvim",
	opts = {
		theme = "hyper",
		config = {
			header = header,
			shortcut = center,
			footer = footer,
			packages = { enable = true },
		},
	},
}

-- return {
--   "nvimdev/dashboard-nvim",
--   event = "VimEnter",
--   config = function()
--     require("dashboard").setup({
--       -- config
--       header = header,
--       footer = footer,
--       shortcut = center,
--     })
--   end,
--   dependencies = { { "nvim-tree/nvim-web-devicons" } },
-- }
-- return {
-- 	"nvimdev/dashboard-nvim",
-- 	event = "VimEnter",
-- 	dependencies = {
-- 		"nvim-tree/nvim-web-devicons",
-- 		"ahmedkhalf/project.nvim",
-- 	},
-- 	config = function()
-- 		require("dashboard").setup({
-- 			theme = "hyper",
-- 			disable_move = false,
-- 			shuffle_letter = false,
-- 			packages = { enable = false },
-- 			config = {
-- 				week_header = {
-- 					enable = false,
-- 				},
-- 				shortcut = {
-- 					{
-- 						desc = "Recent Files",
-- 						group = "@property",
-- 						action = "Telescope oldfiles",
-- 						key = "r",
-- 						icon = "󰒲 ",
-- 					},
-- 					{
-- 						icon_hl = "@variable",
-- 						desc = "Files",
-- 						group = "@character.special",
-- 						action = "Telescope find_files",
-- 						key = "f",
-- 						icon = " ",
-- 					},
-- 					{
-- 						desc = "Last session",
-- 						group = "@property",
-- 						action = 'lua require("persistence").load()',
-- 						key = "s",
-- 						icon = "♻️  ",
-- 					},
-- 					{
-- 						desc = "Projects",
-- 						group = "@character.special",
-- 						action = "Telescope projects",
-- 						key = "p",
-- 						icon = " ",
-- 					},
-- 					{
-- 						desc = "Config",
-- 						group = "Number",
-- 						action = function()
-- 							vim.cmd("cd " .. vim.fn.stdpath("config"))
-- 							require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
-- 						end,
-- 						key = "c",
-- 						icon = " ",
-- 					},
-- 					{
-- 						action = "qa",
-- 						desc = "Quit",
-- 						icon = " ",
-- 						group = "Error",
-- 						key = "q",
-- 					},
-- 				},
-- 				footer = function()
-- 					-- local currentConfig = "" .. os.getenv("MYVIMRC")
-- 					local nvimVersion = string.format(
-- 						"Using Neovim v%d.%d.%d",
-- 						vim.version().major,
-- 						vim.version().minor,
-- 						vim.version().patch
-- 					)
--
-- 					return { "", nvimVersion, "" }
-- 				end,
-- 			},
-- 		})
-- 	end,
-- }
