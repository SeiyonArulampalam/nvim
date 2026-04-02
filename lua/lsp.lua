-- ============================================================
--  lsp.lua  —  Mason · LSP · Conform (formatting) · nvim-cmp
-- ============================================================

-- ── 1. Mason core ───────────────────────────────────────────
require('mason').setup()

require('mason-lspconfig').setup({
  ensure_installed = { 'lua_ls', 'pyright', 'clangd', 'cmake', 'julials' },
  automatic_installation = true,
})

-- ── 2. Common on_attach (runs for every server) ─────────────
--  Keymaps are buffer-local so they only fire when an LSP is active.
local on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
  end

  -- Navigation
  map('n', 'gd',         vim.lsp.buf.definition,      'Go to definition')
  map('n', 'gD',         vim.lsp.buf.declaration,     'Go to declaration')
  map('n', 'gi',         vim.lsp.buf.implementation,  'Go to implementation')
  map('n', 'gr',         vim.lsp.buf.references,      'List references')
  map('n', 'K',          vim.lsp.buf.hover,           'Hover docs')
  map('n', '<C-k>',      vim.lsp.buf.signature_help,  'Signature help')

  -- Actions
  map('n', '<leader>rn', vim.lsp.buf.rename,          'Rename symbol')
  map('n', '<leader>ca', vim.lsp.buf.code_action,     'Code action')

  -- Diagnostics
  map('n', '[d',         vim.diagnostic.goto_prev,    'Prev diagnostic')
  map('n', ']d',         vim.diagnostic.goto_next,    'Next diagnostic')
  map('n', '<leader>e',  vim.diagnostic.open_float,   'Show diagnostic')
  map('n', '<leader>q',  vim.diagnostic.setloclist,   'Diagnostics → loclist')
end

-- ── 3. Capabilities (advertise nvim-cmp completions to LSP) ─
--  Without this servers won't send snippet / full completion data.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- ── 4. Individual server configs ────────────────────────────
local lspconfig = require('lspconfig')

lspconfig.lua_ls.setup({
  on_attach    = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime    = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim', 'require' } },
      workspace  = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry  = { enable = false },
    },
  },
})

lspconfig.pyright.setup({
  on_attach    = on_attach,
  capabilities = capabilities,
})

lspconfig.clangd.setup({
  on_attach    = on_attach,
  capabilities = capabilities,
  cmd = { 'clangd', '--offset-encoding=utf-16' },
})

lspconfig.cmake.setup({
  on_attach    = on_attach,
  capabilities = capabilities,
})

lspconfig.julials.setup({
  on_attach    = on_attach,
  capabilities = capabilities,
})

-- ── 5. Formatting with conform.nvim (replaces null-ls) ──────
--  Mason can install the underlying binaries (black, clang-format).
--  Run :Mason and install them manually, or add mason-conform if
--  you want automatic installation.
require('conform').setup({
  formatters_by_ft = {
    python  = { 'black' },
    c       = { 'clang_format' },
    cpp     = { 'clang_format' },
    lua     = { 'stylua' },        -- optional: install stylua via Mason
  },
  format_on_save = {
    timeout_ms   = 500,
    lsp_fallback = true,           -- fall back to LSP formatter if none found
  },
})

-- ── 6. Diagnostic display tweaks ────────────────────────────
vim.diagnostic.config({
  virtual_text   = true,
  signs          = true,
  underline      = true,
  update_in_insert = false,        -- don't spam diagnostics while typing
  severity_sort  = true,
  float = {
    border = 'rounded',
    source = 'always',
  },
})

-- ── 7. Autocompletion ───────────────────────────────────────
require('luasnip.loaders.from_vscode').lazy_load()

local cmp     = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ['<C-d>']     = cmp.mapping.scroll_docs(-4),
    ['<C-f>']     = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),       -- <C-CR> is unreliable in terminals
    ['<C-e>']     = cmp.mapping.abort(),
    ['<CR>']      = cmp.mapping.confirm({ select = true }),

    -- Tab: cycle completions OR jump luasnip placeholders
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),

  -- Grouped sources: first group is preferred; buffer kicks in as fallback.
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'luasnip'  },
    { name = 'path'     },
  }, {
    { name = 'buffer', keyword_length = 5 },
  }),

  -- Nicer completion window
  window = {
    completion    = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})