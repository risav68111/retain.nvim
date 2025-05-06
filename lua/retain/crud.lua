local M = {}

local home_dir = vim.fn.expand("~")                -- home directory
local curr_dir = vim.fn.getcwd() or vim.loop.cwd() -- current directory

function M.isWin()
  if string.find(home_dir, "C:\\Users\\") then
    return true
  end
  return false
end

-- LOL What is this KEKW
-- local aft_home = isWin() and "AppData\\Local\\nvim-data\\retain-list" or ".config/nvim-data/retain-list"
-- local file_path = home_dir .. "\\" .. aft_home

local file_path = vim.fn.stdpath("data") .. "/retain"
local file_name = "directory-list.lua"
local file_dir = file_path .. "\\" .. file_name

-- print(string.format("%q \n %q \n %q \n %q \n ",  home_dir, aft_home, file_path, file_name))

function M.createFileAndDirectory()
  vim.fn.mkdir(file_path, "p")
  local dirs = io.open(file_dir, "w")
  if dirs then
    dirs:write("return {\n")
    dirs:write("%q,\n", vim.fn.getcwd())
    dirs:write("}\n")
    dirs:write("-- lastLine")
    dirs:close()
  end
end

function M.fileExists()
  local f = io.open(file_dir, "r")
  if f then
    return true
  end
  return false
end

function M.isThere(dirs, c_dir)
  for _, val in ipairs(dirs) do
    if string.lower(val) == string.lower(c_dir) then
      return true
    end
  end
  return false
end

function M.appen(dirs)
  local c_cwd = vim.fn.getcwd()
  if dirs == nil then
    dirs = {}
  end
  if M.isThere(dirs, c_cwd) then
    return
  end
  table.insert(dirs, c_cwd)
end

function M.getList()
  if not M.fileExists() then
    M.createFileAndDirectory()
    return {}
  end
  local ok, data = pcall(dofile, file_dir)
  local dirs     = ok and data or {}
  M.appen(dirs)
  return dirs
end


function M.saveCurrDir(dirs)
  -- vim.notify(" saveCurrDir called")
  if type(dirs) ~= "table" then
    vim.notify("Invalid Dirs: " .. type(dirs))
  end
  local f = io.open(file_dir, 'w')
  if not f then
    M.createFileAndDirectory()
    return
  end
  f:write("return {\n")
  for _, val in pairs(dirs or {}) do
    f:write(string.format("%q,\n", val))
  end
  -- vim.notify("writing local file Dirs: ")
  f:write("}\n")
  f:write("--Last Line \n")
  f:close()
end

function M.delDir(dirs, dir)
  local new_table = {}
  for _, val in ipairs(dirs) do
    if val ~= dir then
      table.insert(new_table, val)
    end
  end
  M.saveCurrDir(new_table)
end

return M
