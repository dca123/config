--- @param art string[]
function ligatureArt(art)
  local newArt = {}
  for key, value in pairs(art) do
    local line = {}
    for i = 1, #value do
      local char = string.sub(value, i, i)
      table.insert(line, char)
      table.insert(line, "")
    end
    table.insert(newArt, table.concat(line))
  end
  return newArt
end

local default_header = {
  type = "text",
  val = ligatureArt({
    [[>>==========================================================<<]],
    [[||'##::::'##:'####::::::::::'########::'########:'##::::'##:]],
    [[ ##:::: ##:. ##::::::::::: ##.... ##: ##.....:: ##:::: ##:]],
    [[ ##:::: ##:: ##::::::::::: ##:::: ##: ##::::::: ##:::: ##:]],
    [[ #########:: ##::'####:::: ##:::: ##: ######::: ##:::: ##:]],
    [[ ##.... ##:: ##:: ####:::: ##:::: ##: ##...::::. ##:: ##::]],
    [[ ##:::: ##:: ##::. ##::::: ##:::: ##: ##::::::::. ## ##:::]],
    [[ ##:::: ##:'####:'##:::::: ########:: ########:::. ###::::]],
    [[..:::::..::....::..:::::::........:::........:::::...:::::||]],
    [[>>==========================================================<<]]
  }),
  opts = {
    position = "center",
  }
}
local section = {
  header = default_header
}
local config = {
  layout = {
    section.header
  }
}

local M = {
  config = config

}
return M
