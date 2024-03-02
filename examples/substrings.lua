local text = require("luatext")

local my_str = text
    :new()
    :fg(160)
    :add_substrings(
      "Hello ",
      text:new("beautiful"):underlined(),
      " world"
    )

print(my_str)
