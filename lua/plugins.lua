require('packer').startup(function(use)
    use {'wbthomason/packer.nvim', opt = true}
    use {'junegunn/vim-easy-align', opt = true, cmd = {'EasyAlign'}}

    use 'w0rp/ale'

    use 'tpope/vim-repeat'
    use 'tpope/vim-surround'
    use 'tpope/vim-vinegar'
    use 'justinmk/vim-sneak'
    use 'christoomey/vim-tmux-runner'
    use 'metakirby5/codi.vim'
    use 'bluz71/vim-moonfly-colors'
    use {
      "folke/trouble.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
        require("trouble").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end
    }

    use {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end
    }

    use '~/code/blane.nvim'

    use {'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'},
      {'kyazdani42/nvim-web-devicons'},
    }
  }

  use({ 'rose-pine/neovim', as = 'rose-pine' })

  use {'nvim-telescope/telescope-fzy-native.nvim', requires = 'nvim-telescope/telescope.nvim'}
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  -- use 'tjdevries/express_line.nvim'
  use 'tjdevries/nlua.nvim'
  -- use 'tjdevries/astronauta.nvim'

  use 'neovim/nvim-lspconfig'
  use {'nvim-lua/lsp-status.nvim', requires = 'neovim/nvim-lspconfig'}
  use 'hrsh7th/nvim-compe'

  use 'simnalamburt/vim-mundo'

  use 'mhinz/vim-signify'

  use 'kassio/neoterm'
  use 'vimwiki/vimwiki'
  use 'rafcamlet/nvim-luapad'

  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }
end)
