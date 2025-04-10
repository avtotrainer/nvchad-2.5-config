local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

M.show_maintenance_menu = function()
	local options = {
		{ label = "🔁 Update Plugins", command = "Lazy update" },
		{ label = "🔧 Update Mason Packages", command = "MasonUpdate" },
		{ label = "🌳 Update Treesitter Parsers", command = "TSUpdateSync" },
		{ label = "✅ Run :checkhealth", command = "checkhealth" },
		{ label = "📄 View Health Log", command = "edit $HOME/.cache/nvim/health.log" },
		{ label = "📄 View Lazy Log", command = "edit $HOME/.local/share/nvim/lazy/lazy.log" },
		{ label = "📄 View Mason Log", command = "edit $HOME/.local/share/nvim/mason.log" },
		{ label = "🧹 Clean Plugins + State", command = "!rm -rf ~/.local/share/nvim/lazy ~/.local/state/nvim" },
		{ label = "🧹 Clean Only State", command = "!rm -rf ~/.local/state/nvim" },
	}

	pickers
		.new({}, {
			prompt_title = "🛠️ NvChad Maintenance Menu",
			finder = finders.new_table({
				results = options,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry.label,
						ordinal = entry.label,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(_, _)
				actions.select_default:replace(function(prompt_bufnr)
					local selection = action_state.get_selected_entry(prompt_bufnr).value
					actions.close(prompt_bufnr)
					vim.cmd(selection.command)
				end)
				return true
			end,
		})
		:find()
end

return M
