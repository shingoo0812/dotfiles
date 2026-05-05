require('mini.ai').setup {
  n_lines = 500,
  custom_textobjects = {
    f = function()
      local s = vim.fn.searchpos('(', 'cn')
      local e = vim.fn.searchpos(')', 'cn')
      if s[1] == 0 or e[1] == 0 then
        return
      end
      return { s[1], s[2], e[1], e[2] }
    end,
  },
}

require('mini.indentscope').setup {
  symbol = '│',
  options = { try_as_border = true },
  draw = { delay = 0, animation = require('mini.indentscope').gen_animation.none() },
}

require('mini.surround').setup {
  respect_selection_type = false,
  custom_surroundings = {
    ['('] = { output = { left = '(', right = ')' } },
    ['{'] = { output = { left = '{', right = '}' } },
    ['['] = { output = { left = '[', right = ']' } },
    ['<'] = { output = { left = '<', right = '>' } },
  },
}

local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%2l:%-2v'
end

require('mini.cmdline').setup {
  autocomplete = {
    enable = true,
    delay = 0,
    predicate = nil,
    map_arrows = true,
  },
  autocorrect = {
    enable = true,
    func = nil,
  },
  autopeek = {
    enable = true,
    n_context = 1,
    window = {
      config = {},
      statuscolumn = nil,
    },
  },
}
