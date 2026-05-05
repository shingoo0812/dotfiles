-- presence.nvim: no configuration needed

-- lsp_signature
require('lsp_signature').setup()

-- alpha-nvim dashboard
local alpha = require 'alpha'
local dashboard = require 'alpha.themes.dashboard'
dashboard.section.header.val = {
  '===================================================',
  '=  =======  ================  ====  ===============',
  '=   ======  ================  ====  ===============',
  '=    =====  ================  ====  ===============',
  '=  ==  ===  ===   ====   ===  ====  ==  ==  =  = ==',
  '=  ===  ==  ==  =  ==     ==   ==   ======        =',
  '=  ====  =  ==     ==  =  ===  ==  ===  ==  =  =  =',
  '=  =====    ==  =====  =  ===  ==  ===  ==  =  =  =',
  '=  ======   ==  =  ==  =  ====    ====  ==  =  =  =',
  '=  =======  ===   ====   ======  =====  ==  =  =  =',
  '===================================================',
  '                       _nnnn_                      ',
  '                      dGGGGMMb                     ',
  '                     @p~qp~~qMb                    ',
  '                     M|@||@) M|                    ',
  '                     @,----.JM|                    ',
  '                    JS^\\__/  qKL                   ',
  '                   dZP        qKRb                 ',
  '                  dZP          qKKb                ',
  '                 fZP            SMMb               ',
  '                 HZM            MMMM               ',
  '                 FqM            MMMM               ',
  '               __| ..        |LdS.qML              ',
  "               |    `.       | `' \\Zq              ",
  "              _)      \\.___.,|     .'              ",
  "              \\____   )MMMMMP|   .'                ",
  "                   `-'       `--' hjm              ",
}
dashboard.section.buttons.val = {
  dashboard.button('e', '📄 New file', ':ene <BAR> startinsert <CR>'),
  dashboard.button('f', '🔍 Find file', ':Telescope find_files<CR>'),
  dashboard.button('r', '🕒 Recently used files', ':Telescope oldfiles<CR>'),
  dashboard.button('s', '🔧 Settings', ':e $MYVIMRC<CR>'),
  dashboard.button('q', '🚪 Quit Neovim', ':qa<CR>'),
}
alpha.setup(dashboard.config)
