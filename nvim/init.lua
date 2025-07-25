-- packer configuration
vim.loader.enable()

-- leaders
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.scrolloff = 5

-- backups
vim.o.backup = true
vim.o.writebackup = true
vim.o.backupdir = vim.fn.expand('~/.vim/backups')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({

  -- colorscheme
  { 'nvim-treesitter/nvim-treesitter-context',
    lazy = false,
    config = function()
      require("treesitter-context").setup({
        max_lines = 5,
      })
    end,
  },
  {
    'pteroctopus/faster.nvim'
  },
  { 'mfussenegger/nvim-lint',
    lazy = false,
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        cpp = { "cppcheck" },
      }
    end,
  },
  {
    'esquires/vim-moonfly-colors',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.cmd([[colorscheme moonfly]])
    end,
  },
  -- {
  --   "rachartier/tiny-inline-diagnostic.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require('tiny-inline-diagnostic').setup({
  --       hi = {
  --           background = "None", -- Can be a highlight or a hexadecimal color (#RRGGBB)
  --       },
  --     })
  --   end,
  -- },
  { 'lervag/vimtex', lazy = false },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    opts = {},
  },
  { 'micangl/cmp-vimtex',
    lazy = false,
    config = function()
      require('cmp_vimtex').setup({
        format = function(entry, vim_item)
          vim_item.menu = ({
            -- Use this line if you wish to add a specific kind for cmp-vimtex:
            --vimtex = "[Vimtex]" .. (vim_item.menu ~= nil and vim_item.menu or ""),
            vimtex = vim_item.menu,
            buffer = "[Buffer]",
            nvim_lsp = "[LSP]",
          })[entry.source.name]

          return vim_item
        end,
        additional_information = {
          info_in_menu = true,
          info_in_window = true,
          info_max_length = 60,
          match_against_info = true,
          symbols_in_menu = true,
        },
        bibtex_parser = {
          enabled = true,
        },
      })
    end,
  },
  { 'rcarriga/nvim-notify', lazy = false },
  { 'jbyuki/nabla.nvim', lazy = false },
  {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
          require("nvim-surround").setup({
              -- Configuration here, or leave empty to use defaults
          })
      end
  },
  -- { "folke/which-key.nvim",
  --   event = "VeryLazy",
  --   init = function()
  --     vim.o.timeout = true
  --     vim.o.timeoutlen = 300
  --   end,
  --   config = function(_, opts)
  --     local wk = require("which-key")
  --     wk.setup(opts)
  --     wk.register(opts.defaults)
  --   end,
  -- },
  -- { "kchmck/vim-coffee-script", lazy = false },
  { "tpope/vim-fugitive", lazy = false },
  -- { "L3MON4D3/LuaSnip", lazy = true },
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "1.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp"
  },
  { 'nvim-tree/nvim-web-devicons', lazy = false },
  { 'ray-x/lsp_signature.nvim', lazy = false},
  { 'RRethy/vim-illuminate', lazy = false},
  { 'esquires/vim-map-medley', lazy = false},
  { 'esquires/tabcity', lazy = false},
  { 'esquires/lvdb', lazy = false},
  { 'mhartington/formatter.nvim', lazy = false },
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
       "nvim-treesitter/nvim-treesitter",
       "nvim-tree/nvim-web-devicons"
    },
  },
  -- { 'majutsushi/tagbar', lazy = false},
  { 'chaoren/vim-wordmotion', lazy = false},
  { 'preservim/vim-markdown', lazy = false},
  { 'windwp/nvim-autopairs', lazy = false, opts = {}},
  { 'lukas-reineke/indent-blankline.nvim', main="ibl", lazy = false, opts = {scope = {enabled=false}}},
  { 'milkypostman/vim-togglelist', lazy = false},
  { 'tomtom/tcomment_vim', lazy = false},
  -- { 'ludovicchabant/vim-gutentags', lazy = false},
  -- { 'HiPhish/nvim-ts-rainbow2', lazy = false},
  { 'hiphish/rainbow-delimiters.nvim',
    lazy = false,
  },
  { 'nvim-treesitter/nvim-treesitter-textobjects', lazy = false},
  { 'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   version = "*",
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons"
  --   },
  --   config = function () require("nvim-tree").setup {} end
  -- },
  {
    -- https://www.lazyvim.org/plugins/treesitter
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "hiphish/rainbow-delimiters.nvim",
      "nvim-treesitter/nvim-treesitter-textobjects"
    },
    ---@type TSConfig
    opts = {
      highlight = {
        enable = true,
        disable = "latex",
        additional_vim_regex_highlighting = {'latex','norg'}
      },

      indent = { enable = true },
      ensure_installed = {
        "bash",
        "sql",
        "c",
        "cpp",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      },
      -- rainbow = {
      --   enable = true,
      --   -- list of languages you want to disable the plugin for
      --   -- disable = { "jsx", "cpp" },
      --   -- Which query to use for finding delimiters
      --   query = 'rainbow-parens',
      --   -- Highlight the entire buffer all at once
      --   -- strategy = require('ts-rainbow').strategy.global,
      --   hlgroups = {
      --      'TSRainbowRed',
      --      'TSRainbowBlue',
      --      'TSRainbowYellow',
      --      'TSRainbowViolet',
      --      'TSRainbowOrange',
      --      'TSRainbowGreen',
      --      'TSRainbowCyan'
      --   },
      -- },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  { 'ggandor/leap.nvim', lazy = false},
  { 'nvim-lualine/lualine.nvim', lazy = false,
    dependencies = {'nvim-tree/nvim-web-devicons'},
  },
  { 'nvim-telescope/telescope.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    cmd = "Telescope",
    keys = {
      { '<leader>ff', ":FindFiles "},
      { '<leader>fg', ":lua GitFindFilesHelper(false)<cr>" },
      { '<leader>fG', ":lua GitFindFilesHelper(true)<cr>" },
      { '<leader>fb', ":lua require('telescope.builtin').buffers({ignore_current_buffer=true})<cr>" },
      { '<leader>fr', ":LiveGrep " },
    }
  },
  { 'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    lazy = false,
  },
  { 'neovim/nvim-lspconfig', lazy = false },
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    event = "InsertEnter",  -- load cmp on InsertEnter
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lua',
      'onsails/lspkind-nvim',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      require 'lsp'
    end,
  },
  {
    -- https://vhyrro.github.io/posts/neorg-and-luarocks
    "vhyrro/luarocks.nvim",
    priority = 1000, -- We'd like this plugin to load first out of the rest
    config = true, -- This automatically runs `require("luarocks-nvim").setup()`
  },
  {
    "nvim-neorg/neorg",
    dependencies = {
			-- "3rd/image.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-neorg/neorg-telescope",
      "luarocks.nvim",
      "pysan3/neorg-templates", dependencies = { "L3MON4D3/LuaSnip" },
    },
    -- put any other flags you wanted to pass to lazy here!
    config = function()
      require("neorg").setup {
        load = {
          -- https://github.com/nvim-neorg/neorg/issues/1408#issuecomment-2093155213
          ["core.defaults"] = {
            config = {
              disable = { "core.todo-introspector" },
            },
          },
          ["core.concealer"] = {}, -- Adds pretty icons to your documents
          ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
              workspaces = {
                main = "~/norg",
              },
              default_workspace = 'main',
            },
          },
          ["core.integrations.telescope"] = {},
          ["core.integrations.image"] = {},
          ["core.export"] = { config = {export_dir = '/tmp/neorg' } },
          ["core.export.markdown"] = { config = { extensions = 'all' } },
          ["core.summary"] = {},
          ["core.latex.renderer"] = {
            config = {
            }
          },
          ["core.keybinds"] = {
            config = {
              hook = function(keybinds)
                -- vim.pretty_print(keybinds)
                keybinds.map_to_mode("all", {
                  n = {
                    { vim.g.maplocalleader .. "lv", ":lua OpenNeorgPdf()<cr>", opts = { desc = "Enter Norg Mode" } },
                  },
                })
              end,
            }
          },
          ["external.templates"] = {
            config = {
              templates_dir = "~/norg/personal/templates",
            },
          },
        }
      }
    end,
  },
  {
    "3rd/image.nvim", lazy = false
  },
  { "niuiic/track.nvim",
    lazy = false,
    dependencies = {
       "niuiic/core.nvim",
      "nvim-telescope/telescope.nvim"
    }
  }

})

