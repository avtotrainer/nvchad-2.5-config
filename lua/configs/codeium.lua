-- lua/configs/codeium.lua
-- Codeium/Windsurf configuration (Nix-friendly paths)

local M = {}

M.setup = function()
	local ok, codeium = pcall(require, "codeium")
	if not ok then
		return
	end

	local state = vim.fn.stdpath("state")
	local data = vim.fn.stdpath("data")

	-- NixOS-ზე ხშირად საჭიროა wrapper (FHS) downloaded server-ის გასაშვებად.
	-- თუ გაქვს steam-run, გამოვიყენოთ ავტომატურად.
	local steam_run = vim.fn.exepath("steam-run")
	if steam_run == "" then
		steam_run = nil
	end

	local is_wsl = (vim.env.WSL_DISTRO_NAME ~= nil)

	codeium.setup({
		-- Read-only ~/.config/nvim-ის გვერდის ავლა: token აქ შეინახება (წერადია)
		config_path = state .. "/codeium.json",

		-- Server download directory (writeable)
		bin_path = data .. "/codeium",

		-- Wrapper — სასარგებლოა NixOS-ზე (თუ steam-run არსებობს)
		wrapper = steam_run,

		-- WSL-ზე chat-ს browser opener ხშირად უსარგებლოა; completion მაინც იმუშავებს.
		enable_chat = not is_wsl,
	})
end

return M
