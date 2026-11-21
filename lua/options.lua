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
vim.opt.clipboard = "unnamedplus"

local is_windows = vim.fn.has("win32") == 1

if is_windows then
	-- Windows: clipboard-ს Neovim თავად აგვარებს (win32yank / ჩაშენებული provider)

	-- ტერმინალი და :! ბრძანებები PowerShell-ით (იხ. :h shell-powershell)
	vim.o.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
	vim.o.shellcmdflag =
		"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';Remove-Alias -Force -ErrorAction SilentlyContinue tee;"
	vim.o.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
	vim.o.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
	vim.o.shellquote = ""
	vim.o.shellxquote = ""
else
	-- Wayland clipboard provider (NixOS)
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
end
