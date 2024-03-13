local string = require("string")
local table = require("table")

--- compatibility
if not table.unpack and unpack then
  table.unpack = unpack
end

local ESCAPE_START = string.format("%c[", 27)
local ESCAPE_END = "m"
local RGB_FORMAT = ";2;%d;%d;%d"
local ANSI256_FORMAT = ";5;%d"

local ESCAPE_CODES = {
  reset = 0,
  bold = 1,
  dim = 2,
  italic = 3,
  underlined = 4,
  blink = 5,
  inverse = 7,
  hidden = 8,
  strikethrough = 9,
  framed = 51,
  encircled = 52,
  overlined = 53,
  fg = 38,
  bg = 48,
}

local luatext = {
  RESET = ESCAPE_START .. ESCAPE_CODES.reset .. ESCAPE_END,
}

---@class Text
---@field private _data string
---@field private _modifiers table<string, boolean>
---@field private _colors table<string, number|table>
local Text = {}

---@enum Color
local Color = {
  Black = 0,
  Red = 1,
  Green = 2,
  Yellow = 3,
  Blue = 4,
  Magenta = 5,
  Cyan = 6,
  White = 7,
  BrightBlack = 8,
  BrightRed = 9,
  BrightGreen = 10,
  BrightYellow = 11,
  BrightBlue = 12,
  BrightMagenta = 13,
  BrightCyan = 14,
  BrightWhite = 15,
}

luatext.Color = Color

---create a new Text from a string
---@param str Text|string?
---@return Text
function Text:new(str)
  local obj = str
  if type(obj) ~= "table" then
    str = str or ""
    ---@cast str string
    obj = {
      _data = str,
      _modifiers = {},
      _colors = {},
    }
  end
  setmetatable(obj, self)
  self.__index = self
  return obj
end

---set the text of this Text
---@param str string
---@return Text
function Text:text(str)
  self._data = str
  return self
end

---get the raw text of the Text object
---@return string
function Text:get_raw_text()
  if not self._children then
    return self._data
  else
    local res = self._data
    for _, child in ipairs(self._children) do
      res = res .. child:get_raw_text()
    end
    return res
  end
end

---set the foreground color of this Text
---@param color number|table either an ANSI256 color code, or a RGB table
---@return Text
function Text:fg(color)
  self._colors.fg = color
  return self
end

---set the background color of this Text
---@param color number|table either an ANSI256 color code, or a RGB table
---@return Text
function Text:bg(color)
  self._colors.bg = color
  return self
end

---apply the bold modifier
---@return Text
function Text:bold()
  self._modifiers.bold = true
  return self
end

---apply the dim modifier
---@return Text
function Text:dim()
  self._modifiers.dim = true
  return self
end

---apply the italic modifier
---@return Text
function Text:italic()
  self._modifiers.italic = true
  return self
end

---apply the underlined modifier
---@return Text
function Text:underlined()
  self._modifiers.underlined = true
  return self
end

---apply the blink modifier
---@return Text
function Text:blink()
  self._modifiers.blink = true
  return self
end

---apply the inverse modifier
---@return Text
function Text:inverse()
  self._modifiers.inverse = true
  return self
end

---apply the hidden modifier
---@return Text
function Text:hidden()
  self._modifiers.hidden = true
  return self
end

---apply the strikethrough modifier
---@return Text
function Text:strikethrough()
  self._modifiers.strikethrough = true
  return self
end

---apply the framed modifier
---@return Text
function Text:framed()
  self._modifiers.framed = true
  return self
end

---apply the encircled modifier
---@return Text
function Text:encircled()
  self._modifiers.encircled = true
  return self
end

---apply the overlined modifier
---@return Text
function Text:overlined()
  self._modifiers.overlined = true
  return self
end

---append strings to this Text
---@vararg string|Text
---@return Text
function Text:append(...)
  self._children = self._children or {}
  local varargs = { ... }
  for _, str in ipairs(varargs) do
    self._children[#self._children + 1] = Text:new(str)
  end
  return self
end

---return the children substrings of this Text
---@return Text[]
---@private
function Text:children()
  return self._children or {}
end

---return the formatting prefix for this Text
---@return string
---@private
function Text:prefix()
  local modifiers = {}
  for key, _ in pairs(self._modifiers) do
    modifiers[#modifiers + 1] = tostring(ESCAPE_CODES[key])
  end
  for key, val in pairs(self._colors) do
    if type(val) == "table" then
      modifiers[#modifiers + 1] = ESCAPE_CODES[key] .. string.format(RGB_FORMAT, table.unpack(val))
    else
      modifiers[#modifiers + 1] = ESCAPE_CODES[key] .. string.format(ANSI256_FORMAT, val)
    end
  end
  if #modifiers == 0 then
    return ""
  end
  return ESCAPE_START .. table.concat(modifiers, ";") .. ESCAPE_END
end

---render the Text without resetting the colors at the string edges
---@return string
---@private
function Text:render_no_reset()
  local res = self:prefix()
  res = res .. self._data
  for _, str in ipairs(self:children()) do
    res = res .. str:render_no_reset()
    res = res .. luatext.RESET
    res = res .. self:prefix()
  end
  return res
end

---render the Text, turning it into an escaped string
---@return string
function Text:render()
  local res = luatext.RESET
  res = res .. self:render_no_reset()
  res = res .. luatext.RESET
  return res
end

function Text.__concat(self, other)
  if type(other) == "string" then
    return Text:new(self):render() .. other
  end
  return Text:new(self):append(other)
end

function Text.__tostring(self)
  return self:render()
end

luatext.Text = Text

return luatext
