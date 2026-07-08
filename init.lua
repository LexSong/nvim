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

-- Shift-Tab jumps backward in a snippet, otherwise unindents. Extends the
-- default <S-Tab> mapping, which falls back to a literal (useless) Shift-Tab.
vim.keymap.set("i", "<S-Tab>", function()
	if vim.snippet.active({ direction = -1 }) then
		return "<Cmd>lua vim.snippet.jump(-1)<CR>"
	else
		return "<C-d>"
	end
end, { desc = "Snippet jump backward if active, otherwise unindent", expr = true, silent = true })

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
vim.opt.autoread = true
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.cursorline = true
vim.opt.fileformats = { "unix", "dos" }
vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.signcolumn = "no"
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.virtualedit = "block"
if vim.fn.has("win32") == 1 then
	vim.opt.completeslash = "slash"
end

-- Tab options
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4

-- Autoread doesn't trigger without checktime; call it on focus/idle
vim.api.nvim_create_autocmd({ "FocusGained", "CursorHold", "CursorHoldI" }, {
	callback = function()
		vim.cmd("checktime")
	end,
})

-- Diagnostic virtual text
vim.diagnostic.config({ severity_sort = true, virtual_text = { spacing = 1, prefix = "█" } })

-- Plugins
vim.pack.add({
	"https://github.com/RRethy/nvim-base16",
	"https://github.com/Saghen/blink.cmp",
	"https://github.com/Saghen/blink.lib",
	"https://github.com/Vimjas/vim-python-pep8-indent",
	"https://github.com/mfussenegger/nvim-lint",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/romus204/tree-sitter-manager.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/stevearc/oil.nvim",
})

-- blink.cmp
require("blink.cmp").build():pwait()
require("blink.cmp").setup({
	keymap = {
		preset = "super-tab",
		["<Tab>"] = {
			-- Default super-tab behavior: accept the menu / jump in a snippet.
			function(cmp)
				if cmp.snippet_active() then
					return cmp.accept()
				else
					return cmp.select_and_accept()
				end
			end,
			"snippet_forward",
			-- Extension: open the menu when there's something before the cursor.
			function(cmp)
				local col = vim.api.nvim_win_get_cursor(0)[2]
				if not vim.api.nvim_get_current_line():sub(1, col):match("^%s*$") then
					return cmp.show()
				end
			end,
			-- Nothing matched (only whitespace before cursor) -> indent.
			"fallback",
		},
	},
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
vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

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
	-- Disable hints
	capabilities = {
		textDocument = {
			publishDiagnostics = {
				tagSupport = {
					valueSet = { 2 },
				},
			},
		},
	},

	-- Resolve the Python interpreter for pyright.
	-- Prefer the project-root venv; otherwise fall back to PATH.
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

-- mini.icons
require("mini.icons").setup()

-- oil.nvim
require("oil").setup({
	columns = { "icon" },
})

-- treesitter
require("tree-sitter-manager").setup({
	ensure_installed = {
		"csv",
		"json",
		"lua",
		"markdown",
		"markdown_inline",
		"python",
		"toml",
		"yaml",
	},
	auto_install = false,
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
			-- mini.icons
			vim.api.nvim_set_hl(0, "MiniIconsRed", { fg = c.base08 })
			vim.api.nvim_set_hl(0, "MiniIconsOrange", { fg = c.base09 })
			vim.api.nvim_set_hl(0, "MiniIconsYellow", { fg = c.base0A })
			vim.api.nvim_set_hl(0, "MiniIconsGreen", { fg = c.base0B })
			vim.api.nvim_set_hl(0, "MiniIconsCyan", { fg = c.base0C })
			vim.api.nvim_set_hl(0, "MiniIconsAzure", { fg = c.base0D })
			vim.api.nvim_set_hl(0, "MiniIconsBlue", { fg = c.base0D })
			vim.api.nvim_set_hl(0, "MiniIconsPurple", { fg = c.base0E })
			vim.api.nvim_set_hl(0, "MiniIconsGrey", { fg = c.base04 })
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
