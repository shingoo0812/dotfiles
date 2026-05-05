require('auto-session').setup {
  auto_restore = true,
  auto_save = true,
  post_restore_cmds = {
    function()
      vim.defer_fn(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= '' then
            vim.api.nvim_buf_call(buf, function()
              vim.cmd 'filetype detect'
              vim.cmd 'doautocmd BufRead'
            end)
          end
        end
      end, 100)
    end,
  },
}
