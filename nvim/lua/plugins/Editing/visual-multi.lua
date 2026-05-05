vim.g.VM_default_mappings = 0
vim.g.VM_maps = {
  ['Find Under'] = '<C-d>',
  ['Find Subword Under'] = '<C-S-d>',
  ['Exit'] = '<Esc>',
}

vim.keymap.set('x', '<leader>mc', '<Plug>(VM-Visual-Cursors)', { silent = true })
vim.keymap.set('x', '<leader>ma', '<Plug>(VM-Visual-Add)', { silent = true })
