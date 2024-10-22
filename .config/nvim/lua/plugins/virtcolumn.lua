return {
	"xiyaowong/virtcolumn.nvim",
	ft = "python",
	config = function()
		vim.g.virtcolumn_char = "▕"
		vim.g.virtcolumn_priority = 10
		vim.opt.colorcolumn = "80"
	end,
}
