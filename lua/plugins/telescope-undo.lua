return {
  "debugloop/telescope-undo.nvim",
  keys = {
    {
      "<leader>fU",
      "<cmd>Telescope undo<cr>",
      desc = "Telescope Undo Tree",
    },
  },
  config = function()
    require("telescope").load_extension("undo")
  end,
}
