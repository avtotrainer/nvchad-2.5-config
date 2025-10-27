#!/bin/bash

echo "🔁 Updating Lazy.nvim plugins..."
nvim --headless "+Lazy! update" +qa

echo "🔧 Updating Mason packages..."
nvim --headless "+MasonUpdate" +qa

echo "🌳 Updating Treesitter parsers..."
nvim --headless -c "lua require('nvim-treesitter.install').update({ with_sync = true })()" +qa

echo "✅ Running :checkhealth..."
nvim --headless "+checkhealth" +qa

echo "🎉 Neovim update complete!"