require('rainbow-delimiters.setup').setup {
    highlight = {
       'RainbowDelimiterRed',
       'RainbowDelimiterBlue',
       'RainbowDelimiterYellow',
       'RainbowDelimiterViolet',
       'RainbowDelimiterOrange',
       'RainbowDelimiterGreen',
       'RainbowDelimiterCyan'
    },
}

require('render-markdown').setup({
    code = {
        enabled = true,
        render_modes = false,
        sign = true,
        style = 'full',
        position = 'left',
        language_pad = 0,
        language_icon = true,
        language_name = true,
        disable_background = { 'diff' },
        width = 'full',
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = 'hide',
        above = '▄',
        below = '▀',
        inline_left = '',
        inline_right = '',
        inline_pad = 0,
        highlight = 'RenderMarkdownCode',
        highlight_language = nil,
        highlight_border = 'RenderMarkdownCodeBorder',
        highlight_fallback = 'RenderMarkdownCodeFallback',
        highlight_inline = 'RenderMarkdownCodeInline',
    },
})

require('aerial').setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', {buffer = bufnr})
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', {buffer = bufnr})
  end
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
vim.keymap.set('n', '<leader>o', '<cmd>vs<CR><cmd>Oil<CR>')

-- track

local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')

local cmp = require('cmp')
local compare = require('cmp.config')

