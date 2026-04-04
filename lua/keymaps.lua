-- Ref: https://martinlwx.github.io/en/config-neovim-from-scratch/#the-basics
-- Hint: see `:h vim.keymap.set()`

-- define common options
local opts = {
    noremap = true,      -- non-recursive
    silent = false,      -- do show message
}

-----------------
-- Normal mode --
-----------------

-- Better window splitting: (Aaron)
-- use tmux-like keymapping (prefix + |-) to split vertically and horizontally
-- vim.keymap.set('n', '<C-w>|', ':vsplit<Enter>', opts)
-- vim.keymap.set('n', '<C-w>-', ':split<Enter>', opts)

-- Window maganement
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window


-- Better window navigation: use CTRL + hjkl to navigate between splits
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- Plugin: telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, opts)
vim.keymap.set('n', '<leader>ff', builtin.find_files, vim.tbl_extend("force", opts, {desc = "Find files"}))
vim.keymap.set('n', '<leader>fg', builtin.live_grep, vim.tbl_extend("force", opts, {desc = "Live grep"}))
vim.keymap.set('n', '<leader>fb', builtin.buffers, vim.tbl_extend("force", opts, {desc = "Buffer"}))
vim.keymap.set('n', '<leader>fh', builtin.help_tags, vim.tbl_extend("force", opts, {desc = "Help tags"}))
builtin = nil

-- move between tabs
vim.keymap.set('n', 'tn', ':tabnext<Enter>', opts)
vim.keymap.set('n', 'tp', ':tabprevious<Enter>', opts)

-- go to definition/declaration by LSP
vim.keymap.set("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<Enter>", opts)
vim.keymap.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<Enter>", opts)

-- open/close nvim-tree (´ is shift + option + e on Mac)
-- vim.keymap.set("n", "´", ":NvimTreeToggle<Enter>", opts)

-- refresh the file explorer
vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
vim.keymap.set("n", "<leader>ex", ":NvimTreeToggle<Enter>", vim.tbl_extend("force", opts, {desc = "Close file explorer"}))

-- refernce window lua
local ref = require('reference')
vim.keymap.set('n', '<leader>rp', ref.toggle,      { desc = 'Toggle reference panel' })
vim.keymap.set('n', '<leader>rj', ref.scroll_down, { desc = 'Scroll reference down' })
vim.keymap.set('n', '<leader>rk', ref.scroll_up,   { desc = 'Scroll reference up' })