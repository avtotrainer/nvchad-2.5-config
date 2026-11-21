-- GitHub Copilot (Copilot Free: 2000 completions / თვეში)
-- პირველ გაშვებაზე: :Copilot auth
--
-- Language server:
--   Windows / ჩვეულებრივი Linux → copilot.lua თავად ჩამოტვირთავს native binary-ს
--   NixOS → ჩამოტვირთული binary არ გაეშვება (იგივე პრობლემა, რაც Codeium-ს ჰქონდა), ამიტომ:
--     1) თუ PATH-ში არის copilot-language-server (nixpkgs) → ის გამოიყენება
--     2) თუ არა → nodejs რეჟიმი (Node.js >= 22)
local function server_opts()
	if vim.fn.has("win32") == 1 then
		return { type = "binary" }
	end

	local is_nixos = vim.uv.fs_stat("/etc/NIXOS") ~= nil
	if not is_nixos then
		return { type = "binary" }
	end

	local exe = vim.fn.exepath("copilot-language-server")
	if exe ~= "" then
		return { type = "binary", custom_server_filepath = exe }
	end

	return { type = "nodejs" }
end

return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		server = server_opts(),
		panel = { enabled = false },
		suggestion = {
			enabled = true,
			-- Copilot Free: ქვოტაში ყველა ნაჩვენები შეთავაზება ითვლება,
			-- ამიტომ ავტომატურად არ ჩნდება — გამოძახება Alt+] (next) / Alt+[ (prev)
			auto_trigger = false,
			hide_during_completion = true, -- cmp-ის მენიუს დროს იმალება
			keymap = {
				accept = "<C-g>", -- იგივე კლავიში, რაც Codeium-ს ჰქონდა
				accept_word = "<M-w>",
				accept_line = "<M-l>",
				next = "<M-]>",
				prev = "<M-[>",
				toggle_auto_trigger = "<M-a>", -- ავტომატური რეჟიმის ჩართვა/გამორთვა (მიმდინარე სესიაში)
				dismiss = "<C-]>", -- <C-e> cmp-ს ეკუთვნის; <C-]> ტერმინალისთვის მხოლოდ n/t რეჟიმშია
			},
		},
	},
}
