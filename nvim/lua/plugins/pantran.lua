require('pantran').setup {
  default_engine = 'google',
  engines = {
    yandex = {
      default_source = 'auto',
      default_target = 'en',
    },
  },
  controls = {
    mappings = {
      edit = {
        n = {
          ['j'] = 'gj',
          ['k'] = 'gk',
        },
        i = {
          ['<C-y>'] = false,
          ['<C-a>'] = require('pantran.ui.actions').yank_close_translation,
        },
      },
      select = {
        n = {},
      },
    },
  },
}