SortUnderscore = function(entry1, entry2)

  local num_underscores = function(str)
    if string.sub(str, 1, 1) ~= '_' then
      return 0
    elseif string.sub(str, 2, 2) ~= '_' then
      return 1
    else
      return 2
    end
  end

  local n1 = num_underscores(entry1.completion_item.label)
  local n2 = num_underscores(entry2.completion_item.label)
  if n1 < n2 then
    return true
  elseif n1 > n2 then
    return false
  end
end

cmp.setup({
    sorting = {
      priority_weight = 2,
      comparators = {
        SortUnderscore,
        compare.offset,
        compare.exact,
        -- compare.scopes,
        compare.score,
        compare.recently_used,
        compare.locality,
        compare.kind,
        -- compare.sort_text,
        compare.length,
        compare.order,
      },
    },

})

vim.notify = require("notify")
-- print(vim.inspect(cmp.config))
-- print(nvim.inspect(require('cmp')

npairs.add_rule(Rule("$|","|$","norg"))

-- you can use some built-in conditions

local cond = require('nvim-autopairs.conds')
-- local Rule = require('nvim-autopairs.rule')
-- local npairs = require('nvim-autopairs')
-- local cond = require('nvim-autopairs.conds')
-- npairs.add_rules({
--   Rule("$", "$",{'norg'})
-- })

local neorg_callbacks = require("neorg.core.callbacks")

-- neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
--     -- Map all the below keybinds only when the "norg" mode is active
--     keybinds.map_event_to_mode("norg", {
--         n = { -- Bind keys in normal mode
--             { "<C-s>", "core.integrations.telescope.find_linkable" },
--         },
--
--         i = { -- Bind in insert mode
--             { "<C-l>", "core.integrations.telescope.insert_link" },
--         },
--     }, {
--         silent = true,
--         noremap = true,
--     })
-- end)

require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  filetype = {
    python = {
      require("formatter.filetypes.python").isort,
      require("formatter.filetypes.python").black,
    },
    cpp = {
      require("formatter.filetypes.cpp").clangformat,
    }
  },
}

-- helper functions
cmd = vim.api.nvim_command
function keymap(mode, src, dst, desc)
    vim.api.nvim_set_keymap(mode, src, dst, { noremap = true, desc = desc})
end

keymap('n', '<localleader>f', ':Format<CR>')

-- Setup nvim-cmp.
-- require('lsp')

-- setup snippets
require("snippets")
-- require('leap').add_default_mappings()
vim.keymap.set({'n', 'v'}, '<a-l>', '<Plug>(leap-forward-to)')
vim.keymap.set({'n', 'v'}, '<a-h>', '<Plug>(leap-backward-to)')

-- track
require('track').setup(
  {
    sign = {
      text = "󰍒",
      text_color = "#ffff00",
      priority = 10000,
    },
  }
)
keymap('n', 'mt', ':lua require("track").toggle()<cr>')
keymap('n', 'mr', ':lua require("track").remove()<cr>')
keymap('n', 'me', ':lua require("track").edit()<cr>')
keymap('n', 'mj', ':lua require("track").jump_to_next()<cr>')
keymap('n', 'mk', ':lua require("track").jump_to_prev()<cr>')
keymap('n', 'ms', ':lua require("track").search()<cr>')

