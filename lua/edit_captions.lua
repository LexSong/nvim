local function load_yaml(filename)
	local result = vim.system({ "yq", "-o", "json", filename }, { text = true }):wait()
	if result.code ~= 0 then
		error("Failed to load YAML: " .. result.stderr)
	end
	return vim.json.decode(result.stdout)
end

local function edit_captions(opts)
	local directory = "."
	if opts.args and opts.args ~= "" then
		directory = opts.args
	end

	-- Generate the captions.yaml
	local captions_file = directory .. "/captions.yaml"
	local file = io.open(captions_file, "w")

	local png_files = vim.fn.glob(directory .. "/*.png", false, true)
	for _, png_path in ipairs(png_files) do
		local txt_path = png_path:gsub("%.png$", ".txt")

		local caption = ""
		if vim.fn.filereadable(txt_path) == 1 then
			caption = vim.fn.readfile(txt_path)[1]
		end

		local filename = vim.fn.fnamemodify(png_path, ":t")
		file:write(string.format("%s: %s\n", filename, caption))
	end

	file:close()

	-- Open the captions.yaml file for editing
	vim.cmd("edit " .. captions_file)

	-- Set up autocommand to save changes
	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = captions_file,
		callback = function()
			local captions = load_yaml(captions_file)

			for filename, caption in pairs(captions) do
				local txt_file = filename:gsub("%.png$", ".txt")
				local txt_path = directory .. "/" .. txt_file
				vim.fn.writefile({ caption:match("^%s*(.-)%s*$") }, txt_path) -- Trim whitespace
			end

			vim.notify("Captions saved successfully", vim.log.levels.INFO)
		end,
	})
end

return edit_captions
