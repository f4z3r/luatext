local string = require("string")

local ESCAPE = string.char(27)

---@enum Layer
local Layer = {
  FG = 38, -- foreground
  BG = 48, -- background
}

---return the ANSI escape string for a color
---@param layer Layer
---@param color number
---@return string
local function format_color(layer, color)
  return string.format(ESCAPE .. "[%d;5;%dm", layer, color)
end

---@class ColoredString
---a string to which colors and modifiers can be applied
---@field RESET string ANSI escape to reset all formating
local ColoredString = {
  RESET = ESCAPE .. "[0m",
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
      _prefixes = {},
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
---@param color number
---@return ColoredString
function ColoredString:fg(color)
  self._prefixes.fg = format_color(Layer.FG, color)
  return self
end

---set the background color of this ColoredString
---@param color number
---@return ColoredString
function ColoredString:bg(color)
  self._prefixes.bg = format_color(Layer.BG, color)
  return self
end

---set the font of this ColoredString to bold
---@return ColoredString
function ColoredString:bold()
  self._prefixes.bold = ESCAPE .. "[1m"
  return self
end

---set the font of this ColoredString to dim
---@return ColoredString
function ColoredString:dim()
  self._prefixes.dim = ESCAPE .. "[2m"
  return self
end

---set the font of this ColoredString to italic
---@return ColoredString
function ColoredString:italic()
  self._prefixes.italic = ESCAPE .. "[3m"
  return self
end

---set the font of this ColoredString to underlined
---@return ColoredString
function ColoredString:underlined()
  self._prefixes.underlined = ESCAPE .. "[4m"
  return self
end

---add a substring to this ColoredString. Substrings will inherit the formating of their parent.
---@param str string|ColoredString
---@return ColoredString
function ColoredString:add_substring(str)
  self._children = self._children or {}
  self._children[#self._children + 1] = ColoredString:new(str)
  return self
end

---return the children substrings of this ColoredString
---@return ColoredString[]
---@private
function ColoredString:children()
  return self._children or {}
end

---return the formating prefix for this ColoredString
---@return string
---@private
function ColoredString:prefix()
  local prefix = ""
  for _, val in pairs(self._prefixes) do
    prefix = prefix .. val
  end
  return prefix
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
  return ColoredString:new(self):add_substring(other)
end

function ColoredString.__tostring(self)
  return self:render()
end

return ColoredString
