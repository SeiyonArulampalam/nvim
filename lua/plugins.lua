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
  -- { "savq/melange-nvim", name = 'melange', priority = 1000 },
  -- { "sainnhe/everforest", name = 'hard', priority = 1000 },
  { "catppuccin/nvim", name = "mocha", priority = 1000 },

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

  -- ── Formatting ────────────────────────────────────────────
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
  'onsails/lspkind.nvim',

  -- ── Function signature hints ──────────────────────────────
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

{
  'nvim-treesitter/nvim-treesitter-context',
  config = function()
    require('treesitter-context').setup({
      mode                = 'topline',
      multiline_threshold = 1,
    })
    vim.api.nvim_set_hl(0, 'TreesitterContextBottom', { underline = true, sp = 'Grey' })
  end,
},

  -- ── Symbol outline ────────────────────────────────────────
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
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('aerial').setup({
        on_attach = function(bufnr)
          vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
          vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
        end,
      })
      vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>', { desc = 'Toggle aerial' })
    end,
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

  -- ── Peek definition ───────────────────────────────────────
{
  'rmagatti/goto-preview',
  config = function()
    require('goto-preview').setup({
      width              = 120,
      height             = 30,
      border             = 'rounded',
      default_mappings   = false,
      dismiss_on_move    = false,
      preview_window_title = { enable = true },
      post_open_hook = function(buf, _)
        vim.keymap.set('n', 'q', '<cmd>quit<CR>', { buffer = buf, desc = 'Close preview' })
      end,
    })

    vim.keymap.set("n", "<leader>pd", require('goto-preview').goto_preview_definition,     { desc = 'Preview definition' })
    vim.keymap.set("n", "<leader>pi", require('goto-preview').goto_preview_implementation, { desc = 'Preview implementation' })
    vim.keymap.set("n", "<leader>pr", require('goto-preview').goto_preview_references,     { desc = 'Preview references' })
    vim.keymap.set("n", "<leader>pc", require('goto-preview').close_all_win,               { desc = 'Close preview windows' })
  end,
},
}

-- ── Lazy options ────────────────────────────────────────────
local opts = {
  ui = { icons = { start = '▷ ' } },
}

require('lazy').setup(plugins, opts)

-- ============================================================
--  Plugin setup
-- ============================================================

-- ── indent-blankline ────────────────────────────────────────
require('ibl').setup()

-- ── Trim trailing whitespace ─────────────────────────────────
require('trim').setup()

-- ── Comment ──────────────────────────────────────────────────
require('Comment').setup()

-- ── nvim-tree ────────────────────────────────────────────────
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors    = true
require('nvim-tree').setup()

-- ── Lualine ──────────────────────────────────────────────────
require('lualine').setup({
  options = {
    icons_enabled        = true,
    theme                = 'auto',
    component_separators = ' ',
    section_separators   = '',
  },
  sections = {
    lualine_a = { { 'filename' } },
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
    map('n', '<leader>hs', gs.stage_hunk,                                                       'Stage hunk')
    map('n', '<leader>hr', gs.reset_hunk,                                                       'Reset hunk')
    map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'Stage hunk')
    map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'Reset hunk')
    map('n', '<leader>hS', gs.stage_buffer,                                                     'Stage buffer')
    map('n', '<leader>hu', gs.undo_stage_hunk,                                                  'Undo stage hunk')
    map('n', '<leader>hR', gs.reset_buffer,                                                     'Reset buffer')
    map('n', '<leader>hp', gs.preview_hunk,                                                     'Preview hunk')
    map('n', '<leader>hb', function() gs.blame_line { full = true } end,                        'Blame line')
    map('n', '<leader>tb', gs.toggle_current_line_blame,                                        'Toggle blame')
    map('n', '<leader>hd', gs.diffthis,                                                         'Diff this')
    map('n', '<leader>hD', function() gs.diffthis('~') end,                                     'Diff this ~')
    map('n', '<leader>td', gs.toggle_deleted,                                                   'Toggle deleted')
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>',                                  'Select hunk')
  end,
})