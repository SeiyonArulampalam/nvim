local M = {}
local win, buf

M.toggle = function()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
    win = nil
    return
  end

  require('telescope.builtin').find_files({
    prompt_title = 'Pick Reference File',
    attach_mappings = function(prompt_bufnr, map)
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')

      actions.select_default:replace(function()
        actions.close(prompt_bufnr)

        local filepath = action_state.get_selected_entry().path
        buf = vim.fn.bufadd(filepath)
        vim.fn.bufload(buf)

        local width  = math.floor(vim.o.columns * 0.4)
        local height = math.floor(vim.o.lines * 0.85)
        local filename = vim.fn.fnamemodify(filepath, ':t')

        -- set the background color
        vim.api.nvim_set_hl(0, 'ReferenceFloat', { bg = '#303030' }) 

        win = vim.api.nvim_open_win(buf, false, {
            relative  = 'editor',
            anchor    = 'NE',
            row       = 2,
            col       = vim.o.columns - 2,
            width     = width,
            height    = height,
            style     = 'minimal',
            border    = 'rounded',
            title     = '  ' .. filename .. ' ',
            title_pos = 'center',
            zindex    = 50,
        })

        -- Padding and appearance
        vim.wo[win].wrap           = true
        vim.wo[win].number         = false
        vim.wo[win].relativenumber = true
        vim.wo[win].signcolumn     = 'no'
        vim.wo[win].winblend       = 50   -- slight transparency
        vim.wo[win].winhighlight   = 'Normal:ReferenceFloat,FloatBorder:FloatBorder'  -- ← point to custom group
      end)
      return true
    end,
  })
end

M.scroll_down = function()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_call(win, function() vim.cmd('normal! 5j') end)
  end
end

M.scroll_up = function()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_call(win, function() vim.cmd('normal! 5k') end)
  end
end

return M