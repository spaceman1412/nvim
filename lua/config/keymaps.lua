-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local telescope_builtin = require("telescope.builtin")
local whichkey_builtin = require("which-key")

-- Reconfig Alt keys when using tmux-tilish
vim.keymap.del({
  "n",
  "i",
  "v",
}, "<A-j>")
vim.keymap.del({
  "n",
  "i",
  "v",
}, "<A-k>")

-- Move Lines
vim.keymap.set("n", "<A-[>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
vim.keymap.set("n", "<A-]>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
vim.keymap.set("i", "<A-[>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<A-]>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<A-[>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<A-]>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- Increment/decrement
vim.keymap.set("n", "+", "<C-a>")
vim.keymap.set("n", "-", "<C-x>")

-- Select all
vim.keymap.set("n", "<leader>a", "gg<S-v>G")

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

-- Function to organize tasks in visual selection
local function organize_tasks()
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))

  -- Retrieve the selected lines
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)

  -- Adjust the first and last lines if the selection is partial
  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_col + 1, end_col + 1)
  else
    lines[1] = string.sub(lines[1], start_col + 1)
    lines[#lines] = string.sub(lines[#lines], 1, end_col + 1)
  end

  local unfinished_tasks = {}
  local finished_tasks = {}

  -- Sort lines into unfinished and finished tasks
  for _, line in ipairs(lines) do
    if line:match("^%- %[ %]") then
      table.insert(unfinished_tasks, line)
    elseif line:match("^%- %[x%]") then
      table.insert(finished_tasks, line)
    end
  end

  -- Combine sorted tasks with a line break in between
  local organized_lines = vim.list_extend(unfinished_tasks, { "" })
  organized_lines = vim.list_extend(organized_lines, finished_tasks)

  -- Replace the selected lines with organized lines
  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, organized_lines)

  print("Tasks have been organized")
end

-- Create a Neovim command to easily call the function
vim.api.nvim_create_user_command("OrganizeTasks", organize_tasks, { range = true })
-- Create hub with input
vim.keymap.set("n", "<leader>oh", function()
  -- local inputFile = "/Users/chaileasevn/Documents/Obsidian Vault/templates/note.md"
  -- local file = io.open(inputFile, "r")
  -- local fileContent = {}
  -- if file == nil then
  --   return
  -- end
  -- for line in file:lines() do
  --   table.insert(fileContent, line)
  -- end
  -- io.close(file)
  -- local lineTest = string.find(fileContent[5], "#")
  -- print(lineTest)
  --
  -- file = io.open(inputFile, "w")
  -- if file == nil then
  --   return
  -- end
  -- for index, value in ipairs(fileContent) do
  --   file:write(value .. "\n")
  -- end
  -- io.close(file)

  -- We need to find a extract all the hub name after # and replace it with new one
  -- continue with the , between it
  -- We need to write a function that fetch all the hub exist and add it to template

  vim.ui.input({ prompt = "Enter hub name" }, function(input)
    vim.cmd(":!touch /Users/chaileasevn/Documents/Obsidian\\ Vault/hubs/" .. input .. ".md")
  end)
end, {
  desc = "Add hub",
})
