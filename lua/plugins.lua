-- ============================================================
--  plugins.lua  —  lazy.nvim bootstrap + plugin specs + setup
-- ============================================================

-- ── Bootstrap lazy.nvim ─────────────────────────────────────
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Must be set before lazy loads so mappings work correctly
vim.g.mapleader = ' '

-- ============================================================
--  Plugin specs
-- ============================================================
local plugins = {

  -- ── Colorscheme ───────────────────────────────────────────
  -- { 'rebelot/kanagawa.nvim', name = 'kanagawa', priority = 1000 },
  { "savq/melange-nvim", name = 'melange', priority = 1000 },

  -- ── Core utilities ────────────────────────────────────────
  'nvim-lua/plenary.nvim',

  -- ── Fuzzy finder ──────────────────────────────────────────
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- ── Keybinding hints ──────────────────────────────────────
  'folke/which-key.nvim',

  -- ── LSP ───────────────────────────────────────────────────
  'neovim/nvim-lspconfig',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  -- null-ls REMOVED (archived 2023) → replaced by conform.nvim below

  -- ── Formatting (replaces null-ls) ─────────────────────────
  --  Install formatters via :Mason  (black, clang-format, stylua)
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    opts = {
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
    },
  },

  -- ── Autocompletion ────────────────────────────────────────
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-nvim-lsp',
  'L3MON4D3/LuaSnip',
  'saadparwaiz1/cmp_luasnip',
  'rafamadriz/friendly-snippets',

  -- ── Function signature hints ──────────────────────────────
  --  Config lives here in opts — do NOT call setup() again below.
  {
    'ray-x/lsp_signature.nvim',
    event = 'InsertEnter',
    opts = {
      bind             = true,
      doc_lines        = 10,
      max_height       = 12,
      max_width        = 80,
      floating_window  = true,
      floating_window_above_cur_line = true,
      hint_enable      = true,
      hint_prefix      = '→ ',
      hint_scheme      = 'String',
      hi_parameter     = 'LspSignatureActiveParameter',
      handler_opts     = { border = 'rounded' },
      toggle_key       = '<M-x>',
      select_signature_key = '<M-n>',
      always_trigger   = false,
      close_timeout    = 4000,
      zindex           = 200,
      timer_interval   = 200,
    },
  },

  -- ── Git ───────────────────────────────────────────────────
  'lewis6991/gitsigns.nvim',

  -- ── File explorer + icons ─────────────────────────────────
  'nvim-tree/nvim-tree.lua',
  'nvim-tree/nvim-web-devicons',

  -- ── Statusline ────────────────────────────────────────────
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  -- ── Tabs ──────────────────────────────────────────────────
  'romgrk/barbar.nvim',

  -- ── Winbar breadcrumbs ────────────────────────────────────
  {
    'utilyre/barbecue.nvim',
    name         = 'barbecue',
    version      = '*',
    dependencies = { 'SmiteshP/nvim-navic', 'nvim-tree/nvim-web-devicons' },
    opts         = {},
  },

  -- ── Treesitter ────────────────────────────────────────────
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  },
  'nvim-treesitter/nvim-treesitter-context',

  -- ── Symbol outline ────────────────────────────────────────
  --  symbols-outline.nvim was archived; outline.nvim is the active fork.
  {
    'hedyhli/outline.nvim',
    cmd  = { 'Outline', 'OutlineOpen' },
    keys = { { '<leader>o', '<cmd>Outline<CR>', desc = 'Toggle outline' } },
    opts = {
      keymaps = { close = { 'q', '<Esc>' } },
    },
  },

  -- ── Aerial (symbol navigator) ─────────────────────────────
  {
    'stevearc/aerial.nvim',
    opts         = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  },

  -- ── Diagnostics panel ─────────────────────────────────────
  {
    'folke/trouble.nvim',
    opts = {},
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>',              desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>',      desc = 'Symbols (Trouble)' },
      { '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP (Trouble)' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>',                  desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>',                   desc = 'Quickfix List (Trouble)' },
    },
  },

  -- ── Annotation generator ──────────────────────────────────
  { 'danymat/neogen', config = true },

  -- ── Indent guides ─────────────────────────────────────────
  'lukas-reineke/indent-blankline.nvim',

  -- ── Utilities ─────────────────────────────────────────────
  'cappyzawa/trim.nvim',
  'numToStr/Comment.nvim',
}

