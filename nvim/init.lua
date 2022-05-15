-- packer configuration
require("plugins")

-- helper functions
cmd = vim.api.nvim_command
function keymap(mode, src, dst)
    vim.api.nvim_set_keymap(mode, src, dst, { noremap = true})
end

-- Setup nvim-cmp.
require('lsp')

-- setup snippets
require("snippets")

-- colors
cmd('colorscheme wombat256A')

-- leaders
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.titlestring = "%:t"

-- settings
cmd('nnoremap / /\\v')
cmd('nnoremap ? ?\\v')
vim.opt.smartcase = true

vim.opt.title = true
vim.opt.cmdheight= 2
cmd('nnoremap <localleader>q :q<cr>')

vim.opt.bs = '2'
vim.opt.conceallevel = 2
vim.opt.concealcursor = ''
vim.opt.wildmode = 'list,full'
vim.opt.termguicolors = true

-- terminal settings
-- todo: get InsertOnTerm working
cmd('tnoremap <M-[> <C-\\><C-n>')
cmd('nnoremap <C-h> <C-\\><C-n>gT:call InsertOnTerm()<cr>')
cmd('tnoremap <C-h> <C-\\><C-n>gT:call InsertOnTerm()<cr>')
cmd('nnoremap <C-l> <C-\\><C-n>gt:call InsertOnTerm()<cr>')
cmd('tnoremap <C-l> <C-\\><C-n>gt:call InsertOnTerm()<cr>')
cmd('tnoremap <M-w> <C-\\><C-n>w')
cmd('command! Newterm :tabnew | term')
vim.opt.scrollback = 100000

-- lvdb
keymap('n', '<localleader>d', ':call lvdb#Python_debug()<cr>')
keymap('n', '<leader>n', ':call lines#ToggleNumber()<cr>')
vim.g.lvdb_toggle_lines = 3
vim.g.lvdb_close_tabs = 1

-- tagbar
keymap('n', '<localleader>t', ':TagbarToggle<CR>')

-- airline
cmd("let g:airline_extensions = ['tabline']")
cmd("let g:airline#extensions#tabline#enabled = 1")
cmd("let g:airline#extensions#tabline#tab_nr_type = 1")  -- tabnumber
cmd("let g:airline#extensions#tabline#formatter = 'unique_tail'")
cmd("let g:airline#extensions#tabline#show_splits = 0")

-- fugitive
keymap('n', '<localleader>gs', ':G<cr>}jj<c-w>H')
keymap('n', '<localleader>gb', ':Git blame<cr>')
keymap('n', '<localleader>gt', ':Git commit<cr>')
keymap('n', '<localleader>gl', ':Gclog --pretty=format:"%h %ad %s %d [%an]" --decorate --date=short -100 --graph<cr>')
keymap('n', '<localleader>gd', ':Gdiffsplit<cr>')
keymap('n', '<localleader>gco', ':Git checkout ')
keymap('n', '<localleader>gp', ':Git push origin HEAD<cr>')

-- wordmotion
cmd("let g:wordmotion_mappings = {'W': '', 'B': '', 'E': ''}")

-- telescope
-- https://github.com/nvim-telescope/telescope-fzf-native.nvim
-- https://dev.to/dlains/create-your-own-vim-commands-415b
require('telescope').load_extension('fzf')
keymap('n', '<leader>ff', ":FindFiles ")
keymap('n', '<leader>fg', ":lua GitFindFilesHelper(false)<cr>")
keymap('n', '<leader>fG', ":lua GitFindFilesHelper(true)<cr>")
keymap('n', '<leader>fb', ":lua require('telescope.builtin').buffers({ignore_current_buffer=true})<cr>")
keymap('n', '<leader>fr', ":LiveGrep ")
keymap('n', '=', "za")

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

function _G.put(...)
  -- https://github.com/nanotee/nvim-lua-guide
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

-- neorg
local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

parser_configs.norg = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg",
    files = { "src/parser.c", "src/scanner.cc" },
    branch = "main"
  },
}

parser_configs.norg_meta = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
    files = { "src/parser.c" },
    branch = "main"
  },
}

parser_configs.norg_table = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
    files = { "src/parser.c" },
    branch = "main"
  },
}

require('nvim-treesitter.configs').setup {
  ensure_installed = { "norg", "cpp", "c", "python", "lua" },
  highlight = { -- Be sure to enable highlights if you haven't!
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gs",
      node_incremental = "gni",
      node_decremental = "gnd",
      scope_incremental = "gsi",
      scope_decremental = "gsd",
    },
  },
  indent = {
    enable = true,
    disable = {"python",},  -- https://www.reddit.com/r/neovim/comments/ok9frp/v05_treesitter_does_anyone_have_python_indent/
  }
}

vim.api.nvim_exec([[
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
]], true)

require('neorg').setup {
  load = {
    ["core.defaults"] = {}, -- Load all the default modules
    ["core.norg.concealer"] = { config = { markup_preset = "conceal" } },
    ["core.norg.esupports.metagen"] = {config = {type = "auto"}},
    ["core.presenter"] = {config = {zen_mode = "zen-mode"}},
    ["core.export"] = {config = {extensions = "all"}},
    ["core.export.markdown"] = {
        config = {
            extensions = "all",
        }
    },
    ["core.norg.dirman"] = { -- Manage your directories with Neorg
      config = {
        workspaces = { my_workspace = "~/norg" },
        autochdir = true,
      }
    },
    ["core.norg.completion"] = { config = { engine = "nvim-cmp" } },
    ["core.gtd.base"] = {
      config = {
        displayers = { projects = { }, },
        workspace = "my_workspace"
      },
    },
    ["core.gtd.ui"] = {},
    ["core.keybinds"] = { -- Configure core.keybinds
      config = {
        default_keybinds = true, -- Generate the default keybinds
        neorg_leader = "<Leader>o" 
      }
    },
    ["core.norg.qol.toc"] = {},
    ["external.gtd-project-tags"] = {},
    ["core.integrations.telescope"] = {}
  },
}

local neorg_callbacks = require("neorg.callbacks")

neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
    -- Map all the below keybinds only when the "norg" mode is active
    keybinds.map_event_to_mode("norg", {
        n = { -- Bind keys in normal mode
            { "<C-s>", "core.integrations.telescope.find_linkable" },
        },

        i = { -- Bind in insert mode
            { "<C-l>", "core.integrations.telescope.insert_link" },
        },
    }, {
        silent = true,
        noremap = true,
    })
end)


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
cmd('nnoremap <Leader>op :Neorg gtd_project_tags 0 0 1<cr>')
