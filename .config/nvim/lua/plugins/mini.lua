return {
	-- bufremove
	{
		"echasnovski/mini.bufremove",
		keys = {
			{
				"<leader>q",
				function()
					require("mini.bufremove").delete(0, false)
				end,
				desc = "Delete Buffer",
			},
			{
				"<leader>bD",
				function()
					require("mini.bufremove").delete(0, true)
				end,
				desc = "Delete Buffer (Force)",
			},
		},
	},

	-- {
	-- 	"echasnovski/mini.bufremove",
	-- 	keys = {
	-- 		{
	-- 			"<leader>bd",
	-- 			function()
	-- 				local bd = require("mini.bufremove").delete
	-- 				if vim.bo.modified then
	-- 					local choice =
	-- 						vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
	-- 					if choice == 1 then -- Yes
	-- 						vim.cmd.write()
	-- 						bd(0)
	-- 					elseif choice == 2 then -- No
	-- 						bd(0, true)
	-- 					end
	-- 				else
	-- 					bd(0)
	-- 				end
	-- 			end,
	-- 			desc = "Delete Buffer",
	-- 		},
	--      -- stylua: ignore
	--      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
	-- 	},
	-- },
	-- indent scope
	{
		"echasnovski/mini.indentscope",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			symbol = "│",
			options = { try_as_border = true },
		},
		config = function(_, opts)
			require("mini.indentscope").setup(opts)
			vim.api.nvim_create_autocmd("FileType", {
	     -- stylua: ignore
	     pattern = { 'help', 'alpha', 'dashboard', 'NvimTree', 'Trouble', 'lazy', 'mason' },
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
			vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#30343a" })
		end,
	},
	-- pairs
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		opts = {
			modes = { insert = true, command = true, terminal = false },
		},
	},
	{
		"echasnovski/mini.icons",
		opts = function(_, opts)
			if vim.g.icons_enabled == false then
				opts.style = "ascii"
			end
		end,
		lazy = true,
		specs = {
			{ "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},
}
-- 		-- Auto highlight text under cursor
-- 		require("mini.cursorword").setup({})
--
-- 		require("mini.bufremove").setup({
-- 			config = function()
-- 				vim.keymap.set("n", "<leader>bd", ":lua require('mini.bufremove').delete(0, false)<CR>")
-- 			end,
-- 		})
-- 		local hipatterns = require("mini.hipatterns")
-- 		hipatterns.setup({
-- 			highlighters = {
-- 				fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
-- 				bug = { pattern = "%f[%w]()BUG()%f[%W]", group = "MiniHipatternsFixme" },
-- 				hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
-- 				todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
-- 				note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
--
-- 				hex_color = hipatterns.gen_highlighter.hex_color(),
-- 			},
-- 		})
--
-- 		require("mini.align").setup({
-- 			mappings = {
-- 				start = "<leader>ra",
-- 				start_with_preview = "<leader>rA",
-- 			},
-- 		})
--
-- 		-- Extend a/i text objects
-- 		require("mini.ai").setup({})
-- 	end,
-- 	init = function()
-- 		vim.api.nvim_create_autocmd("FileType", {
-- 			pattern = {
-- 				"help",
-- 				"alpha",
-- 				"dashboard",
-- 				"neo-tree",
-- 				"NvimTree",
-- 				"Trouble",
-- 				"trouble",
-- 				"lazy",
-- 				"mason",
-- 				"notify",
-- 				"toggleterm",
-- 				"lazyterm",
-- 			},
-- 			callback = function()
-- 				vim.b.miniindentscope_disable = true
-- 			end,
-- 		})
-- 	end,
-- }
