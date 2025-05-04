local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

local M = {}

function M.open(title, items, on_select, opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = title or "Select Item",
    finder = finders.new_table {
      results = items or {},
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection and on_select then
          on_select(selection[1])
        end
      end)
      return true
    end,
  }):find()
end

return M

