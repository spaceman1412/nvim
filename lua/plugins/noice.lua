return {
  "folke/noice.nvim",
  opts = function(_, opts)
    table.insert(opts.routes, {
      filter = {
        event = "notify",
        find = "completion request failed",
      },
      opts = { skip = true },
    })
  end,
}
