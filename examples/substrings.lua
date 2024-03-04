local text = require("luatext")

local my_str = text.Text:new():fg(text.Color.Red):append("Hello ", text.Text:new("beautiful"):underlined(), " world")

print(my_str)