-- neorg telescope
-- neorg.telescope.insert_file_link
-- vim.keymap.set("n", "<c-i>", "<Plug>(neorg.telescope.insert_file_link)")


-- vimtex
vim.g.vimtex_view_general_viewer = 'okular'
vim.g.vimtex_view_general_options = '--unique file:@pdf#src:@line@tex'
vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1
vim.g.vimtex_compiler_latexmk = {
 aux_dir = 'build',
 out_dir = 'build',
 callback = 1,
 continuous = 1,
 executable = 'latexmk',
 hooks = {},
 options = {
   '-verbose',
   '-file-line-error',
   '-synctex=1',
   '-interaction=nonstopmode',
 },
}

vim.g.titlestring = "%:t"

-- settings
cmd('nnoremap / /\\v')
cmd('nnoremap ? ?\\v')
vim.opt.smartcase = true
vim.opt.mouse = ''

vim.opt.title = true
vim.opt.cmdheight= 2
cmd('nnoremap <localleader>q :q<cr>')

vim.opt.bs = '2'
vim.opt.conceallevel = 2
vim.opt.concealcursor = ''
vim.opt.wildmode = 'list,full'
vim.opt.termguicolors = true

-- terminal settings
cmd('tnoremap <M-[> <C-\\><C-n>')
cmd('nnoremap <C-h> <C-\\><C-n>gT')
cmd('tnoremap <C-h> <C-\\><C-n>gT')
cmd('nnoremap <C-l> <C-\\><C-n>gt')
cmd('tnoremap <C-l> <C-\\><C-n>gt')
cmd('tnoremap <M-w> <C-\\><C-n>w')
cmd('command! Newterm :tabnew | term')
-- cmd('nnoremap <localleader>o :tabo<cr>')

vim.opt.scrollback = 100000

keymap('n', '<localleader>p', ':lua require("nabla").popup()<CR>', 'show eqn')
keymap('n', '<localleader>v', ':lua require"nabla".enable_virt({autogen = true, silent = true})<cr>', 'virtual txt')
keymap('n', '<localleader>V', ':lua require"nabla".disable_virt()<cr>', 'disable virtual txt')
keymap('n', '<leader>r', ':NvimTreeOpen<cr>', 'open nvim tree file explorer')

-- lvdb
keymap('n', '<localleader>d', ':call lvdb#Python_debug()<cr>', 'start lvdb')
keymap('n', '<leader>n', ':call lines#ToggleNumber()<cr>', 'toggle line numbers')
vim.g.lvdb_toggle_lines = 3
vim.g.lvdb_close_tabs = 1

-- tagbar
-- keymap('n', '<localleader>t', ':TagbarToggle<CR>', 'tag bar')

-- airline
-- cmd("let g:airline_extensions = ['tabline']")
-- cmd("let g:airline#extensions#tabline#enabled = 1")
-- cmd("let g:airline#extensions#tabline#tab_nr_type = 1")  -- tabnumber
-- cmd("let g:airline#extensions#tabline#formatter = 'unique_tail'")
-- cmd("let g:airline#extensions#tabline#show_splits = 0")
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = { left = '│', right = '│'},
    section_separators = { left = '┃', right = '┃'},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {
      {
        'filename',
        file_status = true,      -- Displays file status (readonly status, modified status)
        newfile_status = false,  -- Display new file status (new file means no write after created)
        path = 1,                -- 0: Just the filename
                                 -- 1: Relative path
                                 -- 2: Absolute path
                                 -- 3: Absolute path, with tilde as the home directory

        shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
                                 -- for other components. (terrible name, any suggestions?)
        symbols = {
          modified = '[+]',      -- Text to show when the file is modified.
          readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
          unnamed = '[No Name]', -- Text to show for unnamed buffers.
          newfile = '[New]',     -- Text to show for newly created file before first write
        }
      }
    },
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

-- fugitive
keymap('n', '<localleader>gs', ':G<cr>}jj<c-w>H', 'git status')
keymap('n', '<localleader>gb', ':Git blame<cr>')
keymap('n', '<localleader>gt', ':Git commit<cr>')
keymap('n', '<localleader>gl', ':Git log --pretty=format:"%h %ad %s %d [%an]" --decorate --date=short -100 --graph<cr><c-w>H', 'git log')
keymap('n', '<localleader>gd', ':Gdiffsplit<cr>')
keymap('n', '<localleader>gco', ':Git checkout ')
keymap('n', '<localleader>gp', ':Git push origin HEAD<cr>')
keymap('n', '<localleader>ga', ':Telescope advanced_git_search ')

