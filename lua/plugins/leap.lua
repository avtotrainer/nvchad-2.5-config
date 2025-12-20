return {
	"ggandor/leap.nvim",
	config = function()
		local leap = require("leap")

		leap.opts.safe_labels = {}

		-- Sneak-style mappings (canonical)
		vim.keymap.set({ "n", "x", "o" }, "s", function()
			leap.leap({ target_windows = { vim.fn.win_getid() } })
		end)

		vim.keymap.set({ "n", "x", "o" }, "S", function()
			leap.leap({
				target_windows = vim.tbl_filter(function(win)
					return win ~= vim.fn.win_getid()
				end, vim.api.nvim_list_wins()),
			})
		end)
	end,
}
