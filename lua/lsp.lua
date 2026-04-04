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
local lspkind = require('lspkind')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  performance = {
    debounce         = 60,
    throttle         = 30,
    fetching_timeout = 500,
    max_view_entries = 15,
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

  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = lspkind.cmp_format({
      mode         = "symbol_text",
      maxwidth     = 50,
      ellipsis_char = "…",
      menu = {
        nvim_lsp = "[LSP]",
        luasnip  = "[Snip]",
        nvim_lua = "[Lua]",
        buffer   = "[Buf]",
        path     = "[Path]",
      },
    }),
  },

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'luasnip'  },
    { name = 'path'     },
  }, {
    { name = 'buffer', keyword_length = 5 },
  }),

  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      function(a, b)
        local a_under = (a.completion_item.label:find("^_") ~= nil)
        local b_under = (b.completion_item.label:find("^_") ~= nil)
        if a_under ~= b_under then return not a_under end
      end,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },

  window = {
    completion = cmp.config.window.bordered({
      border       = "rounded",
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
      scrollbar    = false,
    }),
    documentation = cmp.config.window.bordered({
      border       = "rounded",
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
      scrollbar    = false,
    }),
  },

  experimental = {
    ghost_text = { hl_group = "Comment" },
  },
})

-- ── 8. Semantic token highlight overrides ───────────────────
local function set_semantic_highlights()
  vim.api.nvim_set_hl(0, '@lsp.type.namespace',     { link = '@module' })
  vim.api.nvim_set_hl(0, '@lsp.type.module',        { bold = true, fg = '#e8b45f' })
  vim.api.nvim_set_hl(0, '@lsp.type.class',         { fg = '#7fbfff', bold = true })
  vim.api.nvim_set_hl(0, '@lsp.type.interface',     { fg = '#7fbfff', italic = true })
  vim.api.nvim_set_hl(0, '@lsp.type.enum',          { fg = '#c0a060' })
  vim.api.nvim_set_hl(0, '@lsp.type.enumMember',    { fg = '#b8d7a3' })
  vim.api.nvim_set_hl(0, '@lsp.type.parameter',     { italic = true })
  vim.api.nvim_set_hl(0, '@lsp.type.property',      { fg = '#9cdcfe' })
  vim.api.nvim_set_hl(0, '@lsp.type.type',          { fg = '#4ec9b0' })
  vim.api.nvim_set_hl(0, '@lsp.mod.readonly',       { italic = true })
  vim.api.nvim_set_hl(0, '@lsp.mod.deprecated',     { strikethrough = true })
  vim.api.nvim_set_hl(0, '@lsp.mod.defaultLibrary', { italic = true })
end

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '*.py', '*.c', '*.cpp', '*.lua', '*.sh', '*.cmake' },
  callback = function()
    local ok, _ = pcall(vim.treesitter.start)
    if not ok then return end
  end,
})
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = set_semantic_highlights,
})

-- Only run after colorscheme has already loaded
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = set_semantic_highlights,
})