local text = require("luatext")

local my_str = text
    :new()
    :fg(160)
    :append(
      "Hello ",
      text:new("beautiful"):underlined(),
      " world"
    )

print(my_str)
