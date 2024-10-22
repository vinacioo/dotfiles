return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		-- { "hrsh7th/nvim-cmp" },
		-- { "onsails/lspkind.nvim" }, -- Icons
		-- { "hrsh7th/cmp-nvim-lsp" },
		-- { "hrsh7th/cmp-buffer" },
		-- { "hrsh7th/cmp-path" },
		-- { "hrsh7th/cmp-cmdline" },
		-- { "saadparwaiz1/cmp_luasnip" },
		-- {
		-- 	"L3MON4D3/LuaSnip",
		-- 	dependencies = {
		-- 		"rafamadriz/friendly-snippets",
		-- 	},
		-- },
		-- { "folke/neodev.nvim" },
		{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
	},
	config = function()
		-- local cmp = require("cmp")
		-- local cmp_lsp = require("cmp_nvim_lsp")
		-- require("neodev").setup({ -- Before lspconfig
		-- 	override = function(_, library)
		-- 		library.enabled = true
		-- 		library.plugins = true
		-- 	end,
		-- })

		-- local ls = require("luasnip")
		-- local ls_vs_loader = require("luasnip.loaders.from_vscode")
		-- ls_vs_loader.lazy_load()
		-- ls_vs_loader.lazy_load({ paths = { "./lua/marcus/snippets" } })

		-- local cmp_select = { behavior = cmp.SelectBehavior.Select }
		-- cmp.setup({
		-- 	mapping = cmp.mapping.preset.insert({
		-- 		["<S-Tab>"] = cmp.mapping.select_prev_item(cmp_select),
		-- 		["<Tab>"] = cmp.mapping.select_next_item(cmp_select),
		-- 		["<CR>"] = cmp.mapping.confirm({ select = true }),
		-- 		["<C-Space>"] = cmp.mapping.complete(),
		-- 	}),
		-- 	---@diagnostic disable-next-line: missing-fields
		-- 	formatting = {
		-- 		format = require("lspkind").cmp_format({ with_text = true, maxwidth = 50 }),
		-- 	},
		-- 	window = {
		-- 		completion = cmp.config.window.bordered(),
		-- 	},
		-- 	snippet = {
		-- 		expand = function(args)
		-- 			ls.lsp_expand(args.body)
		-- 		end,
		-- 	},
		-- 	sources = {
		-- 		{ name = "nvim_lsp" },
		-- 		{ name = "luasnip" },
		-- 		{ name = "path" },
		-- 		{ name = "buffer" },
		-- 		{ name = "cmdline" },
		-- 	},
		-- })

		-- Setup keybindings
		vim.keymap.set("n", "<leader>lq", "<Cmd>LspInfo<CR>", { noremap = true, desc = "LSP info" })
		vim.keymap.set("n", "<leader>lr", "<Cmd>LspRestart<CR>", { noremap = true, desc = "LSP restart" })
		vim.keymap.set("n", "<leader>ls", "<Cmd>LspStop<CR>", { noremap = true, desc = "LSP stop" })
		vim.keymap.set("n", "<leader>ll", "<Cmd>LspLog<CR>", { noremap = true, desc = "LSP log" })
		vim.keymap.set("n", "<leader>li", "<Cmd>LspInstall<CR>", { noremap = true, desc = "LSP install" })
		vim.keymap.set("n", "<leader>lU", "<Cmd>LspUninstall<CR>", { noremap = true, desc = "LSP uninstall" })
		vim.keymap.set("n", "<leader>lti", "<Cmd>MasonToolsInstall<CR>", { noremap = true, desc = "LSP install" })
		vim.keymap.set("n", "<leader>ltc", "<Cmd>MasonToolsClean<CR>", { noremap = true, desc = "LSP clean" })
		vim.keymap.set("n", "<leader>ltu", "<Cmd>MasonToolsUpdate<CR>", { noremap = true, desc = "LSP update" })

		vim.keymap.set("n", "ge", vim.diagnostic.open_float, { noremap = true, desc = "Diagnostic float" })
		vim.keymap.set("n", "[e", vim.diagnostic.goto_next, { noremap = true, desc = "Next" })
		vim.keymap.set("n", "]e", vim.diagnostic.goto_prev, { noremap = true, desc = "Previous" })

		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP keybindings",
			callback = function(event)
				-- local client = vim.lsp.get_client_by_id(event.data.client_id)
				local builtin = require("telescope.builtin")

				local function opts(desc)
					return { buffer = event.buf, noremap = true, desc = desc }
				end

				-- Enable completion triggered by <c-x><c-o>
				-- vim.api.nvim_buf_set_option(event.buf, "omnifunc", "v:lua.vim.lsp.omnifunc")

				vim.keymap.set("n", "gd", builtin.lsp_definitions, opts("Definition"))
				vim.keymap.set("n", "gi", builtin.lsp_implementations, opts("Implementation"))
				vim.keymap.set("n", "gr", builtin.lsp_references, opts("References"))
				vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts("Hover / Quick info"))
				vim.keymap.set("n", "gH", vim.lsp.buf.signature_help, opts("Signature help"))
				vim.keymap.set("n", "gs", builtin.lsp_workspace_symbols, opts("Workspace symbols"))
				vim.keymap.set("n", "<leader>jd", builtin.diagnostics, opts("Diagnostic"))
				vim.keymap.set("n", "<leader>je", function()
					builtin.diagnostics({ severity = vim.diagnostic.severity.ERROR })
				end, opts("Diagnostic (errors)"))
				vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, opts("Code action"))
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename"))
			end,
		})

		require("mason").setup({})

		-- Setup defaults
		-- local capabilities = vim.tbl_deep_extend(
		-- 	"force",
		-- 	{},
		-- 	vim.lsp.protocol.make_client_capabilities()
		-- 	-- cmp_lsp.default_capabilities()
		-- )

		local default_setup = function(server)
			require("lspconfig")[server].setup({
				-- capabilities = capabilities,
			})
		end

		-- UI config
		local signs = {

			{ name = "DiagnosticSignError", text = "" },
			{ name = "DiagnosticSignWarn", text = "" },
			{ name = "DiagnosticSignHint", text = "󰌵" },
			{ name = "DiagnosticSignInfo", text = "" },
		}

		for _, sign in ipairs(signs) do
			vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
		end

		local config = {
			virtual_text = {
				prefix = "",
			},
			signs = {
				active = signs, -- show signs
			},
			update_in_insert = true,
			underline = true,
			severity_sort = true,
			float = {
				focusable = true,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		}

		vim.diagnostic.config(config)

		-- Toogle diagnostics
		DiagnosticsActive = true
		local ToggleDiagnostics = function()
			DiagnosticsActive = not DiagnosticsActive
			if DiagnosticsActive then
				vim.api.nvim_echo({ { "Diagnostics enabled" } }, false, {})
				vim.diagnostic.enable()
			else
				vim.api.nvim_echo({ { "Diagnostics disabled" } }, false, {})
				vim.diagnostic.enable(false)
			end
		end

		vim.keymap.set(
			"n",
			"<leader>td",
			ToggleDiagnostics,
			{ noremap = true, silent = true, desc = "Toggle diagnostics" }
		)

		-- Add border to lsp handlers
		local border = "rounded"
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = border,
		})
		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = border,
		})
		vim.diagnostic.config({
			float = { border = border },
		})

		-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
		local ensure_installed = {
			"bashls", -- bash
			"cssls", -- css
			"dockerls", -- docker
			"eslint",
			"gopls", -- Go
			"html", -- HTML
			"jsonls", -- Json
			"lua_ls", -- Lua
			"marksman", -- Markdown
			-- "pylsp", -- Python
			"pyright", -- Python
			"yamlls", -- yaml
			"debugpy",
			-- "tsserver", -- JavaScript / TypeScript
			"texlab", -- Latex
		}

		local setup_mason_lspconfig = function(lsps)
			require("mason-lspconfig").setup({
				ensure_installed = lsps,
				handlers = {
					default_setup,
				},
			})
		end

		vim.api.nvim_create_user_command("MasonInstallAll", function()
			setup_mason_lspconfig(ensure_installed)
		end, {
			desc = "Install all LSP servers",
		})

		setup_mason_lspconfig({})

		require("mason-tool-installer").setup({
			ensure_installed = {
				"stylua", -- lua
				"cspell", -- Spell Checker
				"isort", -- Python
				"black", -- Python
				"ruff",
				"debugpy",
				"shfmt", -- bash
				"shellcheck",
				"markdownlint", -- Markdown
				"markdownlint-cli2", -- Markdown
				"prettier", -- JavaScript / TypeScript
				"prettierd", -- JavaScript / TypeScript
			},
		})

		require("lspconfig").lua_ls.setup({
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = {
							"vim",
							"require",
						},
					},
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
						},
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})

		require("lspconfig").pyright.setup({
			settings = {
				python = {
					analysis = {
						autoImportCompletions = true,
						typeCheckingMode = "off", -- it was "basic"
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "openFilesOnly", -- it was "workspace"
						stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs/stubs",
					},
					pythonPath = "/home/vinacio/.pyenv/shims/python",
				},
			},
		})

		-- require("lspconfig").pylsp.setup({
		--     settings = {
		--         pylsp = {
		--             plugins = {
		--                 pycodestyle = {
		--                     enabled = true,
		--                     maxLineLength = 100,
		--                 },
		--             },
		--         },
		--     },
		-- })

		-- vim.api.nvim_create_autocmd('BufWritePre', {
		--     desc = 'Format python on write using black',
		--     pattern = '*.py',
		--     group = vim.api.nvim_create_augroup('black_on_save', { clear = true }),
		--     callback = function()
		--         local format_command = { "black", vim.api.nvim_buf_get_name(0) }
		--         vim.fn.jobstart(format_command, {
		--             on_exit = function(_, code, _)
		--                 if code == 0 then
		--                     vim.api.nvim_command('e!')
		--                 end
		--             end,
		--         })
		--     end,
		-- })
	end,
}
