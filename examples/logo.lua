local text = require("luatext")

local logo = text.Text
  :new()
  :fg(text.Color.Red)
  :append(
    "[",
    text.Text:new("Lua"):fg(text.Color.Cyan):dim(),
    text.Text:new("Text"):fg(text.Color.Yellow):bold(),
    "]"
  )

print()
print(logo:render())
print()
