local string = require("string")
local table = require("table")

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

---@class ColoredString
---a string to which colors and modifiers can be applied
---@field RESET string ANSI escape to reset all formatting
local ColoredString = {
  RESET = ESCAPE_START .. ESCAPE_CODES.reset .. ESCAPE_END,
}

---create a new ColoredString from a string
---@param str ColoredString|string?
---@return ColoredString
function ColoredString:new(str)
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

---set the text of this ColoredString
---@param str string
---@return ColoredString
function ColoredString:text(str)
  self._data = str
  return self
end

---set the foreground color of this ColoredString
---@param color number|table either an ANSI256 color code, or a RGB table
---@return ColoredString
function ColoredString:fg(color)
  self._colors.fg = color
  return self
end

---set the background color of this ColoredString
---@param color number|table either an ANSI256 color code, or a RGB table
---@return ColoredString
function ColoredString:bg(color)
  self._colors.bg = color
  return self
end

---apply the bold modifier
---@return ColoredString
function ColoredString:bold()
  self._modifiers.bold = true
  return self
end

---apply the dim modifier
---@return ColoredString
function ColoredString:dim()
  self._modifiers.dim = true
  return self
end

---apply the italic modifier
---@return ColoredString
function ColoredString:italic()
  self._modifiers.italic = true
  return self
end

---apply the underlined modifier
---@return ColoredString
function ColoredString:underlined()
  self._modifiers.underlined = true
  return self
end

---apply the blink modifier
---@return ColoredString
function ColoredString:blink()
  self._modifiers.blink = true
  return self
end

---apply the inverse modifier
---@return ColoredString
function ColoredString:inverse()
  self._modifiers.inverse = true
  return self
end

---apply the hidden modifier
---@return ColoredString
function ColoredString:hidden()
  self._modifiers.hidden = true
  return self
end

---apply the strikethrough modifier
---@return ColoredString
function ColoredString:strikethrough()
  self._modifiers.strikethrough = true
  return self
end

---apply the framed modifier
---@return ColoredString
function ColoredString:framed()
  self._modifiers.framed = true
  return self
end

---apply the encircled modifier
---@return ColoredString
function ColoredString:encircled()
  self._modifiers.encircled = true
  return self
end

---apply the overlined modifier
---@return ColoredString
function ColoredString:overlined()
  self._modifiers.overlined = true
  return self
end

---append strings to this ColoredString
---@vararg string|ColoredString
---@return ColoredString
function ColoredString:append(...)
  self._children = self._children or {}
  local varargs = { ... }
  for _, str in ipairs(varargs) do
    self._children[#self._children + 1] = ColoredString:new(str)
  end
  return self
end

---return the children substrings of this ColoredString
---@return ColoredString[]
---@private
function ColoredString:children()
  return self._children or {}
end

---return the formatting prefix for this ColoredString
---@return string
---@private
function ColoredString:prefix()
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

---render the ColoredString without resetting the colors at the string edges
---@return string
---@private
function ColoredString:render_no_reset()
  local res = self:prefix()
  res = res .. self._data
  for _, str in ipairs(self:children()) do
    res = res .. str:render_no_reset()
    res = res .. self.RESET
    res = res .. self:prefix()
  end
  return res
end

---render the ColoredString, turning it into an escaped string
---@return string
function ColoredString:render()
  local res = self.RESET
  res = res .. self:render_no_reset()
  res = res .. self.RESET
  return res
end

function ColoredString.__concat(self, other)
  if type(other) == "string" then return ColoredString:new(self):render() .. other end
  return ColoredString:new(self):append(other)
end

function ColoredString.__tostring(self)
  return self:render()
end

return ColoredString
