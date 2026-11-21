local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

-- stdpath() Linux-ზე ~/.local/share/nvim, Windows-ზე %LOCALAPPDATA%\nvim-data და ა.შ.
local data = vim.fn.stdpath("data")
local state = vim.fn.stdpath("state")
local log = vim.fn.stdpath("log")
local cache = vim.fn.stdpath("cache")

local function edit(path)
	return function()
		vim.cmd.edit(vim.fn.fnameescape(path))
	end
end

local function remove(paths)
	return function()
		for _, p in ipairs(paths) do
			if vim.fn.delete(p, "rf") == 0 then
				vim.notify("Removed: " .. p)
			end
		end
		vim.notify("Restart Neovim to apply.", vim.log.levels.WARN)
	end
end

M.show_maintenance_menu = function()
	local options = {
		{ label = "🔁 Update Plugins", command = "Lazy update" },
		{ label = "🔧 Update Mason Packages", command = "MasonUpdate" },
		{ label = "🌳 Update Treesitter Parsers", command = "TSUpdateSync" },
		{ label = "✅ Run :checkhealth", command = "checkhealth" },
		{ label = "📄 View Health Log", run = edit(cache .. "/health.log") },
		{ label = "📄 View Lazy Log", run = edit(data .. "/lazy/lazy.log") },
		{ label = "📄 View Mason Log", run = edit(log .. "/mason.log") },
		{ label = "📄 View LSP Log", run = edit(vim.lsp.get_log_path()) },
		{ label = "🧹 Clean Plugins + State", run = remove({ data .. "/lazy", state }) },
		{ label = "🧹 Clean Only State", run = remove({ state }) },
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
					if selection.run then
						selection.run()
					else
						vim.cmd(selection.command)
					end
				end)
				return true
			end,
		})
		:find()
end

return M