-- wordmotion
cmd("let g:wordmotion_mappings = {'W': '', 'B': '', 'E': ''}")

-- telescope
-- https://github.com/nvim-telescope/telescope-fzf-native.nvim
-- https://dev.to/dlains/create-your-own-vim-commands-415b
require('telescope').load_extension('fzf')
keymap('n', '<leader>ff', ":FindFiles ")
keymap('n', '<leader>fg', ":lua GitFindFilesHelper(false)<cr>", 'find git files')
keymap('n', '<leader>fG', ":lua GitFindFilesHelper(true)<cr>", 'find git files recursive')
keymap('n', '<leader>fb', ":lua require('telescope.builtin').buffers({ignore_current_buffer=true})<cr>", 'find in buffers')
keymap('n', '<leader>fr', ":LiveGrep ")
-- keymap('n', '=', "za")

local function GetCwdHelper(cwd)
  if cwd == nil then
    -- use the file's directory
    cwd = vim.fn.expand('%:p:h')

    -- if in a git repo go up to the root
    local git_root, ret = require("telescope.utils").get_os_command_output(
      { "git", "rev-parse", "--show-toplevel" }, cwd)

    if ret == 0 then
      cwd = git_root[1]
    end
  end

  if not vim.fn.isdirectory(cwd) then
      print(cwd .. ' does not exist, defaulting to ' .. vim.loop.cwd())
      cwd = vim.loop.cwd()
  end

  return cwd
end

function FindFilesHelper(cwd)
  -- calculate the current path relative to the currently open file
  local curr_file_path = vim.fn.expand('%:p')
  local cwd = GetCwdHelper(cwd)
  local find_command = {'rg', '--files'}

  if vim.startswith(curr_file_path, cwd) then
    local ignore = string.sub(curr_file_path, -(#curr_file_path - #cwd))
    table.insert(find_command, '-g')
    table.insert(find_command, '!' .. ignore)
  end

  -- vim.print(find_command)
  require('telescope.builtin').find_files({cwd=cwd, find_command = find_command})
end

function GitFindFilesHelper(recurse_submodules)
  local curr_file_path = vim.fn.expand('%:p')
  local cwd = vim.fn.expand('%:p:h')
  local git_command = {"git","ls-files","--exclude-standard","--cached"}
  if vim.startswith(curr_file_path, cwd) then
    -- https://stackoverflow.com/a/36754216
    local ignore = string.sub(curr_file_path, -(#curr_file_path - #cwd - 1))
    table.insert(git_command, ':!:' .. ignore)
  end

  require('telescope.builtin').git_files({cwd=cwd, git_command = git_command, recurse_submodules = recurse_submodules, show_untracked = not recurse_submodules})
end


function LiveGrepHelper(cwd)
  require('telescope.builtin').live_grep({cwd=GetCwdHelper(cwd)})
end

cmd("command! -nargs=? -complete=dir FindFiles lua FindFilesHelper(<f-args>)")
cmd("command! -nargs=? -complete=dir LiveGrep lua LiveGrepHelper(<f-args>)")

local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-Down>"] = require('telescope.actions').cycle_history_next,
        ["<C-Up>"] = require('telescope.actions').cycle_history_prev,
      },
    },
    winblend = 30,
    layout_config = {
      horizontal = {
        height = 0.99,
        preview_cutoff = 120,
        prompt_position = "bottom",
        width = 0.99,
        preview_width = 0.5,
      },
  }
  },
  pickers = {
    buffers = {
      mappings = {
        i = {
          -- https://github.com/nvim-telescope/telescope.nvim/pull/828
          ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
        }
      }
    }
  },
  prompt_prefix = "foobar"
}

