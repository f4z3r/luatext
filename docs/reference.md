# LuaText

<!--toc:start-->
- [LuaText](#luatext)
  - [Text](#text)
    - [new](#new)
    - [text](#text)
    - [get_raw_text](#getrawtext)
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

## Text

### new

```lua
(method) Text:new(str?: string|Text)
  -> Text
```

Create a new `Text` from a string.

Parameters:
- `str` — The text to be displayed in this `Text`.

---

### text

```lua
(method) Text:text(str: string)
  -> Text
```

Set the text of this `Text`.

Parameters:
- `str` — The text to be displayed in this `Text`.

---

### get_raw_text

```lua
(method) Text:get_raw_text()
  -> string
```

Retrieve the raw text contained within the `Text` object.

---

### fg

```lua
(method) Text:fg(color: number|table)
  -> Text
```

Set the foreground color of this `Text`.

Parameters:
- `color` — The color to set. This can be either an ANSI256 color code, or a table of RGB values.

#### fg example

```lua
local text = require("luatext")
print(text.Text:new("Hello"):fg(160)) -- prints in red
print(text.Text:new("Hi"):fg({0, 255, 0})) -- prints in green
```

---

### bg

```lua
(method) Text:bg(color: number|table)
  -> Text
```

Set the background color of this `Text`.

Parameters:
- `color` — The color to set. This can be either an ANSI256 color code, or a table of RGB values.

#### bg Example

```lua
local text = require("luatext")
print(text.Text:new("Hello"):bg(160)) -- prints on red background
print(text.Text:new("Hi"):bg({0, 255, 0})) -- prints on green background
```

---

### bold

```lua
(method) Text:bold()
  -> Text
```

Make the fond bold.

---

### dim

```lua
(method) Text:dim()
  -> Text
```

Make the text dim.

---

### italic

```lua
(method) Text:italic()
  -> Text
```

Make the fond italic.

---

### underlined

```lua
(method) Text:underlined()
  -> Text
```

Make the text underlined.

---

### blink

```lua
(method) Text:blink()
  -> Text
```

Make the text blink.

---

### inverse

```lua
(method) Text:inverse()
  -> Text
```

Invert the text.

> Support for this may vary.

---

### hidden

```lua
(method) Text:inverse()
  -> Text
```

Hide the text

---

### strikethrough

```lua
(method) Text:strikethrough()
  -> Text
```

Make the text strikethrough.

---

### framed

```lua
(method) Text:framed()
  -> Text
```

Frame the text.

> Support for this may vary.

---

### encircled

```lua
(method) Text:encircled()
  -> Text
```

Encircle the text.

> Support for this may vary.

---

### overlined

```lua
(method) Text:overlined()
  -> Text
```

Make the text overlined.

> Support for this may vary.

---

### append

```lua
(method) Text:append(...string|Text)
  -> Text
```

Append one or more strings or `Text`s to this string. Appended elements will inherit the
formatting of the original string. This is used to apply additional formatting or overwrite
formatting from the original string for a substring.

Parameters:
- `...` — The strings to append.

#### append example

Print a red string, in which the word `beautiful` is underlined:

```lua
local text = require("luatext")
local my_str = text
  .Text
  :new()
  :fg(text.Color.Red)
  :append(
    "Hello ",
    text.Text:new("beautiful"):underlined(),
    " world"
  )
print(my_str)
```

---

### render

```lua
(method) Text:render()
  -> string
```

Render the `Text`, turning it into an escaped string. This typically does not need to be
called explicitly, as the `Text` will automatically render when used in a `string` context
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

The ANSI escape to reset all formatting. This is only to be used in bogus cases. A `Text`
will automatically reset the formatting at the very end of the string to avoid formatting leaking
into following text.
