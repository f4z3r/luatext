local string = require("string")

---@enum Layer
local Layer = {
  FG = 38, -- foreground
  BG = 48, -- background
}

local function format_color(layer, color)
  return string.format(string.char(27) .. "[%d;5;%dm", layer, color)
end

local function reset()
  return string.char(27) .. "[0m"
end

local ColoredString = {}

function ColoredString:new(str)
  local obj = str
  if type(str) ~= "table" then
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

function ColoredString:text(str)
  self._data = str
  return self
end

function ColoredString:fg(color)
  self._prefixes.fg = format_color(Layer.FG, color)
  return self
end

function ColoredString:bg(color)
  self._prefixes.bg = format_color(Layer.BG, color)
  return self
end

function ColoredString:bold()
  self._prefixes.bold = string.char(27) .. "[1m"
  return self
end

function ColoredString:dim()
  self._prefixes.dim = string.char(27) .. "[2m"
  return self
end

function ColoredString:italic()
  self._prefixes.italic = string.char(27) .. "[3m"
  return self
end

function ColoredString:underlined()
  self._prefixes.underlined = string.char(27) .. "[4m"
  return self
end

function ColoredString:add_substring(str)
  self._children = self._children or {}
  self._children[#self._children + 1] = ColoredString:new(str)
  return self
end

---@private
function ColoredString:children()
  return self._children or {}
end

---@private
function ColoredString:prefix()
  local prefix = ""
  for _, val in pairs(self._prefixes) do
    prefix = prefix .. val
  end
  return prefix
end

---@private
function ColoredString:render_no_reset()
  local res = self:prefix()
  res = res .. self._data
  for _, str in ipairs(self:children()) do
    res = res .. str:render_no_reset()
    res = res .. reset()
    res = res .. self:prefix()
  end
  return res
end

function ColoredString:render()
  local res = reset()
  res = res .. self:render_no_reset()
  res = res .. reset()
  return res
end

function ColoredString.__concat(self, other)
  if type(other) == "string" then return ColoredString:new(self):render() .. other end
  return ColoredString:new(self):add_substring(other)
end

function ColoredString.__tostring(self)
  return self:render()
end

ColoredString.reset = reset

return ColoredString