-- luasnip
vim.api.nvim_set_keymap("i", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("i", "<C-p>", "<Plug>luasnip-prev-choice", {})
vim.api.nvim_set_keymap("s", "<C-p>", "<Plug>luasnip-prev-choice", {})

-- fixme: others yet to be updated
cmd('source ~/.config/nvim/old-cfg.vim')

function GetNeorgOutputPath()
  return os.getenv('HOME') .. '/neorg_outputs'
end

function NotifyErr(j, return_val)
  if return_val ~= 0 then
    local msg = ''
    for _, err_msg in pairs(j:stderr_result()) do
      msg = msg .. '\n' .. err_msg
      
    end
    vim.notify(msg, vim.log.levels.ERROR)
  end
end

function OpenNeorgPdf()
  local fname = GetNeorgOutputPath() .. '/pdf/' .. vim.fn.expand('%:t:r') .. '.pdf'
  local job = require'plenary.job'
  job:new({command = 'okular', args = { fname }, on_exit = NotifyErr,}):start()
end

function ConvertNeorg()
  -- local workspace_root = require("neorg").modules.get_module("core.dirman").get_current_workspace()[2]
  -- local export_path = workspace_root .. '/export'
  -- local export_path = workspace_root .. '/export'

  local export_path = GetNeorgOutputPath()
  local markdown_path = export_path .. '/markdown'
  local pdf_path = export_path .. '/pdf'
  local fname = vim.fn.expand('%:t:r')
  local markdown_fname = markdown_path .. '/' .. fname .. '.md'
  local pdf_fname = pdf_path .. '/' .. fname .. '.pdf'

  if string.find(vim.fn.expand('%:p'), "personal/journal") then
    local dirname = vim.fn.expand('%:p:h:t')
    export_path = os.getenv('HOME') .. '/blog/content/daily/' .. vim.fn.expand('%:p:h:t')
    markdown_fname = export_path .. '/' ..  fname .. '.md'
    pdf_path = nil
  end

  local mkdir = function(pth)
    if pth ~= nil and vim.fn.isdirectory(pth) == 0 then
      vim.fn.mkdir(pth)
    end
  end

  mkdir(export_path)
  mkdir(markdown_path)
  mkdir(pdf_path)
  local job = require'plenary.job'
  local neorg = require("neorg")
  local buf = vim.api.nvim_win_get_buf(0)

  local exported = neorg.modules.get_module("core.export").export(buf, "markdown")

  -- copied from neorg/lua/neorg/modules/core/export/module.lua
  -- to avoid the extra notification
  vim.loop.fs_open(markdown_fname, "w", 438, function(err, fd)
    assert(not err, neorg.lib.lazy_string_concat("Failed to open file '", markdown_fname, "' for export: ", err))
    vim.loop.fs_write(fd, exported, 0, function(werr)
      assert(
        not werr,
        neorg.lib.lazy_string_concat("Failed to write to file '", markdown_fname, "' for export: ", werr)
      )

      if pdf_path ~= nil then

        job:new({
          command = 'pandoc',
            args = { '-V', 'geometry:margin=1.0in', '-V', 'linkcolor:red', '-V', 'urlcolor:red', markdown_fname, '-o', pdf_fname},
            on_exit = NotifyErr,
        }):start()
      else
        job:new({
          command = 'sed',
          args = {'-i', 's:^```$::', markdown_fname},
          on_exit = NotifyErr,
        }):start()
      end

    end)

  end)

end

vim.api.nvim_create_autocmd(
  {"BufWritePost"},
  {
    pattern = {"*.norg"},
    callback = ConvertNeorg,
  }
)

-- https://github.com/3rd/image.nvim
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
-- default config
local function ConfigureImageNvim()
  require("image").setup({
    backend = "kitty",
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
      },
      neorg = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "norg" },
      },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = nil,
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
    tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" }, -- render image files as images when opened
  })
end

pcall(ConfigureImageNvim)

