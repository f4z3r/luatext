local string = require("string")
local table = require("table")

--- compatibility
local unpack = unpack
do
  local version = string.match(_VERSION, "%d.(%d)")
  if tonumber(version) > 3 then unpack = table.unpack end
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

---@class LuaText
---a string to which colors and modifiers can be applied
---@field RESET string ANSI escape to reset all formatting
---@field COLOR table ANSI standard colors
local LuaText = {
  RESET = ESCAPE_START .. ESCAPE_CODES.reset .. ESCAPE_END,
  COLOR = {
    BLACK = 0,
    RED = 1,
    GREEN = 2,
    YELLOW = 3,
    BLUE = 4,
    MAGENTA = 5,
    CYAN = 6,
    WHITE = 7,
  },
}

---create a new LuaText from a string
---@param str LuaText|string?
---@return LuaText
function LuaText:new(str)
  local obj = str
  if type(obj) ~= "table" then
    str = str or ""
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

---set the text of this LuaText
---@param str string
---@return LuaText
function LuaText:text(str)
  self._data = str
  return self
end

---set the foreground color of this LuaText
---@param color number|table either an ANSI256 color code, or a RGB table
---@return LuaText
function LuaText:fg(color)
  self._colors.fg = color
  return self
end

---set the background color of this LuaText
---@param color number|table either an ANSI256 color code, or a RGB table
---@return LuaText
function LuaText:bg(color)
  self._colors.bg = color
  return self
end

---apply the bold modifier
---@return LuaText
function LuaText:bold()
  self._modifiers.bold = true
  return self
end

---apply the dim modifier
---@return LuaText
function LuaText:dim()
  self._modifiers.dim = true
  return self
end

---apply the italic modifier
---@return LuaText
function LuaText:italic()
  self._modifiers.italic = true
  return self
end

---apply the underlined modifier
---@return LuaText
function LuaText:underlined()
  self._modifiers.underlined = true
  return self
end

---apply the blink modifier
---@return LuaText
function LuaText:blink()
  self._modifiers.blink = true
  return self
end

---apply the inverse modifier
---@return LuaText
function LuaText:inverse()
  self._modifiers.inverse = true
  return self
end

---apply the hidden modifier
---@return LuaText
function LuaText:hidden()
  self._modifiers.hidden = true
  return self
end

---apply the strikethrough modifier
---@return LuaText
function LuaText:strikethrough()
  self._modifiers.strikethrough = true
  return self
end

---apply the framed modifier
---@return LuaText
function LuaText:framed()
  self._modifiers.framed = true
  return self
end

---apply the encircled modifier
---@return LuaText
function LuaText:encircled()
  self._modifiers.encircled = true
  return self
end

---apply the overlined modifier
---@return LuaText
function LuaText:overlined()
  self._modifiers.overlined = true
  return self
end

---append strings to this LuaText
---@vararg string|LuaText
---@return LuaText
function LuaText:append(...)
  self._children = self._children or {}
  local varargs = { ... }
  for _, str in ipairs(varargs) do
    self._children[#self._children + 1] = LuaText:new(str)
  end
  return self
end

---return the children substrings of this LuaText
---@return LuaText[]
---@private
function LuaText:children()
  return self._children or {}
end

---return the formatting prefix for this LuaText
---@return string
---@private
function LuaText:prefix()
  local modifiers = {}
  for key, _ in pairs(self._modifiers) do
    modifiers[#modifiers + 1] = tostring(ESCAPE_CODES[key])
  end
  for key, val in pairs(self._colors) do
    if type(val) == "table" then
      modifiers[#modifiers + 1] = ESCAPE_CODES[key] .. string.format(RGB_FORMAT, unpack(val))
    else
      modifiers[#modifiers + 1] = ESCAPE_CODES[key] .. string.format(ANSI256_FORMAT, val)
    end
  end
  if #modifiers == 0 then return "" end
  return ESCAPE_START .. table.concat(modifiers, ";") .. ESCAPE_END
end

---render the LuaText without resetting the colors at the string edges
---@return string
---@private
function LuaText:render_no_reset()
  local res = self:prefix()
  res = res .. self._data
  for _, str in ipairs(self:children()) do
    res = res .. str:render_no_reset()
    res = res .. self.RESET
    res = res .. self:prefix()
  end
  return res
end

---render the LuaText, turning it into an escaped string
---@return string
function LuaText:render()
  local res = self.RESET
  res = res .. self:render_no_reset()
  res = res .. self.RESET
  return res
end

function LuaText.__concat(self, other)
  if type(other) == "string" then return LuaText:new(self):render() .. other end
  return LuaText:new(self):append(other)
end

function LuaText.__tostring(self)
  return self:render()
end

return LuaText
