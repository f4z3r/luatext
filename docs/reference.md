# LuaText

<!--toc:start-->
- [LuaText](#luatext)
  - [ColoredString](#coloredstring)
    - [new](#new)
    - [text](#text)
    - [fg](#fg)
      - [Example](#example)
    - [bg](#bg)
      - [Example](#example)
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
      - [Example](#example)
    - [render](#render)
    - [RESET](#reset)
<!--toc:end-->

## ColoredString

<!-- TODO add general desciption about the usage -->

### new

```lua
(method) ColoredString:new(str?: string|ColoredString) 
  -> ColoredString
```

Create a new `ColoredString` from a string.

Parameters:
- `str` — The text to be displayed in this `ColoredString`.

### text

```lua
(method) ColoredString:text(str: string)
  -> ColoredString
```

Set the text of this `ColoredString`.

Parameters:
- `str` — The text to be displayed in this `ColoredString`.

### fg

```lua
(method) ColoredString:fg(color: number|table)
  -> ColoredString
```

Set the foreground color of this `ColoredString`.

Parameters:
- `color` — The color to set. This can be either an ANSI256 color code, or a table of RGB values.

#### Example

```lua
local text = require("luatext")
print(text:new("Hello"):fg(160)) -- prints in red
print(text:new("Hi"):fg({0, 255, 0})) -- prints in green
```

### bg

```lua
(method) ColoredString:bg(color: number|table)
  -> ColoredString
```

Set the background color of this `ColoredString`.

Parameters:
- `color` — The color to set. This can be either an ANSI256 color code, or a table of RGB values.

#### Example

```lua
local text = require("luatext")
print(text:new("Hello"):bg(160)) -- prints on red background
print(text:new("Hi"):bg({0, 255, 0})) -- prints on green background
```

### bold

```lua
(method) ColoredString:bold()
  -> ColoredString
```

Make the fond bold.

### dim

```lua
(method) ColoredString:dim()
  -> ColoredString
```

Make the text dim.

### italic

```lua
(method) ColoredString:italic()
  -> ColoredString
```

Make the fond italic.

### underlined

```lua
(method) ColoredString:underlined()
  -> ColoredString
```

Make the text underlined.

### blink

```lua
(method) ColoredString:blink()
  -> ColoredString
```

Make the text blink.

### inverse

```lua
(method) ColoredString:inverse()
  -> ColoredString
```

Invert the text.

> Support for this may vary.

### hidden

```lua
(method) ColoredString:inverse()
  -> ColoredString
```

Hide the text

### strikethrough

```lua
(method) ColoredString:strikethrough()
  -> ColoredString
```

Make the text strikethrough.

### framed

```lua
(method) ColoredString:framed()
  -> ColoredString
```

Frame the text.

> Support for this may vary.

### encircled

```lua
(method) ColoredString:encircled()
  -> ColoredString
```

Encircle the text.

> Support for this may vary.

### overlined

```lua
(method) ColoredString:overlined()
  -> ColoredString
```

Make the text overlined.

> Support for this may vary.

### append

```lua
(method) ColoredString:append(...string|ColoredString)
  -> ColoredString
```

Append one or more strings or `ColoredString`s to this string. Appended elements will inherit the
formatting of the original string. This is used to apply additional formatting or overwrite
formatting from the original string for a substring.

Parameters:
- `...` — The strings to append.

#### Example

Print a red string, in which the word `beautiful` is underlined:

```lua
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
```

### render

```lua
(method) ColoredString:render()
  -> string
```

Render the `ColoredString`, turning it into an escaped string. This typically does not need to be
called explicitly, as the `ColoredString` will automatically render when used in a `string` context
(such as when printing it).

### RESET

```lua
string
```

The ANSI escape to reset all formatting. This is only to be used in bogus cases. A `ColoredString`
will automatically reset the formatting at the very end of the string to avoid formatting leaking
into following text.
