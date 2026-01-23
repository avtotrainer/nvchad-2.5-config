-- lua/plugins/codeium.lua
-- Windsurf (Codeium) integration for NvChad (lazy.nvim)
-- Nix-friendly: actual config writes to stdpath("state") (see lua/configs/codeium.lua)

local function has_source(sources, name)
	for _, src in ipairs(sources or {}) do
		if src.name == name then
			return true
		end
	end
	return false
end

return {
	{
		"Exafunction/windsurf.nvim",
		event = "InsertEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("configs.codeium").setup()
		end,
	},

	-- Ensure Codeium is present in cmp sources (NvChad controls the list)
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			opts.sources = opts.sources or {}

			if not has_source(opts.sources, "codeium") then
				table.insert(opts.sources, 1, { name = "codeium" })
			end

			return opts
		end,
	},
}
