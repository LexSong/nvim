-- Don't load the default python ftplugin
vim.b.did_ftplugin = 1

-- Swap ';' and ':'
vim.keymap.set("i", ";", ":", { buffer = true })
vim.keymap.set("i", ":", ";", { buffer = true })
