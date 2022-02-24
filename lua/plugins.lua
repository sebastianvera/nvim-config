require("packer").startup(function(use)
	use({ "wbthomason/packer.nvim", opt = true })

	use("tpope/vim-unimpaired")
	use("tpope/vim-repeat")
	use("tpope/vim-surround")
	use("tpope/vim-vinegar")
	use("justinmk/vim-sneak")
	use("christoomey/vim-tmux-runner")

	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})

	use({
		"windwp/nvim-autopairs",
		event = "BufRead",
		config = function()
			require("nvim-autopairs").setup({
				fast_wrap = { map = "€" },
			})
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
		end,
		after = "nvim-cmp",
	})

	use({
		"nvim-telescope/telescope.nvim",
		config = function()
			require("telescope").load_extension("fzy_native")
			local actions = require("telescope.actions")

			require("telescope").setup({
				defaults = require("telescope.themes").get_ivy({
					winblend = 10,
					mappings = {
						i = {
							-- Change keys to select previous and next
							["<Down>"] = false,
							["<Up>"] = false,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,

							-- Use <C-a> to move all to qflist
							-- Use <C-q> to move selected to qflist
							["<M-q>"] = false,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
						},
						n = {
							["<M-q>"] = false,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
						},
					},
				}),
			})
		end,
		requires = {
			{ "nvim-lua/popup.nvim" },
			{ "nvim-lua/plenary.nvim" },
			{
				"nvim-telescope/telescope-file-browser.nvim",
				after = "telescope.nvim",
				config = function()
					require("telescope").load_extension("file_browser")
				end,
			},
			{
				"nvim-telescope/telescope-project.nvim",
				after = "telescope.nvim",
				config = function()
					require("telescope").load_extension("project")
				end,
			},
		},
	})

	use({ "nvim-telescope/telescope-fzy-native.nvim", requires = "nvim-telescope/telescope.nvim" })

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"go",
					"html",
					"javascript",
					"markdown",
					"python",
					"query",
					"rust",
					"tsx",
					"typescript",
					"comment",
				},
				highlight = {
					enable = true,
					use_languagetree = false,
					disable = { "json" },
					custom_captures = {},
				},
				autotag = {
					enable = true,
				},
				matchup = {
					enable = true, -- mandatory, false will disable the whole extension
					disable = { "c", "ruby" }, -- optional, list of language that will be disabled
				},
				textobjects = {
					move = {
						enable = true,
						set_jumps = true,

						goto_next_start = {
							["]p"] = "@parameter.inner",
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[p"] = "@parameter.inner",
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},

					select = {
						enable = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",

							["ac"] = "@conditional.outer",
							["ic"] = "@conditional.inner",

							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
						},
					},
				},
			})
		end,
		requires = {
			"andymass/vim-matchup",
			{ "windwp/nvim-ts-autotag", after = "nvim-treesitter" },
			{ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" },
		},
	})

	use({
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		config = function()
			require("indent_blankline").setup({
				show_current_context = true,
			})
		end,
	})

	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signcolumn = true,
				numhl = true,
				current_line_blame = false,
				keymaps = {},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
					map("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

					-- Actions
					map("n", "<leader>gb", gs.toggle_current_line_blame)
				end,
			})
		end,
		requires = {
			"nvim-lua/plenary.nvim",
		},
		event = "BufRead",
	})

	use({ "ellisonleao/gruvbox.nvim" })

	use({
		"rose-pine/neovim",
		as = "rose-pine",
		config = function()
			vim.g.rose_pine_variant = "moon"
			vim.g.bold_vert_split = true
			vim.g.disabled_italics = false
			vim.g.disabled_background = false
			vim.g.disable_float_background = true
			vim.cmd([[ colorscheme rose-pine ]])
		end,
	})

	use({
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					---@usage 'rose-pine' | 'rose-pine-alt'
					theme = "rose-pine",
				},
			})
		end,
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	use({
		"neovim/nvim-lspconfig",
		"folke/lua-dev.nvim",
		"ray-x/lsp_signature.nvim",
	})

	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("null-ls").setup({
				debug = true,
				sources = {
					require("null-ls").builtins.formatting.stylua,
					require("null-ls").builtins.formatting.prettier,
					require("null-ls").builtins.formatting.goimports,
					require("null-ls").builtins.diagnostics.golangci_lint,
					-- require("null-ls").builtins.code_actions.gitsigns,
				},
			})
		end,
	})

	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup({ keywords = { TODO = { alt = { "WIP" } } } })
		end,
	})

	use({
		"hrsh7th/nvim-cmp",
		lock = true,
		event = "InsertEnter",
		branch = "dev",
		config = function()
			require("configs.cmp")
		end,
		module = "cmp",
		requires = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
			"onsails/lspkind-nvim",
			{ "petertriho/cmp-git", requires = "nvim-lua/plenary.nvim" },
		},
	})

	use({
		"L3MON4D3/LuaSnip",
		config = function()
			require("configs.luasnip")
		end,
		requires = {
			"rafamadriz/friendly-snippets",
			after = "LuaSnip",
		},
	})

	use({
		"kosayoda/nvim-lightbulb",
		config = function()
			require("nvim-lightbulb").setup({
				ignore = { "null-ls" },
			})

			vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])
		end,
	})

	use({
		"weilbith/nvim-code-action-menu",
		cmd = "CodeActionMenu",
	})
end)
