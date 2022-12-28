-- Setup nvim-cmp.
-- copied from
-- https://github.com/hrsh7th/nvim-cmp
local cmp = require'cmp'
local lspkind = require "lspkind"

cmp.setup({
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
    ghost_text = true,
  },

})

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' },
  }
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
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

-- https://www.reddit.com/r/neovim/comments/qg4nyf/comment/hi8s8di/?utm_source=share&utm_medium=web2x&context=3
lspconfig.pylsp.setup {
  filetypes = {"python"},
  capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
  settings = {
    -- https://github.com/neovim/nvim-lspconfig/issues/903
    formatCommand = {"black"},
    pylsp = {
      plugins = {
        jedi_completion = {
          include_params = true,
          enable = true,
        },
        pylsp_mypy = {
          enabled = true,
          live_mode = false,
          dmypy = true,
          strict = true,
          overrides = {'--disallow-untyped-defs', '--ignore-missing-imports', true},
        },
        pydocstyle = {
          enabled = true,
          ignore = {'D1', 'D203', 'D213', 'D416'},
        },
        pylint = {
          enabled = true,
          args = {'--rcfile=' .. os.getenv("HOME") .. '/repos/linux-config/.pylintrc'}
        },
        flake8 = {
          enabled = true,
        },
        black = {
          enabled = true,
          cache_config = true,
          line_length = 79,
        }
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

vim.cmd [[
  imap <silent><expr> <c-k> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<c-k>'
  inoremap <silent> <c-j> <cmd>lua require('luasnip').jump(-1)<CR>

  imap <silent><expr> <C-l> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-l>'

  snoremap <silent> <c-k> <cmd>lua require('luasnip').jump(1)<CR>
  snoremap <silent> <c-j> <cmd>lua require('luasnip').jump(-1)<CR>
]]

-- other settings
cmd('nnoremap <localleader>f :lua vim.lsp.buf.formatting()<cr>')
-- cmd('nnoremap <localleader>s :lua vim.lsp.buf.definition()<cr>')

