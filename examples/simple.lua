local text = require("luatext")

local my_str = text
  .Text
  :new("Hello world!!")
  :fg(160) -- red as an ANSI256 color code
  :bg({ 0, 0, 0 }) -- black as an RGB value
  :underlined()

print(my_str)
