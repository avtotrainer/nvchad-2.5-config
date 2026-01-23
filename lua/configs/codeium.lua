-- lua/configs/codeium.lua
-- Nix-friendly Codeium/Windsurf setup:
--  - store API key/config under stdpath("state") (writable)
--  - store downloaded server under stdpath("state") (writable)
--  - optional wrapper for NixOS (steam-run) if the server needs FHS libs

local M = {}

function M.setup()
	local state = vim.fn.stdpath("state")
	local dir = state .. "/codeium"
	local bin = dir .. "/bin"
	local cfg = dir .. "/config.json"

	-- Ensure directories exist (works even if already there)
	vim.fn.mkdir(bin, "p")

	require("codeium").setup({
		-- The file that stores your API token
		config_path = cfg,

		-- Where the Windsurf/Codeium server binary will be downloaded
		bin_path = bin,

		-- Keep cmp source enabled (default true, but explicit is safer)
		enable_cmp_source = true,

		-- NixOS helper: run downloaded binaries in an FHS-like env
		-- Comment this out if you don't need it.
		wrapper = "steam-run",
	})
end

return M
