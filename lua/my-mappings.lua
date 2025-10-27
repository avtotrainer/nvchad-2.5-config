local map = vim.keymap.set

-- Diagnostic mappings
map("n", "gl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
map("n", "<leader>dd", vim.diagnostic.setloclist, { desc = "Show all diagnostics (loclist)" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Find diagnostics (Telescope)" })

map("n", "<leader>mu", function()
	require("utils.telescope_menu").show_maintenance_menu()
end, { desc = "🛠️ NvChad Maintenance Menu" })

-- Add more personal mappings here
-- Terminal
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Escape Terminal Mode" })
