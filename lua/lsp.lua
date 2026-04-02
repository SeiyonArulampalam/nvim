-- ============================================================
--  lsp.lua  —  Mason · LSP · Conform (formatting) · nvim-cmp
-- ============================================================

-- ── 1. Mason core ───────────────────────────────────────────
require('mason').setup()

require('mason-lspconfig').setup({
  ensure_installed = { 'lua_ls', 'pyright', 'clangd', 'cmake', 'julials' },
})

-- ── 2. Common on_attach (runs for every server) ─────────────
local on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
  end

  map('n', 'gd',         vim.lsp.buf.definition,      'Go to definition')
  map('n', 'gD',         vim.lsp.buf.declaration,     'Go to declaration')
  map('n', 'gi',         vim.lsp.buf.implementation,  'Go to implementation')
  map('n', 'gr',         vim.lsp.buf.references,      'List references')
  map('n', 'K',          vim.lsp.buf.hover,           'Hover docs')
  map('n', '<C-k>',      vim.lsp.buf.signature_help,  'Signature help')
  map('n', '<leader>rn', vim.lsp.buf.rename,          'Rename symbol')
  map('n', '<leader>ca', vim.lsp.buf.code_action,     'Code action')
  map('n', '[d',         vim.diagnostic.goto_prev,    'Prev diagnostic')
  map('n', ']d',         vim.diagnostic.goto_next,    'Next diagnostic')
  map('n', '<leader>e',  vim.diagnostic.open_float,   'Show diagnostic')
  map('n', '<leader>q',  vim.diagnostic.setloclist,   'Diagnostics → loclist')
end

-- ── 3. Capabilities ─────────────────────────────────────────
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- ── 4. Individual server configs ────────────────────────────
vim.lsp.config('lua_ls', {
  on_attach    = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime     = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim', 'require' } },
      workspace   = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry   = { enable = false },
    },
  },
})

vim.lsp.config('pyright', {
  on_attach    = on_attach,
  capabilities = capabilities,
})

vim.lsp.config('clangd', {
  on_attach    = on_attach,
  capabilities = capabilities,
  cmd = { 'clangd', '--offset-encoding=utf-16' },
})

vim.lsp.config('cmake', {
  on_attach    = on_attach,
  capabilities = capabilities,
})

vim.lsp.config('julials', {
  on_attach    = on_attach,
  capabilities = capabilities,
})

-- Enable all servers (mason-lspconfig may also do this automatically,
-- but being explicit here is harmless and clearer)
vim.lsp.enable({ 'lua_ls', 'pyright', 'clangd', 'cmake', 'julials' })

-- ── 5. Formatting with conform.nvim ─────────────────────────
require('conform').setup({
  formatters_by_ft = {
    python  = { 'black' },
    c       = { 'clang_format' },
    cpp     = { 'clang_format' },
    lua     = { 'stylua' },
  },
  format_on_save = {
    timeout_ms   = 500,
    lsp_fallback = true,
  },
})

-- ── 6. Diagnostic display tweaks ────────────────────────────
vim.diagnostic.config({
  virtual_text     = true,
  signs            = true,
  underline        = true,
  update_in_insert = false,
  severity_sort    = true,
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
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>']     = cmp.mapping.abort(),
    ['<CR>']      = cmp.mapping.confirm({ select = true }),

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

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'luasnip'  },
    { name = 'path'     },
  }, {
    { name = 'buffer', keyword_length = 5 },
  }),

  window = {
    completion    = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
    border = "rounded",
    winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
  },
})