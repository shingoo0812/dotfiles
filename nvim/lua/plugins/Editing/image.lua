-- image.nvim configuration for displaying images in terminal
-- Requires: ImageMagick and luarocks magick package
-- Check if ImageMagick is available
local function check_imagemagick()
  local handle = io.popen('convert --version 2>&1')
  if handle then
    local result = handle:read('*a')
    handle:close()
    return result:match('ImageMagick') ~= nil
  end
  return false
end
-- Lazy load image.nvim setup
local function setup_image_nvim()
  local ok, image = pcall(require, 'image')
  if not ok then
    vim.notify('image.nvim not found', vim.log.levels.WARN)
    return
  end
  if not check_imagemagick() then
    vim.notify(
      'ImageMagick not found. Install it for image display:\nsudo apt install imagemagick\nluarocks --local install magick',
      vim.log.levels.WARN
    )
    return
  end
  image.setup {
    backend = 'kitty', -- Use Kitty graphics protocol (supported by Wezterm)
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
      },
      neorg = {
        enabled = false,
      },
      html = {
        enabled = false,
      },
      css = {
        enabled = false,
      },
    },
    max_width = nil, -- nil means no limit
    max_height = nil,
    max_width_window_percentage = 50, -- Limit to 50% of window width
    max_height_window_percentage = 50, -- Limit to 50% of window height
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
    editor_only_render_when_focused = false,
    tmux_show_only_in_active_window = true,
    hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' },
  }
  vim.notify('image.nvim loaded successfully', vim.log.levels.INFO)
end
-- Setup on VimEnter to ensure all dependencies are loaded
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    vim.schedule(setup_image_nvim)
  end,
})