-- neorg
-- require('nvim-treesitter.configs').setup {
--   ensure_installed = "all",
--   ignore_install = { "latex" },
--   highlight = { -- Be sure to enable highlights if you haven't!
--     enable = true,
--   },
--   indent = {
--     enable = true,
--     disable = {"python",},  -- https://www.reddit.com/r/neovim/comments/ok9frp/v05_treesitter_does_anyone_have_python_indent/
--   },
--   rainbow = {
--     enable = true,
--     -- list of languages you want to disable the plugin for
--     -- disable = { "jsx", "cpp" },
--     -- Which query to use for finding delimiters
--     query = 'rainbow-parens',
--     -- Highlight the entire buffer all at once
--     strategy = require 'ts-rainbow.strategy.global',
--     hlgroups = {
--        'TSRainbowRed',
--        'TSRainbowBlue',
--        'TSRainbowYellow',
--        'TSRainbowViolet',
--        'TSRainbowOrange',
--        'TSRainbowGreen',
--        'TSRainbowCyan'
--     },
--   },
--   -- rainbow = {
--   --   enable = true,
--   --   -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
--   --   extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
--   --   max_file_lines = nil, -- Do not enable for files with more than n lines, int
--   --           colors = {
--   --               "#ffffff", -- white
--   --               "#cece32", -- dark yellow
--   --               "#ff4040", -- red
--   --               "#00ff00", -- green
--   --               "#00ffff", -- blue
--   --           },
--   --   -- termcolors = {'white', 'Yellow', 'blue'} -- table of colour name strings
--   -- },
--
--   textobjects = {
--     select = {
--       enable = true,
--
--       -- Automatically jump forward to textobj, similar to targets.vim
--       lookahead = true,
--
--       keymaps = {
--         -- You can use the capture groups defined in textobjects.scm
--         ["af"] = "@function.outer",
--         ["if"] = "@function.inner",
--         ["ac"] = "@class.outer",
--         ["ic"] = "@class.inner",
--       },
--     },
--   },
--   playground = {
--     enable = true,
--     disable = {},
--     updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
--     persist_queries = false, -- Whether the query persists across vim sessions
--     keybindings = {
--       toggle_query_editor = 'o',
--       toggle_hl_groups = 'i',
--       toggle_injected_languages = 't',
--       toggle_anonymous_nodes = 'a',
--       toggle_language_display = 'I',
--       focus_language = 'f',
--       unfocus_language = 'F',
--       update = 'R',
--       goto_node = '<cr>',
--       show_help = '?',
--     },
--   }
-- }

vim.api.nvim_exec([[
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
]], true)

-- hop
-- keymap('n', '<localleader>h', ':lua require("hop").hint_words()<cr>', 'hop to word')
-- keymap('v', '<localleader>h', ':lua require("hop").hint_words()<cr>')

-- local neorg_callbacks = require("neorg.callbacks")

-- neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
--     -- Map all the below keybinds only when the "norg" mode is active
--     keybinds.map_event_to_mode("norg", {
--         n = { -- Bind keys in normal mode
--             { "<C-s>", "core.integrations.telescope.find_linkable" },
--         },
--
--         i = { -- Bind in insert mode
--             { "<C-l>", "core.integrations.telescope.insert_link" },
--         },
--     }, {
--         silent = true,
--         noremap = true,
--     })
-- end)

-- function SetNeorgCallbacks(bufnr, tabnum_start)
--   local neorg_callbacks = require("neorg.callbacks")
--
--   neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
--       -- Map all the below keybinds only when the "norg" mode is active
--       keybinds.map_event_to_mode("norg", {
--           n = { -- Bind keys in normal mode
--               { "<C-s>", "core.integrations.telescope.find_linkable" },
--           },
--
--           i = { -- Bind in insert mode
--               { "<C-l>", "core.integrations.telescope.insert_link" },
--           },
--       }, {
--           silent = true,
--           noremap = true,
--       })
--   end)
-- end
--
-- local neorg_callbacks = require('neorg.callbacks')

-- neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
-- 	keybinds.map_event_to_mode("norg", {
-- 		n = {
-- 			{ neorg_leader .. "a", "utilities.dateinserter.my_keybind" },
-- 		},
-- 	}, { silent = true, noremap = true })
-- end)
-- local neorg_callbacks = require('neorg.callbacks')
-- neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
-- 	keybinds.map_event_to_mode("norg", {
--       n = {
--         { "<Leader>o" .. "p", "utilities.gtd_project_tags.views" },
--       },
--     }, { silent = true, noremap = true })
-- end)
-- cmd('nnoremap <Leader>op :Neorg gtd_project_tags 0 0 1<cr>')

-- require'lualine'.setup {
--   options = {
--     theme = 'sonokai'
--   }
-- }

cmd('colorscheme moonfly')
cmd('hi TreesitterContextBottom gui=underline guisp=Grey')
cmd("nnoremap <localleader>c m':lua require(\"treesitter-context\").go_to_context()<cr>")
-- vim.keymap.set("n", "<localleader>c", function()
--   require("treesitter-context").go_to_context()
-- end, { silent = true })

