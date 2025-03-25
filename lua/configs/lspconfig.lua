local configs = require("nvchad.configs.lspconfig")

local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require("lspconfig")

-- Existing servers
local servers = { "html", "cssls", "ts_ls", "clangd", "gopls", "gradle_ls", "pyright", "ruff" }

local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
	}
	vim.lsp.buf.execute_command(params)
end

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
		commands = {
			OrganizeImports = {
				organize_imports,
				description = "Organize Imports",
			},
		},
		settings = {
			gopls = {
				completeUnimported = true,
				usePlaceholders = true,
				analyses = {
					unusedparams = true,
				},
			},
		},
	})
	lspconfig.prismals.setup({})
end

-- Emmet Language Server
lspconfig.emmet_language_server.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = {
		"html",
		"css",
		"scss",
		"sass",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"jsx",
		"tsx",
		"astro",
		"vue",
		"svelte",
		"xml",
	},
	init_options = {
		showAbbreviationSuggestions = true,
		showExpandedAbbreviation = "always",
		showSuggestionsAsSnippets = false,
	},
})
