-- Setup nvim-cmp.
-- copied from
-- https://github.com/hrsh7th/nvim-cmp
local cmp = require'cmp'
local lspkind = require "lspkind"

local __under = function(entry1, entry2)
  -- https://github.com/lukas-reineke/cmp-under-comparator
  local _, entry1_under = entry1.completion_item.label:find "^_+"
  local _, entry2_under = entry2.completion_item.label:find "^_+"
  entry1_under = entry1_under or 0
  entry2_under = entry2_under or 0
  if entry1_under > entry2_under then
    return false
  elseif entry1_under < entry2_under then
    return true
  end
end

cmp.setup({
  sorting = {
    comparators = {
      -- __under,
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      -- compare.scopes,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      -- compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },

  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<c-k>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    -- https://githubmemory.com/index.php/repo/hrsh7th/nvim-cmp/issues/809
    ['<c-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<c-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
  }),

  sources = cmp.config.sources({
    { name = 'luasnip' }, -- For luasnip users.
    { name = 'nvim_lsp' },
    { name = 'path' },
  }, {
    { name = 'buffer' },
    { name = 'nvim_lua' },
    { name = 'neorg'}
  }),

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },

  -- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/after/plugin/completion.lua
  formatting = {
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        buffer = "[buf]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[api]",
        path = "[path]",
        luasnip = "[snip]",
        gh_issues = "[issues]",
      },
    },
  },

  experimental = {
    -- I like the new menu better! Nice work hrsh7th
    native_menu = false,

    -- Let's play with this for a day or two
    ghost_text = false,
  },

})

-- Use buffer source for `/`.
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup lspconfig.
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- local servers = { 'clangd', 'pyright'}
local servers = { 'clangd', 'pylsp' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', '<leader>ld', vim.lsp.buf.declaration, { buffer = ev.buf, desc = 'func declaration'})
    vim.keymap.set('n', '<leader>lD', vim.lsp.buf.definition, { buffer = ev.buf, desc = 'func definition'})
    vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover, {buffer = ev.buf, desc = 'hover'})
    vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation, {buffer = ev.buf, desc = 'implementation'})
    vim.keymap.set('n', '<leader>ls', vim.lsp.buf.signature_help, {buffer = ev.buf, desc = 'signature'})
    vim.keymap.set('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, {buffer = ev.buf, desc = 'add workspace folder'})
    vim.keymap.set('n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder, {buffer = ev.buf, desc = 'rm workspace folder'})
    vim.keymap.set('n', '<leader>lwp', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, {buffer = ev.buf, desc = 'list workspace folder'})
    vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, {buffer = ev.buf, desc = 'type definition'})
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, {buffer = ev.buf, desc = 'buf rename'})
    vim.keymap.set({ 'n', 'v' }, '<leader>lc', vim.lsp.buf.code_action, {buffer = ev.buf, desc = 'code action'})
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.references, {buffer = ev.buf, desc='references'})
    vim.keymap.set('n', '<leader>lf', function()
      vim.lsp.buf.format { async = true }
    end, {buffer = ev.buf, desc = 'format'})
  end,
})

-- https://www.reddit.com/r/neovim/comments/qg4nyf/comment/hi8s8di/?utm_source=share&utm_medium=web2x&context=3
lspconfig.pylsp.setup {
  filetypes = {"python"},
  capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
  settings = {
    pylsp = {
      plugins = {
        jedi_completion = {
          include_params = true,
          enabled = true,
          fuzzy = true,
        },
        jedi_definition = {
          enabled = true,
        },
        jedi_hover = {
          enabled = true,
        },
        pylsp_mypy = {
          enabled = true,
          live_mode = false,
          dmypy = false,
          strict = true,
          overrides = {'--disallow-untyped-defs', '--ignore-missing-imports', true},
        },
        -- pydocstyle = {
        --   enabled = true,
        --   ignore = {'D1', 'D203', 'D213', 'D416'},
        -- },
        pylint = {
          enabled = true,
          args = {'--rcfile=' .. os.getenv("HOME") .. '/repos/linux-config/.pylintrc'}
        },
        flake8 = {
          enabled = true,
        },
      },
    },
  },
}

require('lspconfig').clangd.setup {
  cmd = {
    "clangd",
    "--clang-tidy",
    "--enable-config",
    "--suggest-missing-includes",
  },
  filetypes = {"c", "cpp", "objc", "objcpp"},
}

-- require'lspconfig'.gopls.setup()
require "lsp_signature".setup({
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = "rounded",
  },
  -- transparency = 20,
})

vim.cmd [[
  imap <silent><expr> <c-k> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<c-k>'
  inoremap <silent> <c-j> <cmd>lua require('luasnip').jump(-1)<CR>

  imap <silent><expr> <C-l> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-l>'

  snoremap <silent> <c-k> <cmd>lua require('luasnip').jump(1)<CR>
  snoremap <silent> <c-j> <cmd>lua require('luasnip').jump(-1)<CR>
]]

-- other settings
-- cmd('nnoremap <localleader>f :lua vim.lsp.buf.formatting()<cr>')
-- cmd('nnoremap <localleader>s :lua vim.lsp.buf.definition()<cr>')

