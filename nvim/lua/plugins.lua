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
  use 'ray-x/lsp_signature.nvim'

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
  use({
      "aaronhallaert/advanced-git-search.nvim",
      config = function()
          require("telescope").load_extension("advanced_git_search")
      end,
      requires = {
          "nvim-telescope/telescope.nvim",
          -- to show diff splits and open commits in browser
          "tpope/vim-fugitive",
      },
  })

  -- personal
  use 'esquires/vim-map-medley'
  use 'esquires/tabcity'
  use 'esquires/lvdb'

  -- other
  use {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup {
      }
    end
  }
  use 'majutsushi/tagbar'
  -- use 'vim-airline/vim-airline'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use 'chaoren/vim-wordmotion'
  use 'plasticboy/vim-markdown'
  use 'kchmck/vim-coffee-script'
  use 'milkypostman/vim-togglelist'
  use 'tomtom/tcomment_vim'
  -- use 'tmhedberg/SimpylFold'
  use 'ludovicchabant/vim-gutentags'
  use 'lervag/vimtex'

  -- neorg
  use {'nvim-neorg/neorg-telescope'}
  -- use {'nvim-neorg/neorg'}
  -- use {
  --   "nvim-neorg/neorg",
  --   -- tag = "*",
  --   ft = "norg",
  --   config = function()
  --     require('neorg').setup {
  --       load = {
  --         ["core.defaults"] = {}, -- Loads default behaviour
  --         ["core.concealer"] = {}, -- Adds pretty icons to your documents
  --         ["core.dirman"] = {
  --           config = {workspaces = {notes = "~/Documents/notes/norg", },},
  --         },
  --         ["core.export"] = {config = {extensions = "all"}},
  --         ["core.export.markdown"] = {config = {extensions = "all"}},
  --         ["core.completion"] = { config = { engine = "nvim-cmp" } },
  --         ["core.keybinds"] = { -- Configure core.keybinds
  --           config = {
  --             default_keybinds = false,
  --               hook = function(keybinds)
  --                   keybinds.remap_event("norg", "n", "<C-S>", "core.integrations.telescope.find_linkable")
  --                   keybinds.remap_event("norg", "i", "<C-l>", "core.integrations.telescope.insert_link")
  --                   keybinds.remap("norg", "n", "gtd", "<cmd>echo 'Hello!'<CR>")
  --               end,
  --           }
  --         },
  --         ["core.integrations.telescope"] = {},
  --       },
  --     }
  --   end,
  --   run = ":Neorg sync-parsers",
  --   requires = "nvim-lua/plenary.nvim",
  -- }


  use 'HiPhish/nvim-ts-rainbow2'
  use 'nvim-treesitter/nvim-treesitter-textobjects'

  use {
    'phaazon/hop.nvim',
    branch = 'v1', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  use 'esquires/vim-moonfly-colors'
end)
