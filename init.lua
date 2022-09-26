-- Key mappings
vim.keymap.set("", ":", ",")
vim.keymap.set("", "<Space>", ":")
vim.keymap.set("", "<C-W><Space>", ":")
vim.keymap.set("", "<PageDown>", "<C-D>")
vim.keymap.set("", "<PageUp>", "<C-U>")

-- Key mappings for Colemak-DH
vim.keymap.set("", "m", "h")
vim.keymap.set("", "n", "j")
vim.keymap.set("", "e", "k")
vim.keymap.set("", "i", "l")
vim.keymap.set("", "M", "0")
vim.keymap.set("", "N", "<C-D>")
vim.keymap.set("", "E", "<C-U>")
vim.keymap.set("", "I", "$")

vim.keymap.set("", "h", "n")
vim.keymap.set("", "j", "e")
vim.keymap.set("", "k", "m")
vim.keymap.set("", "l", "i")
vim.keymap.set("", "H", "N")
vim.keymap.set("", "J", "E")
vim.keymap.set("", "K", "J")
vim.keymap.set("", "L", "I")

-- Map Ctrl-W to exit terminal mode and start a window command.
-- Use Ctrl-C or <Esc> to cancel the window command and stay in normal mode.
vim.keymap.set("t", "<C-W>", "<C-\\><C-N><C-W>", { remap = true })