-- ── Lazy options ────────────────────────────────────────────
local opts = {
  ui = { icons = { start = '▷ ' } },
}

require('lazy').setup(plugins, opts)

-- ============================================================
--  Plugin setup
--  (only plugins that can't be fully configured via `opts` above)
-- ============================================================

-- ── indent-blankline ────────────────────────────────────────
require('ibl').setup()

-- ── Trim trailing whitespace ─────────────────────────────────
require('trim').setup()

-- ── Comment ──────────────────────────────────────────────────
require('Comment').setup()

-- ── nvim-tree ────────────────────────────────────────────────
vim.g.loaded_netrw       = 1   -- disable netrw in favour of nvim-tree
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors    = true
require('nvim-tree').setup()

-- ── Lualine ──────────────────────────────────────────────────
require('lualine').setup({
  options = {
    icons_enabled       = true,
    theme               = 'auto',
    component_separators = ' ',
    section_separators  = '',
  },
  sections = {
    lualine_a = { { 'filename' } ,
},
  },
})

-- ── Gitsigns ─────────────────────────────────────────────────
require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
    end

    -- Navigation
    map('n', ']c', function() if vim.wo.diff then vim.cmd.normal({']c', bang=true}) else gs.nav_hunk('next') end end, 'Next hunk')
    map('n', '[c', function() if vim.wo.diff then vim.cmd.normal({'[c', bang=true}) else gs.nav_hunk('prev') end end, 'Prev hunk')

    -- Actions
    map('n', '<leader>hs', gs.stage_hunk,                                                     'Stage hunk')
    map('n', '<leader>hr', gs.reset_hunk,                                                     'Reset hunk')
    map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'Stage hunk')
    map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'Reset hunk')
    map('n', '<leader>hS', gs.stage_buffer,                                                   'Stage buffer')
    map('n', '<leader>hu', gs.undo_stage_hunk,                                                'Undo stage hunk')
    map('n', '<leader>hR', gs.reset_buffer,                                                   'Reset buffer')
    map('n', '<leader>hp', gs.preview_hunk,                                                   'Preview hunk')
    map('n', '<leader>hb', function() gs.blame_line { full = true } end,                      'Blame line')
    map('n', '<leader>tb', gs.toggle_current_line_blame,                                      'Toggle blame')
    map('n', '<leader>hd', gs.diffthis,                                                       'Diff this')
    map('n', '<leader>hD', function() gs.diffthis('~') end,                                   'Diff this ~')
    map('n', '<leader>td', gs.toggle_deleted,                                                  'Toggle deleted')
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>',                                'Select hunk')
  end,
})

-- ── Treesitter ───────────────────────────────────────────────
require('nvim-treesitter.configs').setup({
  ensure_installed = { 'c', 'cpp', 'python', 'bash', 'lua' },
  sync_install     = false,
  highlight        = { enable = true },
  disable = function(_, buf)
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    return ok and stats and stats.size > 100 * 1024  -- skip files > 100 KB
  end,
})

require('treesitter-context').setup({
  mode                = 'topline',
  multiline_threshold = 1,
})
vim.api.nvim_set_hl(0, 'TreesitterContextBottom', { underline = true, special = 'Grey' })

-- ── Aerial ───────────────────────────────────────────────────
require('aerial').setup({
  on_attach = function(bufnr)
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
  end,
})
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>', { desc = 'Toggle aerial' })

-- ── Kanagawa colorscheme ─────────────────────────────────────
-- require('kanagawa').setup({
--   -- Uncomment to customise:
--   theme      = 'dragon',
--   -- transparent = true,
--   -- background = { dark = 'dragon', light = 'lotus' },
-- })