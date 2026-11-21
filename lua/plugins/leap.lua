return {
	-- GitHub-ის რეპო ცარიელია ("Moved to Codeberg"), კოდი აქაა:
	url = "https://codeberg.org/andyg/leap.nvim",
	name = "leap.nvim",
	-- ერთადერთი leap-ის spec (init.lua-დან დუბლიკატი ამოღებულია).
	-- lazy = false აუცილებელია: defaults.lazy = true და keymap-ები config-შია.
	lazy = false,
	config = function()
		local leap = require("leap")

		leap.opts.safe_labels = {}

		-- Sneak-style mappings (canonical)
		vim.keymap.set({ "n", "x", "o" }, "s", function()
			leap.leap({ windows = { vim.fn.win_getid() } })
		end)

		vim.keymap.set({ "n", "x", "o" }, "S", function()
			leap.leap({
				windows = vim.tbl_filter(function(win)
					return win ~= vim.fn.win_getid()
				end, vim.api.nvim_list_wins()),
			})
		end)
	end,
}
