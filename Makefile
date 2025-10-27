.PHONY: update plugins mason treesitter health clean clean-soft

# 🔄 Full update
update: plugins mason treesitter health

# 🔁 Update Lazy.nvim plugins
plugins:
	@echo "🔁 Updating Lazy.nvim plugins..."
	@nvim --headless "+Lazy! update" +qa

# 🔧 Update Mason packages
mason:
	@echo "🔧 Updating Mason packages..."
	@nvim --headless "+MasonUpdate" +qa

# 🌳 Update Treesitter parsers
treesitter:
	@echo "🌳 Updating Treesitter parsers..."
	@nvim --headless -c "lua require('nvim-treesitter.install').update({ with_sync = true })()" +qa

# ✅ Run checkhealth
health:
	@echo "✅ Running :checkhealth..."
	@nvim --headless "+checkhealth" +qa

# 🧨 Full clean (plugins + state)
clean:
	@echo "🧨 Cleaning Lazy plugins and state..."
	@rm -rf ~/.local/share/nvim/lazy
	@rm -rf ~/.local/state/nvim
	@echo "✅ Plugins and state cleaned!"

# 🧹 Only clean state (safe)
clean-soft:
	@echo "🧹 Cleaning state only..."
	@rm -rf ~/.local/state/nvim
	@echo "✅ State cleaned!"
