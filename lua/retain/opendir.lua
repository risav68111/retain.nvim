local M = {}

function M.cdNew(newFile)
  vim.cmd("Explore " .. newFile)
end


function M.cdVNew(newFile)
  vim.cmd("Vexplore " .. newFile)
end

function M.cdSNew(newFile)
  vim.cmd("Sexplore " .. newFile)
end

return M

