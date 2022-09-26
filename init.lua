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

-- Options
vim.opt.clipboard = "unnamedplus"
vim.opt.completeslash = "slash"
vim.opt.fileformats = { "unix", "dos" }
vim.opt.ignorecase = true
vim.opt.signcolumn = "no"
vim.opt.termguicolors = true
vim.opt.virtualedit = "block"

-- Tab options
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4

-- Set the python3 executable
if vim.fn.has("win32") then
	vim.api.nvim_set_var("python3_host_prog", "C:/Users/LexSong/mambaforge/python.exe")
end

-- Plugins
require("paq")({
	"RRethy/nvim-base16",
	"jose-elias-alvarez/null-ls.nvim",
	"nvim-lua/plenary.nvim",
	"nvim-lualine/lualine.nvim",
	"savq/paq-nvim",
})

-- lualine.nvim
require("lualine").setup({
	options = {
		icons_enabled = false,
		theme = "base16",
		component_separators = { left = "|", right = "|" },
		section_separators = { left = "", right = "" },
	},
})

-- null-ls.nvim
require("null-ls").setup({
	sources = {
		require("null-ls").builtins.diagnostics.flake8,
		require("null-ls").builtins.diagnostics.yamllint,
		require("null-ls").builtins.formatting.black,
		require("null-ls").builtins.formatting.prettier,
		require("null-ls").builtins.formatting.reorder_python_imports,
		require("null-ls").builtins.formatting.stylua,
	},
})

-- Colorschemes
vim.cmd("colorscheme base16-material")
