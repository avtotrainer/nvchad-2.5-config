require("nvchad.options")
-- Diagnostic UI (Neovim 0.11+ compatible, no sign_define)
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = " ",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})
-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
--
-- Wayland clipboard provider (NixOS)
vim.opt.clipboard = "unnamedplus"

vim.g.clipboard = {
	name = "wl-clipboard",
	copy = {
		["+"] = "wl-copy",
		["*"] = "wl-copy",
	},
	paste = {
		["+"] = "wl-paste",
		["*"] = "wl-paste",
	},
	cache_enabled = 0,
}
