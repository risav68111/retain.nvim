local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local Path = require("plenary.path")
local fileDir = require("retain.fileWork")

local M = {}

--[[
local function get_subdirs(dir)
  local result = {}
  for _, entry in ipairs(vim.fn.readdir(dir)) do
    local full_path = dir .. "/" .. entry
    if vim.fn.isdirectory(full_path) == 1 then
      table.insert(result, full_path)
    end
  end
  return result
end
--]]

local dirs = fileDir.getList()

function M.cd_picker(opts)
  opts = opts or {}
  local cwd = opts.cwd or vim.loop.cwd()
  -- vim.notify("cd_picker")
  -- local dirs = get_subdirs(cwd)
  fileDir.appen(dirs)
  fileDir.saveCurrDir(dirs)

  pickers.new(opts, {
    prompt_title = "📁 Choose a Directory",
    finder = finders.new_table {
      results = dirs,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          vim.cmd("cd " .. selection[1])
          print("Changed directory to " .. selection[1])
        end
      end)
      return true
    end,
  }):find()
end

return M
