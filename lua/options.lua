-- set vim options using a convenience neovim interface ``vim.opt''
-- see ``:help options'' for more information about vim options
-- see ``:help vim.opt'' for more information about the neovim interface

-- ref: https://martinlwx.github.io/en/config-neovim-from-scratch/#the-basics

-- Use system clipboard (e.g. yank selection to system clipboard)
vim.opt.clipboard = 'unnamedplus'

-- Tab
vim.opt.tabstop = 2                 -- number of visual spaces per TAB
vim.opt.shiftwidth = 2              -- insert 2 spaces on a tab
vim.opt.expandtab = true            -- tabs are spaces, mainly because of python


-- UI config
vim.opt.number = true               -- show absolute number
vim.opt.relativenumber = true       -- add numbers to each line on the left side
vim.opt.showmode = false            -- we are experienced, wo don't need the "-- INSERT --" mode hint
vim.opt.splitbelow = true           -- open new vertical split bottom
vim.opt.splitright = true           -- open new horizontal splits right
vim.opt.wrap = true
 -- vim.opt.colorcolumn = "80"            -- vertical line at 80

-- Searching
vim.opt.ignorecase = true           -- ignore case in searches by default
vim.opt.smartcase = true            -- but make it case sensitive if an uppercase is entered

-- Set the cursor line
vim.opt.cursorline = false

vim.opt.background = "dark" -- colorschemes that can be light or dark will be made dark
vim.opt.signcolumn = "yes" -- show sign column so that text doesn't shift
