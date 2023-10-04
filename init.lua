-- Custom key mappings
vim.keymap.set("", ":", ",")
vim.keymap.set("", "<Space>", ":")
vim.keymap.set("", "<C-W><Space>", ":")
vim.keymap.set("", "<PageDown>", "<C-D>")
vim.keymap.set("", "<PageUp>", "<C-U>")

vim.keymap.set("", "H", "0")
vim.keymap.set("", "J", "<C-D>")
vim.keymap.set("", "K", "<C-U>")
vim.keymap.set("", "L", "$")
vim.keymap.set("", "M", "J")

-- NOP
vim.keymap.set("", "$", "<NOP>")
vim.keymap.set("", ",", "<NOP>")
vim.keymap.set("", "0", "<NOP>")

-- Ctrl-Z is broken on Windows
vim.keymap.set("", "<C-Z>", "<NOP>")

-- Map Ctrl-W to exit terminal mode and start a window command.
-- Use Ctrl-C or <Esc> to cancel the window command and stay in normal mode.
vim.keymap.set("t", "<C-W>", "<C-\\><C-N><C-W>", { remap = true })

-- Options
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
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
	vim.api.nvim_set_var("python3_host_prog", "C:/Users/LexSong/miniforge3/envs/pynvim/python.exe")
end

-- Plugins
require("paq")({
	"jose-elias-alvarez/null-ls.nvim",
	"neovim/nvim-lspconfig",
	"nvim-lua/plenary.nvim",
	"nvim-lualine/lualine.nvim",
	"RRethy/nvim-base16",
	"savq/paq-nvim",
	"tpope/vim-commentary",
	{ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
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
		vim.keymap.set("", "0", vim.lsp.buf.format, { buffer = buffer })
	end,
})

-- nvim-lspconfig
require("lspconfig").pylsp.setup({
	settings = {
		pylsp = {
			plugins = {
				jedi = {
					environment = vim.fn.executable("python") == 1 and vim.fn.exepath("python") or nil,
				},
			},
		},
	},
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

-- treesitter
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"json",
		"lua",
		"markdown",
		"markdown_inline",
		"python",
		"toml",
		"yaml",
	},
	sync_install = true,
	auto_install = true,
	highlight = {
		enable = true,
		disable = {
			"git_rebase",
			"gitcommit",
		},
		additional_vim_regex_highlighting = false,
	},
})

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
			-- treesitter markdown highlights
			local function set_markdown_highlights(name, color)
				vim.api.nvim_set_hl(0, name .. ".markdown", color)
				vim.api.nvim_set_hl(0, name .. ".markdown_inline", color)
			end
			set_markdown_highlights("@punctuation.delimiter", { fg = c.base03 })
			set_markdown_highlights("@punctuation.special", { fg = c.base0C })
			set_markdown_highlights("@text.literal", { fg = c.base0B })
			set_markdown_highlights("@text.reference", { fg = c.base0B })
		end
	end,
})

-- Colorschemes
vim.cmd("colorscheme base16-material")
