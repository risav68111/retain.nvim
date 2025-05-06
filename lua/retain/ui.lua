local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local previewers = require("telescope.previewers")
local Job = require("plenary.job")

local M = {}

-- Custom previewer to show directory contents
local function dirPreview()
  return previewers.new_buffer_previewer({
    title = "Directory Contents",
    define_preview = function(self, entry, _)
      local dir = entry.value
      if vim.fn.isdirectory(dir) == 1 then
        Job:new({
          command = "ls",
          args = { "-lah", dir },
          on_exit = function(j)
            local output = j:result()
            vim.schedule(function()
              vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, output)
            end)
          end,
        }):start()
      else
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { "Not a directory" })
      end
    end,
  })
end

function M.open(title, items, on_select, opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = title or "Select Item",
    finder = finders.new_table {
      results = items or {},
    },
    sorter = conf.generic_sorter(opts),
    previewer = dirPreview(),
    layout_config = {
      horizontal = { preview_width = 0.5 }, -- adjust as needed
    },
    layout_strategy = "horizontal",
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

