-- ~/.config/nvim/lua/configs/lspconfig.lua
-- Neovim 0.11+ native LSP config
-- NVChad-compatible, NixOS-friendly

local nv = require("nvchad.configs.lspconfig")

-- ─────────────────────────────────────────────────────────────
-- Capabilities
-- UTF-8 position encoding აუცილებელია pyright + ruff ერთად
-- ─────────────────────────────────────────────────────────────
local capabilities = vim.tbl_deep_extend("force", nv.capabilities, {
	general = {
		positionEncodings = { "utf-8" },
	},
})

local function merged(opts)
	return vim.tbl_deep_extend("force", {
		on_attach = nv.on_attach,
		on_init = nv.on_init,
		capabilities = capabilities,
	}, opts or {})
end

local function setup(server, opts)
	opts = merged(opts)

	if vim.lsp and vim.lsp.config and vim.lsp.enable then
		-- Neovim 0.11+
		vim.lsp.config(server, opts)
		vim.lsp.enable(server)
	else
		-- Fallback (ძველი nvim-ისთვის)
		local ok, lspconfig = pcall(require, "lspconfig")
		if ok and lspconfig[server] and lspconfig[server].setup then
			lspconfig[server].setup(opts)
		else
			vim.notify("LSP setup failed for " .. server, vim.log.levels.WARN)
		end
	end
end

-- ─────────────────────────────────────────────────────────────
-- TypeScript helper
-- ─────────────────────────────────────────────────────────────
vim.api.nvim_create_user_command("OrganizeImports", function()
	vim.lsp.buf.execute_command({
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
	})
end, { desc = "Organize TS/TSX Imports" })

-- ─────────────────────────────────────────────────────────────
-- Server list (მხოლოდ რეალურად საჭიროები)
-- ─────────────────────────────────────────────────────────────
local servers = {
	"pyright",
	"ruff",

	-- Web (იშვიათი გამოყენება)
	"ts_ls",
	"html",
	"cssls",

	-- სხვა (დატოვებულია, მაგრამ არ აზიანებს)
	"clangd",
	"gopls",
}

-- ─────────────────────────────────────────────────────────────
-- Per-server configuration
-- ─────────────────────────────────────────────────────────────
local per_server = {
	-- 🐍 Pyright: types, definition, hover
	pyright = {
		filetypes = { "python" },
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = "openFilesOnly",
					useLibraryCodeForTypes = true,
					-- ეს ჩავამატე, როცა ცხად იმპორტზე უაზროდ აყვირდა
					reportMissingImports = false,
					reportMissingModuleSource = false,
					--
					typeCheckingMode = "basic",
				},
			},
		},
	},

	-- 🐍 Ruff: diagnostics + code actions
	-- hover / formatting გამორთულია, რომ pyright-ს არ შეეჯახოს
	ruff = {
		filetypes = { "python" },
		on_attach = function(client, bufnr)
			client.server_capabilities.hoverProvider = false
			client.server_capabilities.documentFormattingProvider = false
			nv.on_attach(client, bufnr)
		end,
	},

	-- 🌐 TypeScript
	ts_ls = {
		filetypes = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
	},

	html = { filetypes = { "html" } },
	cssls = { filetypes = { "css", "scss", "sass" } },

	-- 🐹 Go (თუ გახსნი ფაილს, იმუშავებს)
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
