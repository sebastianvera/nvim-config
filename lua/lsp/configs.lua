local M = {}

--- Generates a config table for lspconfig
--- @param config table: Base config
--- @return table
M.generate_sumneko_config = function(config)
	-- Configure lua language server for neovim development
	local runtime_path = vim.split(package.path, ";")
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")

	local sumneko_root_path = "/Users/rope/Code/lua-language-server/"
	local lua_settings = {
		Lua = {
			runtime = {
				-- LuaJIT in the case of Neovim
				version = "LuaJIT",
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim", "P", "G" },
			},
			telemetry = { enable = false },
			workspace = {
				preloadFileSize = 180,
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	}
	local luadev = require("lua-dev").setup({
		library = {
			vimruntime = true,
			types = true,
			plugins = false,
		},
		lspconfig = lua_settings,
	})
	local _config = vim.tbl_extend("keep", config, luadev)
	_config.cmd = { sumneko_root_path .. "bin/lua-language-server", "-E", sumneko_root_path .. "main.lua" }
	return _config
end

--- Generates a config table for lspconfig
--- @param config table: Base config
--- @return table
M.generate_jsonls_config = function(config)
	local jsonls = {
		settings = {
			json = {
				schemas = {
					{
						description = "TypeScript compiler configuration file",
						fileMatch = { "tsconfig.json", "tsconfig.*.json" },
						url = "http://json.schemastore.org/tsconfig",
					},
					{
						description = "Lerna config",
						fileMatch = { "lerna.json" },
						url = "http://json.schemastore.org/lerna",
					},
					{
						description = "package.json configuration",
						fileMatch = { "package.json"},
						url = "http://json.schemastore.org/package.json",
					},
					{
						description = "Babel configuration",
						fileMatch = { ".babelrc.json", ".babelrc", "babel.config.json" },
						url = "http://json.schemastore.org/lerna",
					},
					{
						description = "ESLint config",
						fileMatch = { ".eslintrc.json", ".eslintrc" },
						url = "http://json.schemastore.org/eslintrc",
					},
					{
						description = "Bucklescript config",
						fileMatch = { "bsconfig.json" },
						url = "https://bucklescript.github.io/bucklescript/docson/build-schema.json",
					},
					{
						description = "Prettier config",
						fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
						url = "http://json.schemastore.org/prettierrc",
					},
					{
						description = "Vercel Now config",
						fileMatch = { "now.json" },
						url = "http://json.schemastore.org/now",
					},
					{
						description = "Stylelint config",
						fileMatch = { ".stylelintrc", ".stylelintrc.json", "stylelint.config.json" },
						url = "http://json.schemastore.org/stylelintrc",
					},
				},
			},
		},
	}

	return vim.tbl_extend("keep", config, jsonls)
end
return M
