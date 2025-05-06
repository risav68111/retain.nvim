-- Plugin: retain.nvim
-- Description: A directory retention plugin for Neovim
-- Author: Your Name
-- License: MIT

-- Only load once
if vim.g.retain_loaded then
    return
end
vim.g.retain_loaded = true

-- Create user commands
vim.api.nvim_create_user_command('Retain', function()
    require('retain').open()
end, {
    desc = 'Open retain.nvim directory picker'
})

-- Create keymaps if not disabled
if not vim.g.retain_disable_keymaps then
    vim.keymap.set('n', '<leader>rd', function()
        require('retain').open()
    end, {
        desc = 'Open retain.nvim directory picker',
        silent = true,
        noremap = true
    })
end