-- ~/.config/nvim/lua/configs/lspconfig.lua
-- Neovim 0.11+: vim.lsp.config / vim.lsp.enable
-- Fallback: require("lspconfig")[server].setup(...) ძველი გარემოებისთვის

local nv = require("nvchad.configs.lspconfig")

local function merged(opts)
	return vim.tbl_deep_extend("force", {
		on_attach = nv.on_attach,
		on_init = nv.on_init,
		capabilities = nv.capabilities,
	}, opts or {})
end

local function setup(server, opts)
	opts = merged(opts)

	if vim.lsp and vim.lsp.config and vim.lsp.enable then
		-- ✅ ახალი გზა (0.11+)
		vim.lsp.config(server, opts)
		vim.lsp.enable(server)
	else
		-- ✅ fallback ძველ nvim-ზე
		local ok, lspconfig = pcall(require, "lspconfig")
		if ok and lspconfig[server] and lspconfig[server].setup then
			lspconfig[server].setup(opts)
		else
			vim.notify("LSP setup failed for " .. server, vim.log.levels.WARN)
		end
	end
end

-- ── TypeScript: Organize Imports user command
local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
	}
	vim.lsp.buf.execute_command(params)
end

vim.api.nvim_create_user_command("OrganizeImports", organize_imports, { desc = "Organize TS/TSX Imports" })

-- ── საერთო სერვერები (შენი ძველი სიის მიხედვით)
local servers = {
	"html", -- html-lsp (vscode-langservers-extracted)
	"cssls", -- css-lsp
	"ts_ls", -- typescript-language-server (ახალი სახელი lspconfig-ში)
	"clangd",
	"gopls",
	"gradle_ls",
	"pyright",
	"ruff",
	"prismals",
}

-- სპეც-პარამეტრები კონკრეტული სერვერებისთვის
local per_server = {
	gopls = {
		settings = {
			gopls = {
				completeUnimported = true,
				usePlaceholders = true,
				analyses = { unusedparams = true },
			},
		},
	},
}

for _, name in ipairs(servers) do
	setup(name, per_server[name])
end

-- ── Emmet Language Server
setup("emmet_language_server", {
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
