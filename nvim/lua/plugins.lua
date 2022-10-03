return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'tpope/vim-fugitive'

  use 'Vimjas/vim-python-pep8-indent'

  -- For luasnip users.
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  -- nvim cmp sources
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lua'
  use 'onsails/lspkind-nvim'

  -- nvim-telescope
  use 'kyazdani42/nvim-web-devicons'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- personal
  use 'esquires/vim-map-medley'
  use 'esquires/tabcity'
  use 'esquires/lvdb'

  -- other
  use 'majutsushi/tagbar'
  use 'vim-airline/vim-airline'
  use 'chaoren/vim-wordmotion'
  use 'plasticboy/vim-markdown'
  use 'kchmck/vim-coffee-script'
  use 'milkypostman/vim-togglelist'
  use 'tomtom/tcomment_vim'
  use 'neomake/neomake'
  use 'tmhedberg/SimpylFold'
  use 'ludovicchabant/vim-gutentags'
  use 'lervag/vimtex'

  -- neorg
  use {
    'nvim-neorg/neorg',
    branch = 'main',
    requires = { {
        'nvim-lua/plenary.nvim', 'folke/zen-mode.nvim', 'Pocco81/TrueZen.nvim', "nvim-neorg/neorg-telescope"
    } }
  }

  -- use {'~/repos/temp/neorg-dateinserter'}
  use {'~/repos/temp/neorg-gtd-project-tags'}
  -- use {'~/repos/temp/neorg-math'}
  use {'nvim-neorg/neorg-telescope'}
  use {'mattn/calendar-vim'}

  use 'nvim-treesitter/playground'
  use 'p00f/nvim-ts-rainbow'
  use 'nvim-treesitter/nvim-treesitter-textobjects'

  use {
    'phaazon/hop.nvim',
    branch = 'v1', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  use 'bluz71/vim-moonfly-colors'
end)
