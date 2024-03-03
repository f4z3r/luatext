local text = require("luatext")

local my_str = text
    :new()
    :fg(text.Color.Red)
    :append(
      "Hello ",
      text:new("beautiful"):underlined(),
      " world"
    )

print(my_str)
