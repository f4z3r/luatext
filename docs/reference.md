# LuaText

<!--toc:start-->
- [LuaText](#luatext)
  - [new](#new)
  - [text](#text)
  - [fg](#fg)
    - [fg example](#fg-example)
  - [bg](#bg)
    - [bg Example](#bg-example)
  - [bold](#bold)
  - [dim](#dim)
  - [italic](#italic)
  - [underlined](#underlined)
  - [blink](#blink)
  - [inverse](#inverse)
  - [hidden](#hidden)
  - [strikethrough](#strikethrough)
  - [framed](#framed)
  - [encircled](#encircled)
  - [overlined](#overlined)
  - [append](#append)
    - [append example](#append-example)
  - [render](#render)
  - [Color](#color)
  - [RESET](#reset)
<!--toc:end-->

## new

```lua
(method) LuaText:new(str?: string|LuaText) 
  -> LuaText
```

Create a new `LuaText` from a string.

Parameters:
- `str` — The text to be displayed in this `LuaText`.

---

## text

```lua
(method) LuaText:text(str: string)
  -> LuaText
```

Set the text of this `LuaText`.

Parameters:
- `str` — The text to be displayed in this `LuaText`.

---

## fg

```lua
(method) LuaText:fg(color: number|table)
  -> LuaText
```

Set the foreground color of this `LuaText`.

Parameters:
- `color` — The color to set. This can be either an ANSI256 color code, or a table of RGB values.

### fg example

```lua
local text = require("luatext")
print(text:new("Hello"):fg(160)) -- prints in red
print(text:new("Hi"):fg({0, 255, 0})) -- prints in green
```

---

## bg

```lua
(method) LuaText:bg(color: number|table)
  -> LuaText
```

Set the background color of this `LuaText`.

Parameters:
- `color` — The color to set. This can be either an ANSI256 color code, or a table of RGB values.

### bg Example

```lua
local text = require("luatext")
print(text:new("Hello"):bg(160)) -- prints on red background
print(text:new("Hi"):bg({0, 255, 0})) -- prints on green background
```

---

## bold

```lua
(method) LuaText:bold()
  -> LuaText
```

Make the fond bold.

---

## dim

```lua
(method) LuaText:dim()
  -> LuaText
```

Make the text dim.

---

## italic

```lua
(method) LuaText:italic()
  -> LuaText
```

Make the fond italic.

---

## underlined

```lua
(method) LuaText:underlined()
  -> LuaText
```

Make the text underlined.

---

## blink

```lua
(method) LuaText:blink()
  -> LuaText
```

Make the text blink.

---

## inverse

```lua
(method) LuaText:inverse()
  -> LuaText
```

Invert the text.

> Support for this may vary.

---

## hidden

```lua
(method) LuaText:inverse()
  -> LuaText
```

Hide the text

---

## strikethrough

```lua
(method) LuaText:strikethrough()
  -> LuaText
```

Make the text strikethrough.

---

## framed

```lua
(method) LuaText:framed()
  -> LuaText
```

Frame the text.

> Support for this may vary.

---

## encircled

```lua
(method) LuaText:encircled()
  -> LuaText
```

Encircle the text.

> Support for this may vary.

---

## overlined

```lua
(method) LuaText:overlined()
  -> LuaText
```

Make the text overlined.

> Support for this may vary.

---

## append

```lua
(method) LuaText:append(...string|LuaText)
  -> LuaText
```

Append one or more strings or `LuaText`s to this string. Appended elements will inherit the
formatting of the original string. This is used to apply additional formatting or overwrite
formatting from the original string for a substring.

Parameters:
- `...` — The strings to append.

### append example

Print a red string, in which the word `beautiful` is underlined:

```lua
local text = require("luatext")
local my_str = text
  :new()
  :fg(text.COLOR.RED)
  :append(
    "Hello ",
    text:new("beautiful"):underlined(),
    " world"
  )
print(my_str)
```

---

## render

```lua
(method) LuaText:render()
  -> string
```

Render the `LuaText`, turning it into an escaped string. This typically does not need to be
called explicitly, as the `LuaText` will automatically render when used in a `string` context
(such as when printing it).

---

## Color

```lua
table
```

Standard ANSI colors. Can be used in place of any color code. Available values are:

- `Black`
- `Red`
- `Green`
- `Yellow`
- `Blue`
- `Magenta`
- `Cyan`
- `White`

---

## RESET

```lua
string
```

The ANSI escape to reset all formatting. This is only to be used in bogus cases. A `LuaText`
will automatically reset the formatting at the very end of the string to avoid formatting leaking
into following text.
