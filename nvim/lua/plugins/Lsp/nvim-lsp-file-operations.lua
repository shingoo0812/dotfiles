require('lsp-file-operations').setup()

-- Extend capabilities for any LSP server that needs file operation support
-- Usage: pass the augmented capabilities when configuring a server
-- local caps = require('lsp-file-operations').default_capabilities()
-- vim.lsp.config['vtsls'] = { capabilities = caps }
