require('tiny-inline-diagnostic').setup {}

-- Disable default virtual text since tiny-inline-diagnostic replaces it
vim.diagnostic.config { virtual_text = false }
