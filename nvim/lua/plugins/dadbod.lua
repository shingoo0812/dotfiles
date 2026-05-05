-- vim-dadbod global settings
vim.g.db_ui_use_nerd_fonts = 1
local data_path = vim.fn.stdpath 'data'
vim.g.db_ui_save_location = data_path .. '/dadbod_ui'
vim.g.db_ui_tmp_query_location = data_path .. '/dadbod_ui/tmp'
vim.g.db_ui_show_database_icon = 1
vim.g.db_ui_auto_execute_table_helpers = 1
vim.g.db_ui_use_nvim_notify = 1
vim.g.db_ui_execute_on_save = 0
vim.g.db_ui_default_query = 'SELECT * FROM {table} LIMIT 100'
vim.g.db_ui_win_position = 'left'

vim.g.dbs = {
  dev = 'postgresql://user:password@localhost:5432/mydb',
  mysql_local = 'mysql://root:password@localhost:3306/mydb',
  sqlite_local = 'sqlite:~/data/mydb.sqlite',
  asset_manager = 'postgresql://postgres:postgres@localhost:5432/asset_manager',
}

vim.keymap.set('n', '<leader>db', '<cmd>DBUIToggle<CR>', { desc = 'Open database UI' })
vim.keymap.set('n', '<leader>df', '<cmd>DBUIFindBuffer<CR>', { desc = 'DBUIBuffer Search' })
vim.keymap.set('n', '<leader>da', '<cmd>DBUIAddConnection<CR>', { desc = 'Add DB connection' })

-- SQL completion via nvim-cmp
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sql', 'mysql', 'plsql' },
  callback = function()
    local cmp = require 'cmp'
    local sources = vim.tbl_map(function(source)
      return { name = source.name }
    end, cmp.get_config().sources)
    table.insert(sources, { name = 'vim-dadbod-completion' })
    cmp.setup.buffer { sources = sources }
  end,
})
