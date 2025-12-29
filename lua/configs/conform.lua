local options = {
	formatters_by_ft = {
		lua = { "stylua" },
		css = { "prettier" },
		html = { "prettier" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		javascriptreact = { "prettier" },
		python = { "black" },
	},

	format_on_save = function(bufnr)
		local filename = vim.api.nvim_buf_get_name(bufnr)

		-- Python: არ გაუშვა black თუ კოდი არ კომპილირდება
		if filename:match("%.py$") then
			local cmd = "python -m py_compile " .. vim.fn.shellescape(filename)
			local result = vim.fn.system(cmd)

			if result ~= "" then
				-- კოდი გატეხილია → არ ვფორმატავთ
				return
			end
		end

		return {
			timeout_ms = 500,
			lsp_fallback = false,
		}
	end,
}

require("conform").setup(options)
