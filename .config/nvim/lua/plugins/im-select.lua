return {
  {
    "keaising/im-select.nvim",
    event = "VimEnter",
    config = function()
      vim.g.im_select_default_ime = "0"
      vim.g.im_select_get_current_im = function()
        return vim.fn.system("im-select current"):gsub("%s+", "")
      end
      vim.g.im_select_set_current_im = function(im)
        vim.fn.system({ "im-select", im })
      end
      require("im_select").setup()

      vim.fn.system({ "im-select", "0" })
    end,
  },
}
