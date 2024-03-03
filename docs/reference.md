# LuaText

<!--toc:start-->
- [LuaText](#luatext)
  - [`ColoredString`](#coloredstring)
    - [`new`](#new)
    - [`text`](#text)
    - [`fg`](#fg)
    - [`fg_rgb`](#fg_rgb)
    - [`bg`](#bg)
    - [`bg_rgb`](#bg_rgb)
    - [`bold`](#bold)
    - [`dim`](#dim)
    - [`italic`](#italic)
    - [`underlined`](#underlined)
    - [`add_substrings`](#add_substrings)
    - [`render`](#render)
    - [`RESET`](#reset)
<!--toc:end-->

## `ColoredString`

<!-- TODO add general desciption about the usage -->

### `new`

```lua
(method) ColoredString:new(str?: string|ColoredString)
  -> ColoredString
```

Create a new `ColoredString` from a string.

- @_param_ `str` — The text to be displayed in this `ColoredString`.

### `text`

```lua
(method) ColoredString:text(str: string)
  -> ColoredString
```

Set the text of this `ColoredString`.

- @_param_ `str` — The text to set.

### `fg`

```lua
(method) ColoredString:fg(color: number)
  -> ColoredString
```

Set the foreground color of this `ColoredString`.

- @_param_ `color` — The color to set, as an ANSI color code.

### `fg_rgb`

```lua
(method) ColoredString:fg_rgb(r: number, g: number, b: number)
  -> ColoredString
```

Set the foreground color of this `ColoredString` to an RGB value.

- @_param_ `r` — The red value to set (between 0 and 255).
- @_param_ `g` — The green value to set (between 0 and 255).
- @_param_ `b` — The blue value to set (between 0 and 255).

### `bg`

```lua
(method) ColoredString:bg(color: number)
  -> ColoredString
```

Set the background color of this `ColoredString`.

- @_param_ `color` — The color to set, as an ANSI color code.

### `bg_rgb`

```lua
(method) ColoredString:bg_rgb(r: number, g: number, b: number)
  -> ColoredString
```

Set the background color of this `ColoredString` to an RGB value.

- @_param_ `r` — The red value to set (between 0 and 255).
- @_param_ `g` — The green value to set (between 0 and 255).
- @_param_ `b` — The blue value to set (between 0 and 255).

### `bold`

```lua
(method) ColoredString:bold()
  -> ColoredString
```

Set the font of this `ColoredString` to bold.

### `dim`

```lua
(method) ColoredString:dim()
  -> ColoredString
```

Set the font of this `ColoredString` to dim.

### `italic`

```lua
(method) ColoredString:italic()
  -> ColoredString
```

Set the font of this `ColoredString` to italic.

### `underlined`

```lua
(method) ColoredString:underlined()
  -> ColoredString
```

Set the font of this `ColoredString` to underlined.

### `blink`

```lua
(method) ColoredString:blink()
  -> ColoredString
```

Set the text of this `ColoredString` to blink.

### `crossed`

```lua
(method) ColoredString:crossed()
  -> ColoredString
```

Set the font of this `ColoredString` to crossed-out.

### `add_substrings`

```lua
(method) ColoredString:add_substrings(...string|ColoredString)
  -> ColoredString
```

Add one or more substrings to this `ColoredString`. Substrings will inherit the formatting of the
parent string but can add additional formatting properties or overwrite the properties of the
parent.

@_vararg_ — The substrings to add to this `ColoredString`.

### `render`

```lua
(method) ColoredString:render()
  -> string
```

Render the `ColoredString`, turning it into an escaped string. This typically does not need to be
called explicitly, as the `ColoredString` will automatically render when used in a `string` context
(such as when printing it).

### `RESET`

```lua
string
```

The ANSI escape to reset all formatting. This is only to be used in bogus cases. A `ColoredString`
will automatically reset the formatting at the very end of the string to avoid formatting leaking
into following text.
