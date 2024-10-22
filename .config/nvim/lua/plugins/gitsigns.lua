return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
			delay = 1000,
			ignore_whitespace = false,
			virt_text_priority = 100,
		},
		on_attach = function(_)
			local gs = package.loaded.gitsigns
			local function opts(desc)
				return { noremap = true, silent = true, desc = desc }
			end
			vim.keymap.set("n", "<leader>gp", gs.preview_hunk, opts("Preview hunk"))
			vim.keymap.set("n", "<leader>gr", gs.reset_hunk, opts("Reset hunk"))
			vim.keymap.set("n", "<leader>gs", gs.stage_hunk, opts("Stage hunk"))
			vim.keymap.set("n", "<leader>gb", function()
				gs.blame_line({ full = true })
			end, opts("Blame line"))
			vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, opts("Undo stage hunk"))
			vim.keymap.set("n", "<leader>gD", gs.toggle_deleted, opts("Toggle deleted"))
		end,
	},
}
