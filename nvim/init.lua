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
-- cmd('colorscheme wombat256A')

-- vimtex
vim.g.vimtex_view_general_viewer = 'okular'
vim.g.vimtex_view_general_options = '--unique file:@pdf#src:@line@tex'
vim.g.vimtex_compiler_latexmk = {
 build_dir = 'build',
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

-- leaders
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
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
-- todo: get InsertOnTerm working
cmd('tnoremap <M-[> <C-\\><C-n>')
cmd('nnoremap <C-h> <C-\\><C-n>gT:call InsertOnTerm()<cr>')
cmd('tnoremap <C-h> <C-\\><C-n>gT:call InsertOnTerm()<cr>')
cmd('nnoremap <C-l> <C-\\><C-n>gt:call InsertOnTerm()<cr>')
cmd('tnoremap <C-l> <C-\\><C-n>gt:call InsertOnTerm()<cr>')
cmd('tnoremap <M-w> <C-\\><C-n>w')
cmd('command! Newterm :tabnew | term')
cmd('nnoremap <localleader>o :tabo<cr>')

vim.opt.scrollback = 100000

-- lvdb
keymap('n', '<localleader>d', ':call lvdb#Python_debug()<cr>')
keymap('n', '<leader>n', ':call lines#ToggleNumber()<cr>')
vim.g.lvdb_toggle_lines = 3
vim.g.lvdb_close_tabs = 1

-- tagbar
keymap('n', '<localleader>t', ':TagbarToggle<CR>')

-- airline
-- cmd("let g:airline_extensions = ['tabline']")
-- cmd("let g:airline#extensions#tabline#enabled = 1")
-- cmd("let g:airline#extensions#tabline#tab_nr_type = 1")  -- tabnumber
-- cmd("let g:airline#extensions#tabline#formatter = 'unique_tail'")
-- cmd("let g:airline#extensions#tabline#show_splits = 0")
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
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
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
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
require('nvim-treesitter.configs').setup {
  ensure_installed = "all",
  highlight = { -- Be sure to enable highlights if you haven't!
    enable = true,
  },
  indent = {
    enable = true,
    disable = {"python",},  -- https://www.reddit.com/r/neovim/comments/ok9frp/v05_treesitter_does_anyone_have_python_indent/
  },
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
            colors = {
                "#ffffff", -- white
                "#cece32", -- dark yellow
                "#ff4040", -- red
                "#00ff00", -- green
                "#00ffff", -- blue
            },
    -- termcolors = {'white', 'Yellow', 'blue'} -- table of colour name strings
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
}

vim.api.nvim_exec([[
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
]], true)

-- hop
keymap('n', '<localleader>h', ':lua require("hop").hint_words()<cr>')
-- keymap('v', '<localleader>h', ':lua require("hop").hint_words()<cr>')

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

-- require'lualine'.setup {
--   options = {
--     theme = 'sonokai'
--   }
-- }
-- colorscheme sonokai
cmd('colorscheme moonfly')
-- vim.g.lightline.colorscheme = 'sonokai'
-- cmd('colorscheme wombat256A')
-- require('colorbuddy').colorscheme('gruvbuddy')

require "nvim-treesitter.configs".setup {
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}


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
  local winnr = vim.api.nvim_get_current_win()
  local row = vim.api.nvim_win_get_cursor(winnr)[1]
  local bufnr = vim.api.nvim_get_current_buf()

  vim.lsp.buf.definition()
  vim.cmd("sleep 100m")

  local new_winnr = vim.api.nvim_get_current_win()
  local new_row, new_col = unpack(vim.api.nvim_win_get_cursor(new_winnr))
  local new_bufnr = vim.api.nvim_get_current_buf()

  if bufnr == new_bufnr then
    if row == new_row then
      -- default to tags
      print('lsp did not find definition, reverting to ctags')
      vim.cmd("call tags#Open_tag_in_new_tab()")
    else
      -- opened in same file don't do anything else
    end

  else
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
vim.api.nvim_command('highlight default HopNextKey  guifg=#ff007c gui=bold ctermfg=198 cterm=bold')
vim.api.nvim_command('highlight default HopNextKey1  guifg=#ff007c gui=bold ctermfg=198 cterm=bold')
vim.api.nvim_command('highlight default HopNextKey2  guifg=#ff007c gui=bold ctermfg=198 cterm=bold')

require'hop.highlight'.insert_highlights()
