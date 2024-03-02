# LuaText

<!--toc:start-->
- [LuaText](#luatext)
  - [`ColoredString`](#coloredstring)
    - [`new`](#new)
    - [`text`](#text)
    - [`fg`](#fg)
    - [bg](#bg)
    - [bold](#bold)
    - [dim](#dim)
    - [italic](#italic)
    - [render](#render)
    - [RESET](#reset)
    - [underlined](#underlined)
    - [add_substring](#addsubstring)
<!--toc:end-->

## `ColoredString`

<!-- TODO add general desciption about the usage -->

### `new`

```lua
(method) ColoredString:new(str?: string|ColoredString)
  -> ColoredString
```

Create a new `ColoredString` from a string.

@_param_ `str` — The text to be displayed in this `ColoredString`.

### `text`

```lua
(method) ColoredString:text(str: string)
  -> ColoredString
```

Set the text of this `ColoredString`.

@_param_ `str` — The text to set.

### `fg`

```lua
(method) ColoredString:fg(color: number)
  -> ColoredString
```

Set the foreground color of this `ColoredString`.

@_param_ `color` — The color to set.

### bg


```lua
(method) ColoredString:bg(color: number)
  -> ColoredString
```

set the background color of this ColoredString

### bold


```lua
(method) ColoredString:bold()
  -> ColoredString
```

set the font of this ColoredString to bold


### dim


```lua
(method) ColoredString:dim()
  -> ColoredString
```

set the font of this ColoredString to dim


### italic


```lua
(method) ColoredString:italic()
  -> ColoredString
```

set the font of this ColoredString to italic


### render


```lua
(method) ColoredString:render()
  -> string
```

render the ColoredString, turning it into an escaped string


### RESET


```lua
string
```

ANSI escape to reset all formating



### underlined

```lua
(method) ColoredString:underlined()
  -> ColoredString
```

set the font of this ColoredString to underlined


### add_substring

```lua
(method) ColoredString:add_substring(str: string|ColoredString)
  -> ColoredString
```

add a substring to this ColoredString. Substrings will inherit the formatting of their parent.

@_param_ `array` — The array to append to the end of this one
