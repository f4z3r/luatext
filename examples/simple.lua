local text = require("luatext")

local my_str = text
    :new("Hello world!!")
    :fg(160)
    :bg(16)
    :underlined()

print(my_str)
