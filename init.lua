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

vim.keymap.set("", "<C-b>", "<C-v>", { desc = "Enter Visual Block Mode" })

-- NOP
vim.keymap.set("", "$", "<NOP>")
vim.keymap.set("", ",", "<NOP>")
vim.keymap.set("", "0", "<NOP>")

-- Ctrl-Z is broken on Windows
vim.keymap.set("", "<C-Z>", "<NOP>")

-- Map Ctrl-W to exit terminal mode and start a window command.
-- Use Ctrl-C or <Esc> to cancel the window command and stay in normal mode.
vim.keymap.set("t", "<C-W>", "<C-\\><C-N><C-W>", { remap = true })

-- LSP hover
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.keymap.set("", ",", vim.lsp.buf.hover, { buffer = args.buf })
	end,
})

-- Options
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.completeslash = "slash"
vim.opt.cursorline = true
vim.opt.fileformats = { "unix", "dos" }
vim.opt.ignorecase = true
vim.opt.number = true
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
vim.diagnostic.config({ severity_sort = true, virtual_text = { spacing = 1, prefix = "█" } })

-- Plugins
require("paq")({
	"mfussenegger/nvim-lint",
	"nvim-lualine/lualine.nvim",
	"RRethy/nvim-base16",
	"savq/paq-nvim",
	"stevearc/conform.nvim",
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
})

-- conform.nvim
require("conform").setup({
	formatters_by_ft = {
		css = { "prettier" },
		graphql = { "prettier" },
		html = { "prettier" },
		javascript = { "prettier" },
		json = { "prettier" },
		lua = { "stylua" },
		markdown = { "prettier" },
		python = { "reorder-python-imports", "ruff_format" },
		toml = { "taplo" },
		typescript = { "prettier" },
		xml = { "prettier" },
		yaml = { "prettier" },
	},
	formatters = {
		prettier = { prepend_args = { "--ignore-path", "NUL" } },
		["reorder-python-imports"] = { prepend_args = { "--application-directories=.:src" } },
	},
})

vim.keymap.set("", "0", require("conform").format, { buffer = buffer })

-- nvim-lint
require("lint").linters_by_ft = {
	python = { "ruff" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

-- LSP config
vim.lsp.config.pyright = {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"pixi.toml",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
		".git",
	},
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
			},
		},
	},

	before_init = function(_, config)
		local root_dir = vim.fn.getcwd()
		if config.root_dir then
			root_dir = config.root_dir
		end

		local python_exes = {
			-- pixi
			"/.pixi/envs/default/python.exe",
			"/.pixi/envs/default/bin/python",
			-- uv
			"/.venv/Scripts/python.exe",
			"/.venv/bin/python",
		}

		for _, python_exe in ipairs(python_exes) do
			python_exe = root_dir .. python_exe
			if vim.uv.fs_stat(python_exe) then
				config.settings.python.pythonPath = python_exe
				break
			end
		end
	end,
}
vim.lsp.enable("pyright")

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
	ignore_install = {
		"git_rebase",
		"gitcommit",
		"vimdoc",
	},
	sync_install = true,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
		disable = { "yaml" },
	},
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

-- Highlights
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		local loaded, base16 = pcall(require, "base16-colorscheme")
		if loaded and base16.colors then
			local c = base16.colors
			-- line numbers
			vim.api.nvim_set_hl(0, "LineNr", { fg = c.base01, bg = c.base00 })
			vim.api.nvim_set_hl(0, "CursorLine", { bg = c.base00 })
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = c.base03, bg = c.base00 })
			-- diagnostics
			vim.api.nvim_set_hl(0, "DiagnosticError", { fg = c.base08, bg = c.base01 })
			vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = c.base0A, bg = c.base01 })
			vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = c.base0C, bg = c.base01 })
			vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = c.base0E, bg = c.base01 })
			vim.api.nvim_set_hl(0, "DiagnosticOk", { fg = c.base0B, bg = c.base01 })
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
