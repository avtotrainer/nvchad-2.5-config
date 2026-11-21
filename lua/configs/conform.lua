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
			-- სიის ფორმა shell-ს გვერდს უვლის → Linux-ზეც და Windows-ზეც ერთნაირად მუშაობს
			local python
			for _, exe in ipairs({ "python", "python3", "py" }) do
				if vim.fn.executable(exe) == 1 then
					python = exe
					break
				end
			end

			if python then
				vim.fn.system({ python, "-m", "py_compile", filename })
				if vim.v.shell_error ~= 0 then
					-- კოდი გატეხილია → არ ვფორმატავთ
					return
				end
			end
		end

		return {
			timeout_ms = 500,
			lsp_fallback = false,
		}
	end,
}

require("conform").setup(options)
