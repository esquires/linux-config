-- Setup nvim-cmp.
-- copied from
-- https://github.com/hrsh7th/nvim-cmp
local cmp = require'cmp'
local lspkind = require "lspkind"

cmp.setup({
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.close(),
    ["<C-y>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
    ["<C-q>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },

    ["<C-space>"] = cmp.mapping.complete(),
  },

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
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- local servers = { 'clangd', 'rust_analyzer', 'pylsp', 'tsserver' }
local servers = { 'pylsp' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

-- setup snippets
-- https://www.reddit.com/r/neovim/comments/qg4nyf/comment/hi8s8di/?utm_source=share&utm_medium=web2x&context=3
lspconfig.pylsp.setup {
  settings = {
    pylsp = {
      plugins = {
        jedi_completion = {
          include_params = true,
          enable = true,
        },
        pyls_mypy = {
          enabled = true,
          live_mode = false
        }
      },
    },
  },
}

vim.cmd [[
  imap <silent><expr> <c-k> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<c-k>'
  inoremap <silent> <c-j> <cmd>lua require('luasnip').jump(-1)<CR>

  imap <silent><expr> <C-l> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-l>'

  snoremap <silent> <c-k> <cmd>lua require('luasnip').jump(1)<CR>
  snoremap <silent> <c-j> <cmd>lua require('luasnip').jump(-1)<CR>
]]
