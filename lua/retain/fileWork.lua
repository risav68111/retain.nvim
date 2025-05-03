local M = {}

local home_dir = vim.fn.expand("~")                -- home directory
local curr_dir = vim.fn.getcwd() or vim.loop.cwd() -- current directory

local function isWin()
  if string.find(home_dir, "C:\\Users\\") then
    return true
  end
  return false
end

-- LOL What is this KEKW
-- local aft_home = isWin() and "AppData\\Local\\nvim-data\\retain-list" or ".config/nvim-data/retain-list"
-- local file_path = home_dir .. "\\" .. aft_home

local file_path = vim.fn.stdpath("data") .. "/retain-list"
local file_name = "directory-list.lua"
local file_dir = file_path .. "\\" .. file_name

-- print(string.format("%q \n %q \n %q \n %q \n ",  home_dir, aft_home, file_path, file_name))

local function createFileAndDirectory()
  vim.fn.mkdir(file_path, "p")
  local file = io.open(file_dir, "w")
  if file then
    file:write("return {\n")
    file:write("}\n")
    file:write("-- lastLine")
    file:close()
  end
end

local function fileExists()
  local f = io.open(file_dir, "r")
  if f then
    return true
  end
  return false
end

function M.getList()
  if not fileExists() then
    createFileAndDirectory()
  end
  local ok, data = pcall(dofile, file_dir)
  local file     = ok and data or {}
  return file
end

-- function M.isThere()
--   for _, val in ipairs(file) do
--     if val == curr_dir then
--       return true
--     end
--   end
--   return false
-- end

function M.appen(dirs)
  table.insert(dirs, vim.fn.getcwd())
end

function M.saveCurrDir(file)
  local f = io.open(file_dir, 'w')
  if not f then
    createFileAndDirectory()
    return
  end
  f:write("return {\n")
  for _, val in pairs(file or {}) do
    f:write(string.format(" %q,\n", val))
  end
  f:write("}\n")
  f:write("--Last Line \n")
  f:close()
end

return M
