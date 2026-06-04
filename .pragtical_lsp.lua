-- Playdate SDK workspace settings for lua-language-server (read by Pragtical LSP plugin)
-- Machine-specific paths live in .pragtical_lsp.local.lua (see .pragtical_lsp.local.lua.example)

local function config_dir()
  local source = debug.getinfo(1, "S").source
  if source:sub(1, 1) == "@" then
    source = source:sub(2)
  end
  return source:match("^(.*)/[^/]+$") or "."
end

local function load_local()
  local path = config_dir() .. "/.pragtical_lsp.local.lua"
  local file = io.open(path, "r")
  if not file then
    return {}
  end
  file:close()

  local ok, result = pcall(dofile, path)
  if not ok then
    error(".pragtical_lsp.local.lua failed to load: " .. tostring(result))
  end
  if type(result) ~= "table" then
    error(".pragtical_lsp.local.lua must return a table")
  end
  return result
end

local local_config = load_local()
local sdk = local_config.PLAYDATE_SDK_PATH or os.getenv("PLAYDATE_SDK_PATH")
if not sdk or sdk == "" then
  error(
    "PLAYDATE_SDK_PATH is not set. Copy .pragtical_lsp.local.lua.example "
      .. "to .pragtical_lsp.local.lua and set your SDK path."
  )
end

return {
  Lua = {
    workspace = {
      library = { sdk .. "/CoreLibs" },
    },
    diagnostics = {
      globals = {
        "playdate",
        "import",
      },
      severity = {
        ["duplicate-set-field"] = "Hint",
      },
    },
    format = {
      defaultConfig = {
        indent_style = "space",
        indent_size = "4",
      },
    },
    runtime = {
      nonstandardSymbol = {
        "+=", "-=", "*=", "/=", "//=", "%=",
        "<<=", ">>=", "&=", "|=", "^=",
      },
      builtin = {
        io = "disable",
        os = "disable",
        package = "disable",
      },
      version = "Lua 5.4",
    },
  },
}