function FindExistingBuffer(bufnr, tabnum_start)

  local tabpage_handles = vim.api.nvim_list_tabpages()

  for _, tabpage_handle in pairs(tabpage_handles) do
    for _, winnr in pairs(vim.api.nvim_tabpage_list_wins(tabpage_handle)) do
      local win_bufnr = vim.api.nvim_win_get_buf(winnr)
      if bufnr == win_bufnr then
        return {tabpage_handle, winnr}
      end
    end
  end

  return nil
end

function GoToDefinitionInNewTab()
  vim.lsp.buf.definition()
  local winnr = vim.api.nvim_get_current_win()
  local row = vim.api.nvim_win_get_cursor(winnr)[1]
  local bufnr = vim.api.nvim_get_current_buf()

  local new_winnr = vim.api.nvim_get_current_win()
  local new_row, new_col = unpack(vim.api.nvim_win_get_cursor(new_winnr))
  local new_bufnr = vim.api.nvim_get_current_buf()

  local ct = 0
  while ct < 5 and winnr == new_winnr and row == new_row and bufnr == new_bufnr do
    vim.cmd("sleep 100m")
    ct = ct + 1
    new_winnr = vim.api.nvim_get_current_win()
    new_row, new_col = unpack(vim.api.nvim_win_get_cursor(new_winnr))
    new_bufnr = vim.api.nvim_get_current_buf()
  end

  if bufnr ~= new_bufnr then
    -- opened new file so move it to a new tab
    local bufnr = vim.api.nvim_get_current_buf()
    vim.cmd("pop")

    local info = FindExistingBuffer(bufnr, vim.api.nvim_tabpage_get_number(0))
    if info == nil then
      vim.cmd("tabnew")
      vim.api.nvim_win_set_buf(0, bufnr)
    else
      local tabpage_handle, winnr = unpack(info)

      while tabpage_handle ~= vim.api.nvim_get_current_tabpage() do
        vim.cmd("tabnext")
      end
      while new_bufnr ~= vim.api.nvim_get_current_buf() do
        vim.cmd([[execute "normal \<c-w>\<c-w>"]])
      end
    end
    vim.api.nvim_win_set_cursor(0, {new_row, new_col})
  end
end
cmd('nnoremap <localleader>s :lua GoToDefinitionInNewTab()<cr>')


-- extra highlights
-- vim.api.nvim_command('highlight default HopNextKey  guifg=#ff007c gui=bold ctermfg=198 cterm=bold')
-- vim.api.nvim_command('highlight default HopNextKey1  guifg=#ff007c gui=bold ctermfg=198 cterm=bold')
-- vim.api.nvim_command('highlight default HopNextKey2  guifg=#ff007c gui=bold ctermfg=198 cterm=bold')

vim.o.foldminlines = 5
vim.o.foldnestmax = 2

-- https://vi.stackexchange.com/a/34722
-- vim.g.terminal_color_2 = '#fffcf5'
-- vim.g.terminal_color_2 = '#373737'
-- https://github.com/neovim/neovim/issues/2897#issuecomment-115464516
-- vim.g.terminal_color_0  = '#2e3436'
-- vim.g.terminal_color_1  = '#cc0000'
vim.g.terminal_color_2  = '#4e9a06'
vim.g.terminal_color_2  = '#C68539'
vim.g.terminal_color_4  = '#397AC6'
vim.g.terminal_color_3  = '#846b00'
-- vim.g.terminal_color_3  = '#c4a000'
-- vim.g.terminal_color_4  = '#3465a4'
-- vim.g.terminal_color_5  = '#75507b'
-- vim.g.terminal_color_6  = '#0b939b'
-- vim.g.terminal_color_7  = '#d3d7cf'
-- vim.g.terminal_color_8  = '#555753'
-- vim.g.terminal_color_9  = '#ef2929'
-- vim.g.terminal_color_10 = '#8ae234'
-- vim.g.terminal_color_11 = '#fce94f'
-- vim.g.terminal_color_12 = '#729fcf'
-- vim.g.terminal_color_13 = '#ad7fa8'
-- vim.g.terminal_color_14 = '#00f5e9'
-- vim.g.terminal_color_15 = '#eeeeec'

vim.api.nvim_set_hl(0, "RenderMarkdownCode", {bg="#121212"})

require('lint').linters_by_ft = {
  cpp = {'cppcheck'},
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()

    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()

    -- You can call `try_lint` with a linter name or a list of names to always
    -- run specific linters, independent of the `linters_by_ft` configuration
    -- require("lint").try_lint("cspell")
  end,
})
