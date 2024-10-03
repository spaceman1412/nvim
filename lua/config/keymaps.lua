-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local telescope_builtin = require("telescope.builtin")
local whichkey_builtin = require("which-key")

-- Add group obisidan to which-key
whichkey_builtin.add({
  { "<leader>o", group = "obsidian" },
})

-- Resume search telescope
vim.keymap.set(
  "n",
  "<leader>sR",
  telescope_builtin.resume,
  { noremap = true, silent = true, desc = "Resume Search Telescope" }
)
-- Delete file in current buffer
-- vim.keymap.set("n", "<leader>fd", ":!rm '%:p'<cr>:bd<cr>", {
--   desc = "Delete file in current buffer",
-- })

-- #OBSIDIAN
-- Navigate to vault
vim.keymap.set("n", "<leader>oo", ":cd /Users/chaileasevn/Documents/Obsidian Vault<cr>", {
  desc = "Navigate to Obsidian Vault",
})

-- convert note to template and remove leading white space
vim.keymap.set("n", "<leader>oc", ":ObsidianTemplate note<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>", {
  desc = "Convert note to template",
})
-- strip date from note title and replace dashes with spaces
-- must have cursor on title
vim.keymap.set("n", "<leader>of", ":s/\\(# \\)[^_]*_/\\1/ | s/-/ /g<cr>", {
  desc = "Remove date from title under cursor",
})

-- Search for files in full vault
vim.keymap.set("n", "<leader>os", function()
  telescope_builtin.find_files({
    hidden = false,
    cwd = "~/Documents/Obsidian Vault",
  })
end, {
  desc = "Search Obsidian Files",
})

-- Search for grep in full vault
vim.keymap.set("n", "<leader>oz", function()
  telescope_builtin.live_grep({
    hidden = false,
    cwd = "~/Documents/Obsidian Vault",
  })
end, {
  desc = "Search Obsidian Grep",
})
-- for review workflow
-- move file in current buffer to spaceman1412 folder
vim.keymap.set("n", "<leader>ok", ":!mv '%:p' /Users/chaileasevn/Documents/Obsidian\\ Vault/spaceman1412<cr>:bd<cr>", {
  desc = "Move current buffer to spaceman1412 folder",
})

-- move file in current buffer to inbox tempt folder
vim.keymap.set("n", "<leader>ot", ":!mv '%:p' /Users/chaileasevn/Documents/Obsidian\\ Vault/inbox<cr>:bd<cr>", {
  desc = "Move current buffer to inbox tempt folder",
})

-- delete file in current buffer
vim.keymap.set("n", "<leader>od", function()
  -- Get the current file path
  local file = vim.fn.expand("%:p")

  -- Check if the file exists
  if vim.fn.filereadable(file) == 1 then
    -- Ask for confirmation
    local choice = vim.fn.confirm("Are you sure you want to delete this file?", "&Yes\n&No", 2)

    if choice == 1 then -- 1 corresponds to "Yes"
      -- Delete the file
      vim.fn.delete(file)

      -- Close the buffer without saving
      vim.cmd("bdelete!")

      print("File deleted: " .. file)
    end
  else
    print("No file to delete.")
  end
end, { noremap = true, silent = true, desc = "Delete current file with confirmation" })

-- Create hub with input
vim.keymap.set("n", "<leader>oh", function()
  vim.ui.input({ prompt = "Enter hub name" }, function(input)
    vim.cmd(":!touch /Users/chaileasevn/Documents/Obsidian\\ Vault/hubs/" .. input .. ".md")
  end)
end, {
  desc = "Add hub",
})
