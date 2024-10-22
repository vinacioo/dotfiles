return {
	"lervag/vimtex",
	ft = { "tex" },
	config = function()
		-- LaTeX flavor and basic settings
		vim.g.tex_flavor = "latex"
		vim.g.vimtex_compiler_method = "latexmk"
		vim.g.vimtex_fold_enabled = 0
		vim.g.vimtex_quickfix_mode = 0
		vim.g.vimtex_indent_enabled = 0

		-- Zathura as the PDF viewer
		vim.g.vimtex_view_method = "zathura"

		-- Latexmk build directory and output options
		vim.g.vimtex_compiler_latexmk = {
			out_dir = "build/",
			callback = 1,
			continuous = 1,
			executable = "latexmk",
			options = {
				"-pdf",
				"-outdir=build",
				"-shell-escape",
				"-verbose",
				"-file-line-error",
				"-synctex=1",
				"-interaction=nonstopmode",
			},
		}
		vim.g.vimtex_view_general_options = "--synctex-forward @line:@col:@tex build/@pdf" -- for zathura to find the pdf in the build folder

		-- Autocommand for LaTeX files: spell checking, indentation, and highlight settings
		vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "FileType" }, {
			pattern = "tex",
			callback = function()
				-- Set indentation settings
				vim.opt_local.shiftwidth = 2
				vim.opt_local.tabstop = 2

				-- Enable spell checking for Portuguese and English
				vim.opt_local.spell = true
				vim.opt_local.spelllang = { "pt", "en" }

				-- Disable custom indent expression for tex files
				vim.opt_local.indentexpr = ""

				-- Custom highlight for misspelled words
				vim.api.nvim_set_hl(0, "SpellBad", {
					sp = "#ffff00", -- Yellow color for spell check highlight
					underline = true,
				})
			end,
		})
	end,
}
