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

-- Map <C-E> to <C-P>
vim.keymap.set("", "<C-E>", "<C-P>")
vim.keymap.set("", "<C-P>", "<NOP>")
vim.keymap.set("!", "<C-E>", "<C-P>")
vim.keymap.set("!", "<C-P>", "<NOP>")

-- NOP
vim.keymap.set("", ",", "<NOP>")
vim.keymap.set("", "=", "<NOP>")
vim.keymap.set("", "==", "<NOP>")

-- Ctrl-Z is broken on Windows
vim.keymap.set("", "<C-Z>", "<NOP>")

-- Map Ctrl-W to exit terminal mode and start a window command.
-- Use Ctrl-C or <Esc> to cancel the window command and stay in normal mode.
vim.keymap.set("t", "<C-W>", "<C-\\><C-N><C-W>", { remap = true })

-- Options
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menu" }
vim.opt.completeslash = "slash"
vim.opt.fileformats = { "unix", "dos" }
vim.opt.ignorecase = true
vim.opt.signcolumn = "no"
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.virtualedit = "block"

-- Tab options
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4

-- Diagnostic virtual text
vim.diagnostic.config({ virtual_text = { spacing = 1, prefix = "█" } })

-- Set the python3 executable
if vim.fn.has("win32") then
	vim.api.nvim_set_var("python3_host_prog", "C:/Users/LexSong/mambaforge/envs/pynvim/python.exe")
end

-- Plugins
require("paq")({
	"RRethy/nvim-base16",
	"jose-elias-alvarez/null-ls.nvim",
	"neovim/nvim-lspconfig",
	"numirias/semshi",
	"nvim-lua/plenary.nvim",
	"nvim-lualine/lualine.nvim",
	"savq/paq-nvim",
})

-- null-ls.nvim
require("null-ls").setup({
	sources = {
		require("null-ls").builtins.diagnostics.flake8,
		require("null-ls").builtins.diagnostics.yamllint,
		require("null-ls").builtins.formatting.black,
		require("null-ls").builtins.formatting.prettier,
		require("null-ls").builtins.formatting.reorder_python_imports.with({
			extra_args = { "--application-directories=.:src" },
		}),
		require("null-ls").builtins.formatting.stylua,
		require("null-ls").builtins.formatting.taplo,
	},
	on_attach = function(client, buffer)
		vim.keymap.set("", "==", vim.lsp.buf.format, { buffer = buffer })
	end,
})

-- nvim-lspconfig
require("lspconfig").jedi_language_server.setup({
	on_attach = function(client, buffer)
		vim.keymap.set("", ",", vim.lsp.buf.hover, { buffer = buffer })
	end,
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

-- Semshi
vim.api.nvim_set_var("semshi#always_update_all_highlights", true)
vim.api.nvim_set_var("semshi#error_sign", false)
vim.api.nvim_set_var("semshi#mark_selected_nodes", 2)

-- Highlights
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		local loaded, base16 = pcall(require, "base16-colorscheme")
		if loaded and base16.colors then
			local c = base16.colors
			-- diagnostics
			vim.api.nvim_set_hl(0, "DiagnosticError", { fg = c.base08, bg = c.base01 })
			vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = c.base0A, bg = c.base01 })
			vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = c.base0C, bg = c.base01 })
			vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = c.base0E, bg = c.base01 })
			-- semshi
			vim.api.nvim_set_hl(0, "semshiLocal", { fg = c.base08 })
			vim.api.nvim_set_hl(0, "semshiGlobal", { fg = c.base0A })
			vim.api.nvim_set_hl(0, "semshiImported", { fg = c.base0A })
			vim.api.nvim_set_hl(0, "semshiParameter", { fg = c.base08 })
			vim.api.nvim_set_hl(0, "semshiParameterUnused", { fg = c.base08, underline = 1 })
			vim.api.nvim_set_hl(0, "semshiFree", { fg = c.base08 })
			vim.api.nvim_set_hl(0, "semshiBuiltin", { fg = c.base0E })
			vim.api.nvim_set_hl(0, "semshiAttribute", { fg = c.base0D })
			vim.api.nvim_set_hl(0, "semshiSelf", { fg = c.base0F })
			vim.api.nvim_set_hl(0, "semshiUnresolved", { fg = c.base0A, underline = 1 })
			vim.api.nvim_set_hl(0, "semshiSelected", { fg = c.base0C, underline = 1 })
		end
	end,
})

-- Colorschemes
vim.cmd("colorscheme base16-material")
