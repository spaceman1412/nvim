-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Resume search telescope
vim.keymap.set(
  "n",
  "<leader>sR",
  require("telescope.builtin").resume,
  { noremap = true, silent = true, desc = "Resume Search Telescope" }
)
