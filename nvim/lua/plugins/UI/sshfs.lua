require('remote-sshfs').setup {
  connections = {
    ssh_configs = {
      vim.fn.expand '$HOME' .. '/.ssh/config',
    },
  },
  mounts = {
    base_dir = vim.fn.expand '$HOME' .. '/.sshfs/',
    unmount_on_exit = true,
  },
  handlers = {
    on_connect = { change_dir = true },
    on_disconnect = { clean_mount_folders = false },
  },
  ui = { confirm = { connect = true, change_dir = false } },
  log = {
    enable = false,
    truncate = false,
    types = { all = false, util = false, handler = false, sshfs = false },
  },
}

vim.keymap.set('n', '<leader>rc', function() require('remote-sshfs').connect() end, { desc = '[R]emote [C]onnect' })
vim.keymap.set('n', '<leader>rd', function() require('remote-sshfs').disconnect() end, { desc = '[R]emote [D]isconnect' })
vim.keymap.set('n', '<leader>re', function() require('remote-sshfs').edit() end, { desc = '[R]emote [E]dit' })
