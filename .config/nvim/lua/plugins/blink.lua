return {
	"Saghen/blink.cmp",
	event = "VeryLazy",
	version = "v0.*",
	dependencies = { "rafamadriz/friendly-snippets" },
	opts = {
		highlight = { use_nvim_cmp_as_default = true },
		trigger = { signature_help = { enabled = true } },
		keymap = {
			accept = "<Cr>",
			select_prev = { "<S-Tab>", "<Up>", "<C-j>" },
			select_next = { "<Tab>", "<Down>", "<C-k>" },
		},
	},
}
